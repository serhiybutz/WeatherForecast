import SwiftUI

struct TemperatureView: View {

    @Environment(\.currentTemperatureUnit) var currentTemperatureUnit
    let sourceTemperature: Int
    let sourceTemperatureUnit: TemperatureUnit

    var body: some View {

        let temperature = TemperatureRenderer.render(
            sourceTemperature: sourceTemperature,
            sourceScale: sourceTemperatureUnit,
            targetScale: currentTemperatureUnit.wrappedValue
        )

        Text("\(temperature)")
    }
}
