import SwiftUI

struct ContentView: View {

    @State private var currentTemperatureUnit: TemperatureUnit = .fahrenheit

    var body: some View {
        CityListView()
            .ignoresSafeArea()
            .environment(\.currentTemperatureUnit, $currentTemperatureUnit)
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
