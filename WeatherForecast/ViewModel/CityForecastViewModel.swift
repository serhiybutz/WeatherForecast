import Combine
import Foundation

class CityForecastViewModel: ObservableObject {

    // MARK: - Types

    enum State {
        case fetching
        case error(Swift.Error)
        case result([WeatherGovWebAPI.Period])
    }

    typealias LocationMetadataDataPublisherType = (WeatherGovWebAPI.Point) -> AnyPublisher<WeatherGovWebAPI.LocationMetadata, Swift.Error>

    typealias WeeklyForecastPublisherType = (String, Int, Int) -> AnyPublisher<WeatherGovWebAPI.WeeklyForecast, Swift.Error>

    // MARK: - Properies

    @Published var state: State?

    let cityViewModel: CityViewModel

    var periods: [PeriodViewModel] {
        (state?.periods ?? []).map { PeriodViewModel($0) }
    }

    let locationMetadataDataPublisher: LocationMetadataDataPublisherType
    let weeklyForecastPublisher: WeeklyForecastPublisherType

    private var subscriptions: Set<AnyCancellable> = []

    // MARK: - Initialization

    init(cityViewModel: CityViewModel,
         locationMetadataDataPublisher: @escaping LocationMetadataDataPublisherType = WeatherGovWebAPI.locationMetadataDataPublisher,
         weeklyForecastPublisher: @escaping WeeklyForecastPublisherType = WeatherGovWebAPI.weeklyForecastPublisher
    ) {
        self.cityViewModel = cityViewModel
        self.locationMetadataDataPublisher = locationMetadataDataPublisher
        self.weeklyForecastPublisher = weeklyForecastPublisher
        configure()
    }

    // MARK: - Helpers

    private func configure() {

        Just(cityViewModel)
            .handleEvents(receiveOutput: { _ in

                Thread.runOnMainThreadSync {
                    self.state = .fetching
                }
            })
        // Phase 1
            .flatMap { city -> AnyPublisher<WeatherGovWebAPI.LocationMetadata, Never> in

                self.getLocationMetadataAt(latitude: city.latitude, longitude: city.longitude)
            }
        // Phase 2
            .flatMap { meta in

                self.getWeeklyForecast(wfo: meta.properties.gridId, x: meta.properties.gridX, y:  meta.properties.gridY)
            }
            .sink(receiveValue: { forecast in

                Thread.runOnMainThreadSync {
                    self.state = .result(forecast.properties.periods)
                }
            })
            .store(in: &subscriptions)
    }

    private func getLocationMetadataAt(latitude: Double, longitude: Double) -> AnyPublisher<WeatherGovWebAPI.LocationMetadata, Never> {

        locationMetadataDataPublisher(.init(lat: latitude, lon: longitude))
            .handleEvents(receiveCompletion: { completion in

                switch completion {
                case .failure(let error):
                    Thread.runOnMainThreadSync {
                        self.state = .error(error)
                    }
                case .finished: break
                }
            })
            .map { Optional.some($0) }
            .replaceError(with: nil)
            .flatMap { $0.publisher }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    private func getWeeklyForecast(wfo: String, x: Int, y: Int) -> AnyPublisher<WeatherGovWebAPI.WeeklyForecast, Never> {

        weeklyForecastPublisher(wfo, x, y)
            .handleEvents(receiveCompletion: { completion in

                switch completion {
                case .failure(let error):
                    Thread.runOnMainThreadSync {
                        self.state = .error(error)
                    }
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

    var periods: [WeatherGovWebAPI.Period] {
        if case .result(let periods) = self {
            return periods
        } else {
            return []
        }
    }
}
