import Foundation

struct PeriodViewModel: Identifiable {

    let id = UUID()

    let name: String
    let iconURL: URL?
    let temperature: Int
    let temperatureUnit: TemperatureUnit
    let temperatureTrend: String?
    let windSpeed: String
    let shortForecast: String
    let detailedForecast: String
}

extension PeriodViewModel {

    init(_ apiPeriod: WeatherGovWebAPI.Period) {
        self.name = apiPeriod.name
        self.iconURL = URL(string: apiPeriod.icon)
        self.temperature = apiPeriod.temperature
        self.temperatureUnit = TemperatureUnit(rawValue: apiPeriod.temperatureUnit) ?? .fahrenheit
        self.temperatureTrend = apiPeriod.temperatureTrend
        self.windSpeed = apiPeriod.windSpeed
        self.shortForecast = apiPeriod.shortForecast
        self.detailedForecast = apiPeriod.detailedForecast
    }
}
