import UIKit

enum Constants {
    enum CityList {
        static let itemsMaxWidth: CGFloat = 250
        static let itemsPadding: CGFloat = 20
    }
    enum Forecast {
        enum Shadow {
            static let cornerRadius: CGFloat = 3
            static let cornerOffset: CGFloat = 1
        }
        enum InnerRect {
            static let inset: CGFloat = 3
        }
        enum Cell {
            static let elementPadding: CGFloat = 5
            enum DisclosureGroup {
                static let horizontalPadding: CGFloat = 7
                static let verticalPadding: CGFloat = 20
            }
            enum Image {
                static let width: CGFloat = 100
                static let height: CGFloat = 100
                static let cornerRadius: CGFloat = 5
                enum Shadow {
                    static let opacity: CGFloat = 0.5
                    static let radius: CGFloat = 2
                    enum Offset {
                        static let x: CGFloat = 2
                        static let y: CGFloat = 2
                    }
                }
            }
        }
    }
}
