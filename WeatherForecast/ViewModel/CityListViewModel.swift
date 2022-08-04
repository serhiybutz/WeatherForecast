import Foundation

final class CityListViewModel: ObservableObject {
    
    // MARK: - Properties

    @Published var cities: [City]
    let cityCellViewFor: (City) -> CityCellView
    let cityForecastViewFor: (City) -> CityForecastView

    // MARK: - Initialization

    init(cityList: CityList,

         cityCellViewFor: @escaping (City) -> CityCellView,
         cityForecastViewFor: @escaping (City) -> CityForecastView) {

        self.cities = cityList.cities
        self.cityCellViewFor = cityCellViewFor
        self.cityForecastViewFor = cityForecastViewFor
    }
}
