import SwiftUI

extension View {

    func topLeftShadow(radius: CGFloat = 16, offset: CGFloat = 6) -> some View {

        self
            .shadow(color: .highlight, radius: radius, x: -offset, y: -offset)
            .shadow(color: .shadow, radius: radius, x: offset, y: offset)
    }

    func rightBottomShadow(radius: CGFloat = 16, offset: CGFloat = 6) -> some View {

        self
            .shadow(color: .shadow, radius: radius, x: -offset, y: -offset)
            .shadow(color: .highlight, radius: radius, x: offset, y: offset)
    }
}
