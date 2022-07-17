import Foundation

struct City: Codable, Identifiable {
    
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    let image: String

    enum CodingKeys: String, CodingKey {
        case name
        case latitude
        case longitude
        case image
    }
}
