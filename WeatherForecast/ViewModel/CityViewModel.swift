import Foundation

struct CityViewModel: Identifiable {
    let id = UUID()

    let name: String
    let latitude: Double
    let longitude: Double
    let image: String

    init(_ city: City) {
        self.name = city.name
        self.latitude = city.latitude
        self.longitude = city.longitude
        self.image = city.image
    }
}
