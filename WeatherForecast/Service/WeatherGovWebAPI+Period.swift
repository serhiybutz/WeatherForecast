import Foundation

extension WeatherGovWebAPI {

    struct Period: Decodable {

        let number: Int
        let name: String // E.g.: "Today", "Tonight", "Saturday", "Saturday Night"
        let startTime: String
        let endTime: String
        let isDatetime: Bool?
        let temperature: Int
        let temperatureUnit: String // E.g.: "F"
        let temperatureTrend: String? // E.g.: "rising", null
        let windSpeed: String // E.g.: "3 mph", "5 to 9 mph"
        let windDirection: String // E.g. "N", "E", "SW", "SE"
        let icon: String // E.g.: "https://api.weather.gov/icons/land/night/tsra_hi,20/fog?size=medium"
        let shortForecast: String // E.g.: "Isolated Showers And Thunderstorms then Patchy Fog"
        let detailedForecast: String // E.g.: "Isolated showers and thunderstorms before 11pm, then patchy fog. Partly cloudy, with a low around 70. East wind around 3 mph. Chance of precipitation is 20%."
    }
}
