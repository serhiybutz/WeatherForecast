import Combine
import UIKit

class ImageLoader: ObservableObject {

    @Published var image: UIImage?

    private(set) var isLoading = false

    private let url: URL?
    private var cache: ImageCache?
    private var cancellable: AnyCancellable?

    private static let imageLoadingQueue = DispatchQueue(label: "image-loading")

    init(url: URL?, cache: ImageCache? = nil) {

        self.url = url
        self.cache = cache
    }

    deinit {

        cancel()
    }

    func load() {

        guard !isLoading else { return }

        guard let url = url else { return }

        if let image = cache?[url] {
            self.image = image
            return
        }

        cancellable = WeatherGovWebAPI.iconDownloadPublisher(url: url)
            .map { UIImage(data: $0) }
            .replaceError(with: nil)
            .handleEvents(receiveSubscription: { [weak self] _ in self?.onStart() },
                          receiveOutput: { [weak self] in self?.cache($0) },
                          receiveCompletion: { [weak self] _ in self?.onFinish() },
                          receiveCancel: { [weak self] in self?.onFinish() })
            .subscribe(on: Self.imageLoadingQueue)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.image = $0 }
    }

    func cancel() {

        cancellable?.cancel()
    }

    private func onStart() {

        isLoading = true
    }

    private func onFinish() {

        isLoading = false
    }

    private func cache(_ image: UIImage?) {

        guard let url = url else { return }

        image.map { cache?[url] = $0 }
    }
}
