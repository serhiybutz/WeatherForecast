import Foundation

struct CityViewModel: Identifiable, Equatable {
    
    // MARK: - Properties

    let id = UUID()

    let name: String
    let latitude: Double
    let longitude: Double

    // MARK: - Initialization

    init(_ city: City) {

        self.name = city.name
        self.latitude = city.latitude
        self.longitude = city.longitude
    }
}
