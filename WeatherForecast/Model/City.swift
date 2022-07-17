import Foundation

struct City: Codable, Identifiable {

    // MARK: - Properties
    
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double

    enum CodingKeys: String, CodingKey {
        case name
        case latitude
        case longitude
    }
}
