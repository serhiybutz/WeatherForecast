import SwiftUI

struct AsyncImageView<P: View, I: View>: View {

    @StateObject private var loader: ImageLoader
    private let placeholder: P
    private let image: (UIImage) -> I

    init(
        url: URL?,
        @ViewBuilder placeholder: () -> P,
        @ViewBuilder image: @escaping (UIImage) -> I// = { Image.init(uiImage: $0) }
    ) {

        self.placeholder = placeholder()
        self.image = image
        _loader = StateObject(wrappedValue: ImageLoader(url: url, cache: Environment(\.imageCache).wrappedValue))
    }

    var body: some View {

        content
            .onAppear(perform: loader.load)
    }

    private var content: some View {

        Group {
            if loader.image != nil {
                image(loader.image!)
            } else {
                placeholder
            }
        }
    }
}
