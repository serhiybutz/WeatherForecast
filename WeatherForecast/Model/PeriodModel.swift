import Foundation

struct PeriodModel: Identifiable, Equatable {

    let id = UUID()

    let number: Int
    let name: String
    let startTime: String
    let endTime: String
    let isDatetime: Bool?
    let temperature: Int
    let temperatureUnit: String
    let temperatureTrend: String?
    let windSpeed: String
    let windDirection: String
    let icon: String
    let shortForecast: String
    let detailedForecast: String
}
