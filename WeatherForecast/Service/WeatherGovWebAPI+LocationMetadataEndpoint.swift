import Foundation

/// Method returns metadata for a location with coords.
extension WeatherGovWebAPI {

    struct LocationMetadataEndpoint {

        var url: URL? {
            
            var components = URLComponents()
            components.scheme = "https"
            components.host = WeatherGovWebAPI.host
            components.path = path
            return components.url
        }

        var path: String { "/points/\(location.lat),\(location.lon)" }

        // (Required params)

        /// Location (latitude and longitude)
        let location: Point

        init(location: Point) {
            self.location = location
        }
    }
}
