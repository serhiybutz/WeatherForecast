import Combine
import UIKit

final class ImageCache {

    // MARK: - Properties

    private(set) var cache: [String: AnyPublisher<UIImage, Error>] = [:]

    private let downloader: (URL) -> AnyPublisher<UIImage, Error>

    private let lock = NSLock()

    // MARK: - Initialization

    init(downloader: @escaping (URL) -> AnyPublisher<UIImage, Error>) {

        self.downloader = downloader
    }

    func get(at url: URL) -> AnyPublisher<UIImage, Error> {

        lock.lock(); defer { lock.unlock() }

        if let cached = cache[url.absoluteString] {

            return cached

        } else {

            let cached = downloader(url)
                .shareReplay(1)
                .eraseToAnyPublisher()
            cache[url.absoluteString] = cached
            return cached
        }
    }

    func clearCache() {

        lock.lock(); defer { lock.unlock() }

        cache.removeAll()
    }
}
