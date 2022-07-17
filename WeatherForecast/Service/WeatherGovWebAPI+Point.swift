import Foundation

extension WeatherGovWebAPI {
    
    /// Point location (geographic coordinates) of the object
    struct Point: Decodable {

        /// Latitude
        let lat: Double
        /// Longitude
        let lon: Double
    }
}
