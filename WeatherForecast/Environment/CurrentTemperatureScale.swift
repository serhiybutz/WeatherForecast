import SwiftUI

enum TemperatureUnit: String {
    case celsius = "C"
    case fahrenheit = "F"
    mutating func toggle() {
        self = self == .celsius ? .fahrenheit : .celsius
    }
}

struct CurrentTemperatureUnit: EnvironmentKey {
    static let defaultValue: Binding<TemperatureUnit> = .constant(.fahrenheit)
}

extension EnvironmentValues {    
    var currentTemperatureUnit: Binding<TemperatureUnit> {
        get { self[CurrentTemperatureUnit.self] }
        set { self[CurrentTemperatureUnit.self] = newValue }
    }
}
