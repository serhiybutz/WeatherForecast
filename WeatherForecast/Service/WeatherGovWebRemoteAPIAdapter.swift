import Combine
import Foundation
import UIKit

struct WeatherGovWebRemoteAPIAdapter: WeatherGovWebRemoteAPI {

    let api: WeatherGovWebAPI

    init(api: WeatherGovWebAPI = WeatherGovWebAPI()) {

        self.api = api
    }

    func locationMetadataDataPublisher(point: PointModel) -> AnyPublisher<LocationMetadataModel, Swift.Error> {

        api.locationMetadataDataPublisher(point: WeatherGovWebAPI.Model.Point(from: point))
            .map(LocationMetadataModel.init(from:))
            .eraseToAnyPublisher()
    }

    func weeklyForecastPublisher(wfo: String, x: Int, y: Int) -> AnyPublisher<WeeklyForecastModel, Swift.Error> {

        api.weeklyForecastPublisher(wfo: wfo, x: x, y: y)
            .map(WeeklyForecastModel.init(from:))
            .eraseToAnyPublisher()
    }

    func iconDownloadPublisher(url: URL) -> AnyPublisher<Data, Swift.Error> {

        api.iconDownloadPublisher(url: url)
    }
}

extension PointModel {

    init(from source: WeatherGovWebAPI.Model.Point) {

        self.lat = source.lat
        self.lon = source.lon
    }
}

extension WeatherGovWebAPI.Model.Point {

    init(from source: PointModel) {

        self.lat = source.lat
        self.lon = source.lon
    }
}

extension LocationMetadataModel {

    init(from source: WeatherGovWebAPI.Model.LocationMetadata) {

        self.properties = .init(from: source.properties)
    }
}

extension LocationMetadataModel.Properties {

    init(from source: WeatherGovWebAPI.Model.LocationMetadata.Properties) {

        self.gridId = source.gridId
        self.gridX = source.gridX
        self.gridY = source.gridY
    }
}

extension WeeklyForecastModel {

    init(from source: WeatherGovWebAPI.Model.WeeklyForecast) {

        self.properties = WeeklyForecastModel.Properties(from: source.properties)
    }
}

extension WeeklyForecastModel.Properties {

    init(from source: WeatherGovWebAPI.Model.WeeklyForecast.Properties) {

        self.periods = source.periods.map(PeriodModel.init(from:))
    }
}

extension PeriodModel {

    init(from source: WeatherGovWebAPI.Model.Period) {

        self.number = source.number
        self.name = source.name
        self.startTime = source.startTime
        self.endTime = source.endTime
        self.isDatetime = source.isDatetime
        self.temperature = source.temperature
        self.temperatureUnit = source.temperatureUnit
        self.temperatureTrend = source.temperatureTrend
        self.windSpeed = source.windSpeed
        self.windDirection = source.windDirection
        self.icon = source.icon
        self.shortForecast = source.shortForecast
        self.detailedForecast = source.detailedForecast
    }
}
