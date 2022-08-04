import Foundation

extension WeatherGovWebAPI {

    struct GridpointForecastRequest {

        struct EndpointSpec: RemoteAPIEndpointSpecProvider {

            /// Forecast office ID
            let wfo: String

            /// Forecast grid X coordinate
            let x: Int

            /// Forecast grid Y coordinate
            let y: Int

            var path: String { "/gridpoints/\(wfo)/\(x),\(y)/forecast" }
            let queryItems: [URLQueryItem]? = nil
        }

        struct RequestSpec: RemoteAPIRequestSpecProvider {

            let httpMethod: String? = "GET"
            let headerFields: [(field: String, value: String)]? = nil
            let httpBody: Data? = nil
        }

        let request: URLRequest

        init?(wfo: String, x: Int, y: Int) {

            let endpointSpecProvider = EndpointSpec(wfo: wfo, x: x, y: y)

            let requestSpecProvider = RequestSpec()

            guard let request = RemoteAPIRequest(endpointSpecProvider, requestSpecProvider) else { return nil }

            self.request = request.request
        }
    }
}
