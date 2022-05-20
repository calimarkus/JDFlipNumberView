//
//
//  Created by Markus Emrich on 20.05.22
//

import Foundation
import SwiftUI

public enum FlipImageViewAnimationStyle {
    case none
    case upwards(duration: Double = JDFlipImageViewDefaultFlipDuration)
    case downwards(duration: Double = JDFlipImageViewDefaultFlipDuration)
}

public struct FlipImageView: UIViewRepresentable {
    var image: UIImage
    var animationStyle: FlipImageViewAnimationStyle
    var zDistance: Int?

    public init(image: UIImage,
                  animationStyle: FlipImageViewAnimationStyle = .downwards(),
                  zDistance: Int? = nil) {
        self.image = image
        self.animationStyle = animationStyle
        self.zDistance = zDistance
    }

    private func updateStaticState(_ flipView: JDFlipImageView) {
        if let z = zDistance, z != flipView.zDistance {
            flipView.zDistance = UInt(z)
        }
    }

    public func makeUIView(context: Context) -> JDFlipImageView {
        let flipView = JDFlipImageView(image: image)!
        updateStaticState(flipView)
        return flipView
    }

    public func updateUIView(_ uiView: JDFlipImageView, context: Context) {
        let flipView = uiView
        updateStaticState(flipView)

        // animate to new value
        if flipView.image != image {
            switch animationStyle {
                case .none:
                    flipView.image = image
                case let .upwards(duration):
                    flipView.flipDirection = .up
                    flipView.setImageAnimated(image, duration: duration) { _ in }
                case let .downwards(duration):
                    flipView.flipDirection = .down
                    flipView.setImageAnimated(image, duration: duration) { _ in }
            }
        }
    }
}
