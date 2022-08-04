import Foundation

protocol RemoteAPIRequestSpecProvider {

    var httpMethod: String? { get }
    var headerFields: [(field: String, value: String)]? { get }
    var httpBody: Data? { get }
}

extension WeatherGovWebAPI {
    
    struct RemoteAPIRequest<T: RemoteAPIEndpointSpecProvider, U: RemoteAPIRequestSpecProvider> {

        let request: URLRequest

        init?(_ endpointSpecProvider: T, _ requestSpecProvider: U) {

            guard let endpointURL = RemoteAPIEndpoint(endpointSpecProvider)?.url else { return nil }

            var request = URLRequest(url: endpointURL)

            request.httpMethod = requestSpecProvider.httpMethod

            if let fields = requestSpecProvider.headerFields {
                fields.forEach {
                    request.addValue($0.value, forHTTPHeaderField: $0.field)
                }
            }

            if let body = requestSpecProvider.httpBody {
                request.httpBody = body
            }

            self.request = request
        }
    }
}
