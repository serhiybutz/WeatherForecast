struct TemperatureRenderer {

    static let celsiusSymbol = "℃" // °C
    static let fahrenheitSymbol = "℉" // °F

    static func render(sourceTemperature: Int, sourceScale: TemperatureUnit, targetScale:
                       TemperatureUnit) -> String {
        
        switch (sourceScale, targetScale) {
        case (.celsius, .celsius): return "\(sourceTemperature)\(celsiusSymbol)"
        case (.fahrenheit, .fahrenheit): return "\(sourceTemperature)\(fahrenheitSymbol)"
        case (.celsius, .fahrenheit): return "\(sourceTemperature * 9 / 5 + 32)\(fahrenheitSymbol)"
        case (.fahrenheit, .celsius): return "\((sourceTemperature - 32) * 5 / 9)\(celsiusSymbol)"
        }
    }
}
