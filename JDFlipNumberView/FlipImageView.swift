//
//
//  Created by Markus Emrich on 20.05.22
//

import Foundation
import SwiftUI

enum FlipImageViewAnimationStyle {
    case none
    case upwards(duration: Double = JDFlipImageViewDefaultFlipDuration)
    case downwards(duration: Double = JDFlipImageViewDefaultFlipDuration)
}

struct FlipImageView: UIViewRepresentable {
    var image: UIImage
    var animationStyle: FlipImageViewAnimationStyle = .downwards()
    var zDistance: Int? = nil

    func updateStaticState(_ flipView: JDFlipImageView) {
        if let z = zDistance, z != flipView.zDistance {
            flipView.zDistance = UInt(z)
        }
    }

    func makeUIView(context: Context) -> JDFlipImageView {
        let flipView = JDFlipImageView(image: image)!
        updateStaticState(flipView)
        return flipView
    }

    func updateUIView(_ uiView: JDFlipImageView, context: Context) {
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
