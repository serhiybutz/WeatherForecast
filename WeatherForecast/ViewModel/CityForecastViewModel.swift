import Combine
import Foundation

class CityForecastViewModel: ObservableObject {

    // MARK: - Types

    enum State {
        case fetching
        case error(Swift.Error)
        case result([WeatherGovWebAPI.Period])
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

    // MARK: - Properies

    @Published var state: State?

    let cityViewModel: CityViewModel

    var periods: [PeriodViewModel] {
        (state?.periods ?? []).map { PeriodViewModel($0) }
    }

    private var subscriptions: Set<AnyCancellable> = []

    // MARK: - Initialization

    init(cityViewModel: CityViewModel) {
        self.cityViewModel = cityViewModel

        Just(cityViewModel)
            .handleEvents(receiveOutput: { _ in

                Thread.runOnMainThreadSync {
                    self.state = .fetching
                }
            })
            // Phase 1
            .flatMap { city -> AnyPublisher<WeatherGovWebAPI.LocationMetadata, Never> in

                WeatherGovWebAPI.locationMetadataDataPublisher(point: .init(lat: city.latitude, lon: city.longitude))
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
            // Phase 2
            .flatMap { meta in

                WeatherGovWebAPI.dailyForecastPublisher(
                    wfo: meta.properties.gridId,
                    x: meta.properties.gridX,
                    y: meta.properties.gridY
                )
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
            .sink(receiveValue: { forecast in
                Thread.runOnMainThreadSync {
                    self.state = .result(forecast.properties.periods)
                }
            })
            .store(in: &subscriptions)
    }
}
