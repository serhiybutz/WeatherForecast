import Combine
import Foundation
import OSLog

/*
 Source: https://www.weather.gov/documentation/services-web-api

 API Requests

 * Request metadata for the location with coords 39.7456,-97.0892:

 Example: https://api.weather.gov/points/39.7456,-97.0892

 * Request a weekly textual forecast by:
   Forecast office ID: LWX
   Forecast grid X coordinate: 97
   Forecast grid Y coordinate: 71

 Example: https://api.weather.gov/gridpoints/LWX/97,71/forecast.
 */

class WeatherGovWebAPI {

    enum Error: Swift.Error {
        case `internal`(statusCode: Int)
        case server(statusCode: Int)
        case unknown

        var localizedDescription: String {
            switch self {
            case .internal(let statusCode): return "Internal error, status code: \(statusCode)"
            case .server(let statusCode): return "Server error, status code: \(statusCode)"
            case .unknown: return "Unknown error"
            }
        }
    }

    private var subscriptions: Set<AnyCancellable> = []

    static private func dataTaskPublisher(for url: URL) -> AnyPublisher<Data, Swift.Error> {

        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in

                guard let httpResponse = response as? HTTPURLResponse else {
                    throw Error.unknown
                }

                guard 200..<300 ~= httpResponse.statusCode
                else {
                    switch httpResponse.statusCode {
                    case 400...499:
                        throw Error.internal(statusCode: httpResponse.statusCode)
                    default:
                        throw Error.server(statusCode: httpResponse.statusCode)
                    }
                }

                return data
            }

            .eraseToAnyPublisher()
    }

    static func locationMetadataDataPublisher(point: Point) -> AnyPublisher<LocationMetadata, Swift.Error> {

        guard let endpointURL = LocationMetadataEndpoint(location: point).url
        else {
            return Fail(error: URLError(URLError.badURL)).eraseToAnyPublisher()
        }

        return dataTaskPublisher(for: endpointURL)
            .decode(type: LocationMetadata.self, decoder: JSONDecoder())
            .handleEvents(receiveOutput: { meta in

                os_log(.info, log: OSLog.default, "Fetching point {\(point.lat),\(point.lon)} metadata succeded: \(meta.properties.gridId), \(meta.properties.gridX), \(meta.properties.gridY)")
            }, receiveCompletion: {

                if case .failure(let error) = $0 {
                    os_log(.error, log: OSLog.default, "Fetching point {\(point.lat),\(point.lon)} metadata failed: \((error as? WeatherGovWebAPI.Error)?.localizedDescription ?? error.localizedDescription)")
                }
            })
            .eraseToAnyPublisher()
    }

    static func weeklyForecastPublisher(wfo: String, x: Int, y: Int) -> AnyPublisher<WeeklyForecast, Swift.Error> {

        guard let endpointURL = GridpointForecastEndpoint(wfo: wfo, x: x, y: y).url
        else {
            return Fail(error: URLError(URLError.badURL)).eraseToAnyPublisher()
        }

        return dataTaskPublisher(for: endpointURL)
            .decode(type: WeeklyForecast.self, decoder: JSONDecoder())
            .handleEvents(receiveOutput: { forecast in

                os_log(.info, log: OSLog.default, "Fetching forecast for WFO: \(wfo), x: \(x), y: \(y) succeded: downloaded \(forecast.properties.periods.count) periods")
            }, receiveCompletion: {

                if case .failure(let error) = $0 {
                    os_log(.error, log: OSLog.default, "Fetching forecast for WFO: \(wfo), x: \(x), y: \(y) failed: \((error as? WeatherGovWebAPI.Error)?.localizedDescription ?? error.localizedDescription)")
                }
            })
            .eraseToAnyPublisher()
    }

    static func iconDownloadPublisher(url: URL) -> AnyPublisher<Data, Swift.Error> {

        return dataTaskPublisher(for: url)
            .handleEvents(receiveOutput: { forecast in

                os_log(.info, log: OSLog.default, "Fetching icon \(url) succeded")
            }, receiveCompletion: {

                if case .failure(let error) = $0 {
                    os_log(.error, log: OSLog.default, "Fetching icon \(url) failed: \((error as? WeatherGovWebAPI.Error)?.localizedDescription ?? error.localizedDescription)")
                }
            })
            .eraseToAnyPublisher()
    }
}

extension WeatherGovWebAPI {

    static let host = "api.weather.gov"
}
