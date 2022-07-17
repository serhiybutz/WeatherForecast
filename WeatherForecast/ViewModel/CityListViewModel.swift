import Foundation

class CityListViewModel: ObservableObject {
    // MARK: - Properies

    @Published var cities: [CityViewModel]

    // MARK: - Initialization

    init(_ list: CityList) {
        self.cities = list.cities.map {
            CityViewModel($0)
        }
    }
}
