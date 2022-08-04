import Combine
import Foundation
import UIKit

protocol WeatherGovWebRemoteAPI {

    func locationMetadataDataPublisher(point: PointModel) -> AnyPublisher<LocationMetadataModel, Swift.Error>
    func weeklyForecastPublisher(wfo: String, x: Int, y: Int) -> AnyPublisher<WeeklyForecastModel, Swift.Error>
    func iconDownloadPublisher(url: URL) -> AnyPublisher<Data, Swift.Error>
}
