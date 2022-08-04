import Combine
import Foundation
import UIKit

// TODO: Implement disk caching

final class WeatherGovWebRemoteAPIRepository: WeatherGovWebRemoteRepository {

    enum ImageLoaderError: Error {

        case corruptedData
    }

    // MARK: - Properties

    let remoteAPI: WeatherGovWebRemoteAPI

    let imageCache: ImageCache

    // MARK: - Methods

    init(remoteAPI: WeatherGovWebRemoteAPI) {

        self.remoteAPI = remoteAPI

        self.imageCache = ImageCache() { url in

            remoteAPI
                .iconDownloadPublisher(url: url)
                .tryMap { data in
                    guard let image = UIImage(data: data)
                    else {
                        throw RepositoryError.weatherGovWebRepoError(ImageLoaderError.corruptedData)
                    }
                    return image
                }
                .eraseToAnyPublisher()
        }
    }

    func locationMetadataDataPublisher(point: PointModel) -> AnyPublisher<LocationMetadataModel, Swift.Error> {

        remoteAPI.locationMetadataDataPublisher(point: point)
            .mapError { RepositoryError.weatherGovWebRepoError($0) }
            .eraseToAnyPublisher()
    }

    func weeklyForecastPublisher(wfo: String, x: Int, y: Int) -> AnyPublisher<WeeklyForecastModel, Swift.Error> {

        remoteAPI.weeklyForecastPublisher(wfo: wfo, x: x, y: y)
            .mapError { RepositoryError.weatherGovWebRepoError($0) }
            .eraseToAnyPublisher()
    }

    func iconDownloadPublisher(url: URL) -> AnyPublisher<UIImage, Error> {

        imageCache.get(at: url)
    }
}
