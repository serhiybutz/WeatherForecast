import SwiftUI

@main
struct WeatherForecastApp: App {

    var body: some Scene {

        WindowGroup {
            ContentView()
        }
    }

    init() {

        suppressUnsatisfiableConstrantsWarning()
        removeAllCachedResponses()
        configNavBarAppearance()
    }

    func suppressUnsatisfiableConstrantsWarning() {

        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
    }

    func removeAllCachedResponses() {

        URLCache.shared.removeAllCachedResponses()
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
