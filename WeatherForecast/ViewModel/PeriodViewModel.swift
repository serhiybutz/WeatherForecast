import Foundation

struct PeriodViewModel: Identifiable {

    // MARK: - Properties

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

    // MARK: - Initialization

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

extension PeriodViewModel: Equatable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        guard lhs.name == rhs.name else { return false }
        guard lhs.iconURL == rhs.iconURL else { return false }
        guard lhs.temperature == rhs.temperature else { return false }
        guard lhs.temperatureUnit == rhs.temperatureUnit else { return false }
        guard lhs.temperatureTrend == rhs.temperatureTrend else { return false }
        guard lhs.windSpeed == rhs.windSpeed else { return false }
        guard lhs.shortForecast == rhs.shortForecast else { return false }
        guard lhs.detailedForecast == rhs.detailedForecast else { return false }
        return true
    }
}
