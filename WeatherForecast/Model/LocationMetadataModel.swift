import Foundation

struct LocationMetadataModel {

    struct Properties: Equatable {

        /// Forecast office ID
        let gridId: String

        /// Forecast grid X coordinate
        let gridX: Int

        /// Forecast grid Y coordinate
        let gridY: Int
    }

    let properties: Properties
}
