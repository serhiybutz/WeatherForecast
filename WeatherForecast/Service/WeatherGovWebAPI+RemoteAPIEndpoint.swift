import Foundation

protocol RemoteAPIEndpointSpecProvider {

    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
}

extension WeatherGovWebAPI {

    struct RemoteAPIEndpoint<T: RemoteAPIEndpointSpecProvider> {

        let url: URL

        init?(_ specProvider: T) {

            var components = URLComponents()
            components.scheme = WeatherGovWebAPI.scheme
            components.host = WeatherGovWebAPI.host
            components.path = specProvider.path
            components.queryItems = (specProvider.queryItems ?? []).isEmpty
            ? nil
            : specProvider.queryItems

            guard let url = components.url else { return nil }

            self.url = url
        }
    }
}
