import SwiftUI

struct ContentView: View {

    @State private var currentTemperatureUnit: TemperatureUnit = .fahrenheit

    // Leverage State's reference-based storage under the hood to achieve a long-lived dependency:
    @State var injectionContainer = WeatherForecatAppDependencyContainer()

    var body: some View {
        
        CityListView(viewModel: injectionContainer.makeCityListViewModel())
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
