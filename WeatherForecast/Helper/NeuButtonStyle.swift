import SwiftUI

struct NeuButtonStyle: ButtonStyle {

    let radius: CGFloat = 16

    func makeBody(configuration: Self.Configuration) -> some View {
        
        configuration.label
            .background(
                Group {
                    if configuration.isPressed {
                        Rectangle()
                            .fill(Color.element)
                            .cornerRadius(radius)
                            .rightBottomShadow(radius: radius)
                    } else {
                        Rectangle()
                            .fill(Color.element)
                            .cornerRadius(radius)
                            .topLeftShadow(radius: radius)
                    }
                }
            )
            .opacity(configuration.isPressed ? 0.2 : 1)
    }
}
