import Combine
import UIKit

final class PeriodViewModel: ObservableObject {

    // MARK: - Properties

    let name: String
    let temperature: Int
    let temperatureUnit: TemperatureUnit
    let temperatureTrend: String?
    let windSpeed: String
    let shortForecast: String
    let detailedForecast: String

    let iconLoader: AnyPublisher<UIImage, Error>
    @Published var icon: UIImage?

    // MARK: - Initialization

    init(from source: PeriodModel, iconLoader: AnyPublisher<UIImage, Error>) {

        self.name = source.name
        self.temperature = source.temperature
        self.temperatureUnit = TemperatureUnit(rawValue: source.temperatureUnit) ?? .fahrenheit
        self.temperatureTrend = source.temperatureTrend
        self.windSpeed = source.windSpeed
        self.shortForecast = source.shortForecast
        self.detailedForecast = source.detailedForecast

        self.iconLoader = iconLoader
    }

    // MARK: - API

    func load() {

        iconLoader
            .receive(on: DispatchQueue.main) //Getting error
            .map(Optional.some)
            .replaceError(with: nil)
            .assign(to: &$icon)
    }
}
