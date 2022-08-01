import Foundation

struct TemperatureRenderer {

    static let celsiusSymbol = "℃" // °C
    static let fahrenheitSymbol = "℉" // °F

    static func render(sourceTemperature: Int, sourceScale: TemperatureUnit, targetScale:
                       TemperatureUnit) -> String {
        
        switch (sourceScale, targetScale) {
        case (.celsius, .celsius): return "\(sourceTemperature)\(celsiusSymbol)"
        case (.fahrenheit, .fahrenheit): return "\(sourceTemperature)\(fahrenheitSymbol)"
        case (.celsius, .fahrenheit): return "\(Int(round(Double(sourceTemperature) * 9 / 5 + 32)))\(fahrenheitSymbol)"
        case (.fahrenheit, .celsius): return "\(Int(round((Double(sourceTemperature) - 32) * 5 / 9)))\(celsiusSymbol)"
        }
    }
}
