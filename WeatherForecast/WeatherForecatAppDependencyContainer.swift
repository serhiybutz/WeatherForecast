import Foundation

final class WeatherForecatAppDependencyContainer {

    // MARK: - Properties

    // Long-lived dependencies:
    let cityListModel: CityList
    let remoteAPI: WeatherGovWebRemoteAPI
    let weatherGovWebRemoteRepository: WeatherGovWebRemoteRepository

    init() {

        func makeCityListModel() -> CityList {

            CityList.make()
        }

        func makeRemoteAPI() -> WeatherGovWebRemoteAPI {

            return WeatherGovWebRemoteAPIAdapter()
        }

        func makeWeatherGovWebRemoteRepository(_ remoteAPI: WeatherGovWebRemoteAPI) -> WeatherGovWebRemoteRepository {

            return WeatherGovWebRemoteAPIRepository(remoteAPI: remoteAPI)
        }

        self.cityListModel = makeCityListModel()
        self.remoteAPI = makeRemoteAPI()
        self.weatherGovWebRemoteRepository = makeWeatherGovWebRemoteRepository(remoteAPI)
    }

    // MARK: - API

    func makeCityListViewModel() -> CityListViewModel {

        CityListViewModel(
            cityList: cityListModel,
            cityCellViewFor: { [unowned self] in

                CityCellView(viewModel: self.makeCityCellViewModel(for: $0))
            },
            cityForecastViewFor: { [unowned self] in

                CityForecastView(viewModel: self.makeCityForecastViewModel(for: $0))
            }
        )
    }

    func makeCityCellViewModel(for city: City) -> CityViewModel {

        CityViewModel(city)
    }

    func makeCityForecastViewModel(for city: City) -> CityForecastViewModel {

        CityForecastViewModel(
            city: city,
            locationMetadataDataPublisher: {
                self.weatherGovWebRemoteRepository.locationMetadataDataPublisher(point: $0)
            },
            weeklyForecastPublisher: { wfo, x, y in
                self.weatherGovWebRemoteRepository.weeklyForecastPublisher(wfo: wfo, x: x, y: y)
            },
            iconPublisher: {
                self.weatherGovWebRemoteRepository.iconDownloadPublisher(url: $0)
            }
        )
    }
}
