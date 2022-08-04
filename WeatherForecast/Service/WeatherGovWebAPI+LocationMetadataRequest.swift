import Foundation

extension WeatherGovWebAPI {

    struct LocationMetadataRequest {

        struct EndpointSpec: RemoteAPIEndpointSpecProvider {

            /// Location (latitude and longitude)
            let location: Model.Point

            var path: String { "/points/\(location.lat),\(location.lon)" }
            let queryItems: [URLQueryItem]? = nil
        }

        struct RequestSpec: RemoteAPIRequestSpecProvider {

            let httpMethod: String? = "GET"
            let headerFields: [(field: String, value: String)]? = nil
            let httpBody: Data? = nil
        }

        let request: URLRequest

        init?(location: Model.Point) {

            let endpointSpecProvider = EndpointSpec(location: location)

            let requestSpecProvider = RequestSpec()

            guard let request = RemoteAPIRequest(endpointSpecProvider, requestSpecProvider) else { return nil }

            self.request = request.request
        }
    }
}
