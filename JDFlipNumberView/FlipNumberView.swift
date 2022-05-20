//
//
//  Created by Markus Emrich on 19.05.22
//

import Foundation
import SwiftUI

public enum FlipNumberViewIntervalAnimationDirection {
    case up
    case down
}

public enum FlipNumberViewAnimationStyle {
    case none
    case simple
    case continuous(duration: Double)
    case interval(interval: Double, direction: FlipNumberViewIntervalAnimationDirection)
}

public struct FlipNumberView: UIViewRepresentable {
    @Binding var value: Int
    var digitCount: Int?
    var imageBundleName: String?
    var animationStyle: FlipNumberViewAnimationStyle

    var zDistance: Int?
    var relativeDigitMargin: Double?
    var absoluteDigitMargin: Double?

    public init(value: Binding<Int>,
                digitCount: Int? = nil,
                imageBundleName: String? = nil,
                animationStyle: FlipNumberViewAnimationStyle = .continuous(duration: 2.5),
                zDistance: Int? = nil,
                relativeDigitMargin: Double? = nil,
                absoluteDigitMargin: Double? = nil)
    {
        self._value = value
        self.digitCount = digitCount
        self.imageBundleName = imageBundleName
        self.animationStyle = animationStyle
        self.zDistance = zDistance
        self.relativeDigitMargin = relativeDigitMargin
        self.absoluteDigitMargin = absoluteDigitMargin
    }

    private var resolvedDigitCount: UInt {
        if let count = digitCount {
            return UInt(count)
        } else {
            return UInt(String(value).count)
        }
    }

    private func updateStaticState(_ flipView: JDFlipNumberView) {
        if let countVal = digitCount, countVal != flipView.digitCount {
            flipView.digitCount = UInt(countVal)
        }
        if let z = zDistance, z != flipView.zDistance {
            flipView.zDistance = UInt(z)
        }
        if let relVal = relativeDigitMargin, relVal != flipView.relativeDigitMargin {
            flipView.relativeDigitMargin = relVal
        }
        if let absVal = absoluteDigitMargin, absVal != flipView.absoluteDigitMargin {
            flipView.absoluteDigitMargin = absVal
        }

        if case let .interval(interval, direction) = animationStyle {
            flipView.stopAnimation()
            switch direction {
                case .up:
                    flipView.animateUp(withTimeInterval: interval)
                case .down:
                    flipView.animateDown(withTimeInterval: interval)
            }
        }
    }

    public func makeUIView(context: Context) -> JDFlipNumberView {
        let flipView = JDFlipNumberView(digitCount: resolvedDigitCount, imageBundleName: imageBundleName)!
        flipView.value = value
        flipView.digitCount = resolvedDigitCount
        flipView.delegate = context.coordinator
        updateStaticState(flipView)
        return flipView
    }

    public func updateUIView(_ uiView: JDFlipNumberView, context: Context) {
        let flipView = uiView

        updateStaticState(flipView)

        // animate to new value
        if flipView.value != value {
            flipView.stopAnimation()

            switch animationStyle {
                case .none:
                    flipView.setValue(value, animated: false)
                case .simple:
                    flipView.setValue(value, animated: true)
                case let .continuous(duration):
                    flipView.animate(toValue: value, duration: duration)
                case .interval:
                    break
            }
        }
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public class Coordinator: NSObject, JDFlipNumberViewDelegate {
        var flipView: FlipNumberView

        init(_ flipView: FlipNumberView) {
            self.flipView = flipView
        }

        public func flipNumberView(_ flipNumberView: JDFlipNumberView!, didChangeValueAnimated animated: Bool) {
            if case .interval = flipView.animationStyle {
                self.flipView.value = flipNumberView.value
            }
        }
    }
}
