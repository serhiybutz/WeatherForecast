import Foundation

extension WeatherGovWebAPI {

    struct LocationMetadata: Decodable {

        struct Properties: Decodable, Equatable {

            /// Forecast office ID
            let gridId: String // = WFO

            /// Forecast grid X coordinate
            let gridX: Int
            
            /// Forecast grid Y coordinate
            let gridY: Int
        }

        let properties: Properties
    }
}
