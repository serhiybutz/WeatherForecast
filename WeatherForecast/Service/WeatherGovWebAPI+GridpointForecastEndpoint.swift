import Foundation

/// Method returns a weekly forecast for a gridpoint.
extension WeatherGovWebAPI {

    struct GridpointForecastEndpoint {

        var url: URL? {

            var components = URLComponents()
            components.scheme = "https"
            components.host = WeatherGovWebAPI.host
            components.path = path
            return components.url
        }

        var path: String { "/gridpoints/\(wfo)/\(x),\(y)/forecast" }

        // (Required params)

        /// Forecast office ID
        let wfo: String
        /// Forecast grid X coordinate
        let x: Int
        /// Forecast grid Y coordinate
        let y: Int

        init(wfo: String, x: Int, y: Int) {
            self.wfo = wfo
            self.x = x
            self.y = y
        }
    }
}
