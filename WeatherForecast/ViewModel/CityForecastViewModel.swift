import Combine
import Foundation
import UIKit

final class CityForecastViewModel: ObservableObject {

    // MARK: - Types

    enum State {
        case fetching
        case error(Swift.Error)
        case result([PeriodModel])
    }

    typealias LocationMetadataDataPublisherType = (PointModel) -> AnyPublisher<LocationMetadataModel, Swift.Error>

    typealias WeeklyForecastPublisherType = (String, Int, Int) -> AnyPublisher<WeeklyForecastModel, Swift.Error>

    typealias IconPublisherType = (URL) -> AnyPublisher<UIImage, Error>

    // MARK: - Properties

    @Published var state: State?

    let city: City

    var periods: [PeriodModel] { state?.periods ?? [] }

    let locationMetadataDataPublisher: LocationMetadataDataPublisherType
    let weeklyForecastPublisher: WeeklyForecastPublisherType
    let iconPublisher: IconPublisherType

    private var subscriptions: Set<AnyCancellable> = []

    // MARK: - Initialization

    init(city: City,
         locationMetadataDataPublisher: @escaping LocationMetadataDataPublisherType,
         weeklyForecastPublisher: @escaping WeeklyForecastPublisherType,
         iconPublisher: @escaping IconPublisherType
    ) {
        self.city = city
        self.locationMetadataDataPublisher = locationMetadataDataPublisher
        self.weeklyForecastPublisher = weeklyForecastPublisher
        self.iconPublisher = iconPublisher
    }

    // MARK: - API

    func periodViewModelFor(_ period: PeriodModel) -> PeriodViewModel {

        PeriodViewModel(from: period, iconLoader: iconPublisher(URL(string: period.icon)!))
    }

    // MARK: - Helpers

    func load() {

        Just(city)
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { _ in

                self.state = .fetching
            })
        // Phase 1
            .flatMap { city -> AnyPublisher<LocationMetadataModel, Never> in

                return self.getLocationMetadataAt(latitude: city.latitude, longitude: city.longitude)
            }
        // Phase 2
            .flatMap { meta -> AnyPublisher<WeeklyForecastModel, Never> in

                self.getWeeklyForecast(wfo: meta.properties.gridId, x: meta.properties.gridX, y: meta.properties.gridY)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { forecast in

                self.state = .result(forecast.properties.periods)
            })
            .store(in: &subscriptions)
    }

    private func getLocationMetadataAt(latitude: Double, longitude: Double) -> AnyPublisher<LocationMetadataModel, Never> {

        locationMetadataDataPublisher(.init(lat: latitude, lon: longitude))
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveCompletion: { completion in

                switch completion {
                case .failure(let error):

                    self.state = .error(error)
                case .finished: break
                }
            })
            .map { Optional.some($0) }
            .replaceError(with: nil)
            .flatMap { $0.publisher }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    private func getWeeklyForecast(wfo: String, x: Int, y: Int) -> AnyPublisher<WeeklyForecastModel, Never> {

        weeklyForecastPublisher(wfo, x, y)
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveCompletion: { completion in

                switch completion {
                case .failure(let error):

                    self.state = .error(error)
                case .finished: break
                }
            })
            .map { Optional.some($0) }
            .replaceError(with: nil)
            .flatMap { $0.publisher }
            .eraseToAnyPublisher()
    }
}

extension CityForecastViewModel.State {
    
    var error: Swift.Error? {
        if case .error(let error) = self {
            return error
        } else {
            return nil
        }
    }

    var periods: [PeriodModel] {
        if case .result(let periods) = self {
            return periods
        } else {
            return []
        }
    }
}
