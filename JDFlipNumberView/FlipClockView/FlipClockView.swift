//
//
//  Created by Markus Emrich on 20.05.22
//

import Foundation
import SwiftUI

public struct FlipClockView: UIViewRepresentable {
    var imageBundle: JDFlipNumberViewImageBundle?
    var relativeDigitMargin: Double
    var animationsEnabled: Bool
    var showsSeconds: Bool
    var zDistance: Int?

    internal init(imageBundle: JDFlipNumberViewImageBundle? = nil,
                  relativeDigitMargin: Double = 0.1,
                  animationsEnabled: Bool = true,
                  showsSeconds: Bool = true,
                  zDistance: Int? = nil) {
        self.imageBundle = imageBundle
        self.relativeDigitMargin = relativeDigitMargin
        self.animationsEnabled = animationsEnabled
        self.showsSeconds = showsSeconds
        self.zDistance = zDistance
    }

    private func updateStaticState(_ flipView: JDFlipClockView) {
        flipView.relativeDigitMargin = relativeDigitMargin
        flipView.animationsEnabled = animationsEnabled
        flipView.showsSeconds = showsSeconds
        if let z = zDistance {
            flipView.zDistance = z
        }
    }

    public func makeUIView(context: Context) -> JDFlipClockView {
        let flipView = JDFlipClockView(imageBundle: imageBundle)!
        updateStaticState(flipView)
        return flipView
    }

    public func updateUIView(_ uiView: JDFlipClockView, context: Context) {
        updateStaticState(uiView)
    }
}
