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

final class WeatherGovWebAPI {

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

    enum DataTaskPublisherArg {
        case url(URL)
        case request(URLRequest)
    }

    private func dataTaskPublisher(args: DataTaskPublisherArg) -> AnyPublisher<Data, Swift.Error> {

        let publisher: URLSession.DataTaskPublisher
        switch args {
        case .url(let url):
            publisher = URLSession.shared.dataTaskPublisher(for: url)
        case .request(let request):
            publisher = URLSession.shared.dataTaskPublisher(for: request)
        }

        return publisher
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

    func locationMetadataDataPublisher(point: Model.Point) -> AnyPublisher<Model.LocationMetadata, Swift.Error> {

        guard let request = LocationMetadataRequest(location: point)?.request
        else {
            return Fail(error: URLError(URLError.badURL)).eraseToAnyPublisher()
        }

        return dataTaskPublisher(args: .request(request))
            .decode(type: Model.LocationMetadata.self, decoder: JSONDecoder())
            .handleEvents(receiveOutput: { meta in

                dispatchPrecondition(condition: .notOnQueue(.main))

                os_log(.info, log: OSLog.default, "Fetching point {\(point.lat),\(point.lon)} metadata succeded: \(meta.properties.gridId), \(meta.properties.gridX), \(meta.properties.gridY)")
            }, receiveCompletion: {

                if case .failure(let error) = $0 {
                    os_log(.error, log: OSLog.default, "Fetching point {\(point.lat),\(point.lon)} metadata failed: \((error as? WeatherGovWebAPI.Error)?.localizedDescription ?? error.localizedDescription)")
                }
            })
            .eraseToAnyPublisher()
    }

    func weeklyForecastPublisher(wfo: String, x: Int, y: Int) -> AnyPublisher<Model.WeeklyForecast, Swift.Error> {

        guard let request = GridpointForecastRequest(wfo: wfo, x: x, y: y)?.request
        else {
            return Fail(error: URLError(URLError.badURL)).eraseToAnyPublisher()
        }

        return dataTaskPublisher(args: .request(request))
            .decode(type: Model.WeeklyForecast.self, decoder: JSONDecoder())
            .handleEvents(receiveOutput: { forecast in

                dispatchPrecondition(condition: .notOnQueue(.main))

                os_log(.info, log: OSLog.default, "Fetching forecast for WFO: \(wfo), x: \(x), y: \(y) succeded: downloaded \(forecast.properties.periods.count) periods")
            }, receiveCompletion: {

                if case .failure(let error) = $0 {
                    os_log(.error, log: OSLog.default, "Fetching forecast for WFO: \(wfo), x: \(x), y: \(y) failed: \((error as? WeatherGovWebAPI.Error)?.localizedDescription ?? error.localizedDescription)")
                }
            })
            .eraseToAnyPublisher()
    }

    func iconDownloadPublisher(url: URL) -> AnyPublisher<Data, Swift.Error> {

        dataTaskPublisher(args: .url(url))
            .handleEvents(receiveOutput: { forecast in

                dispatchPrecondition(condition: .notOnQueue(.main))

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

    static let scheme = "https"
    static let host = "api.weather.gov"
}
