//
//
//  Created by Markus Emrich on 20.05.22
//

import Foundation
import SwiftUI

struct FlipClockView: UIViewRepresentable {
    var imageBundleName: String? = nil
    var relativeDigitMargin: Double = 0.1
    var animationsEnabled = true
    var showsSeconds = true
    var zDistance: Int? = nil

    func updateStaticState(_ flipView: JDFlipClockView) {
        flipView.relativeDigitMargin = relativeDigitMargin
        flipView.animationsEnabled = animationsEnabled
        flipView.showsSeconds = showsSeconds
        if let z = zDistance {
            flipView.zDistance = UInt(z)
        }
    }

    func makeUIView(context: Context) -> JDFlipClockView {
        let flipView = JDFlipClockView(imageBundleName: imageBundleName)!
        updateStaticState(flipView)
        return flipView
    }

    func updateUIView(_ uiView: JDFlipClockView, context: Context) {
        updateStaticState(uiView)
    }
}
