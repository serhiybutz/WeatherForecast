import SwiftUI

struct NeuCapsuleButtonStyle: ButtonStyle {
    
    let radius: CGFloat = 16

    func makeBody(configuration: Self.Configuration) -> some View {
        
        configuration.label
            .background(
                Group {
                    if configuration.isPressed {
                        Capsule()
                            .fill(Color.element)
                            .rightBottomShadow(radius: radius)
                    } else {
                        Capsule()
                            .fill(Color.element)
                            .topLeftShadow(radius: radius)
                    }
                }
            )
            .opacity(configuration.isPressed ? 0.2 : 1)
    }
}
