extension WeatherGovWebAPI {

    struct WeeklyForecast: Decodable {

        struct Properties: Decodable {

            let periods: [Period]
        }

        let properties: Properties
    }
}
