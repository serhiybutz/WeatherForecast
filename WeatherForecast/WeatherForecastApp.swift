import SwiftUI

@main
struct WeatherForecastApp: App {

    var body: some Scene {

        WindowGroup {
            ContentView()
        }
    }

    init() {

        configNavBarAppearance()

        URLCache.shared.removeAllCachedResponses()
//        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
    }

    func configNavBarAppearance() {

        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = UIColor(Color.element)
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
    }
}
