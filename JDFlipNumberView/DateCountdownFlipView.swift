//
//
//  Created by Markus Emrich on 20.05.22
//

import Foundation
import SwiftUI

struct DateCountdownFlipView: UIViewRepresentable {
    var dayDigitCount = 3
    var imageBundleName: String? = nil

    var targetDate: Date
    var animationsEnabled = true
    var zDistance: Int? = nil

    func updateStaticState(_ flipView: JDDateCountdownFlipView) {
        flipView.targetDate = targetDate
        if animationsEnabled != flipView.animationsEnabled {
            flipView.animationsEnabled = animationsEnabled
        }
        if let z = zDistance {
            flipView.zDistance = UInt(z)
        }
    }

    func makeUIView(context: Context) -> JDDateCountdownFlipView {
        let flipView = JDDateCountdownFlipView(dayDigitCount: dayDigitCount, imageBundleName: imageBundleName)!
        flipView.animationsEnabled = animationsEnabled
        updateStaticState(flipView)
        return flipView
    }

    func updateUIView(_ uiView: JDDateCountdownFlipView, context: Context) {
        updateStaticState(uiView)
    }
}
