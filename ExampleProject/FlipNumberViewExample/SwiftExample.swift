//
//
//  Created by Markus Emrich on 19.05.22
//

import Foundation
import SwiftUI

class SwiftExampleViewFactory: NSObject {
  @objc static func swiftExampleViewController() -> UIViewController {
    return UIHostingController(rootView: SwiftExample())
  }
}

struct SimpleRoundButton: View {
    let title:String
    let action: () -> Void

    var body: some View {
        Button(title) {
            action()
        }
        .buttonStyle(BorderlessButtonStyle())
        .padding([.leading, .trailing], 10.0)
        .padding([.top, .bottom], 6.0)
        .foregroundColor(.black)
        .font(.subheadline)
        .overlay(
            RoundedRectangle(cornerRadius: 11).stroke(Color.black.opacity(0.33), lineWidth: 1.0)
        )
    }
}

struct Subtitle: View {
    let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        VStack {
            Text(text)
                .font(.footnote)
                .foregroundColor(.secondary)
        }
    }
}

struct SwiftExample: View {
    @State var val1 = 33333
    @State var val2 = 843210
    @State var val3 = 640

    @State var digitCount = 6
    @State var isIntervalAnimating = true
    @State var activeImageIndex = 0

    @State var isClockAnimating = true
    @State var isCountdownAnimating = true

    let imageNames = ["example01.jpg", "example02.jpg", "example03.jpg"]
    var activeImage: UIImage {
        UIImage(imageLiteralResourceName: imageNames[activeImageIndex % imageNames.count])
    }

    var nyeDate: Date {
        let allUnits: Set<Calendar.Component> = [Calendar.Component.calendar, Calendar.Component.timeZone, Calendar.Component.year]
        var comps = NSCalendar.current.dateComponents(allUnits, from: Date())
        comps.day = 31
        comps.month = 12
        comps.hour = 23
        comps.second = 59
        return comps.date!
    }

    var body: some View {
        List {
            Section("Simple animation") {
                Subtitle("Tap to change value.")

                FlipNumberView(value: $val1, digitCount: digitCount, animationStyle: .simple, zDistance: 150)
                    .frame(height: 80)
                    .onTapGesture {
                        val1 = Int(arc4random() % UInt32.max)
                    }

                HStack {
                    Spacer()
                    SimpleRoundButton(title: "Add Digit") {
                        digitCount += 1
                    }
                    SimpleRoundButton(title: "Remove Digit") {
                        digitCount = max(1, digitCount-1)
                    }
                    Spacer()
                }
                .listRowSeparator(.hidden)
            }

            Section("Continous animation") {
                Subtitle("Tap to change value.")

                FlipNumberView(value: $val2)
                    .frame(height: 80)
                    .onTapGesture {
                        val2 = Int(arc4random() % 1000000)
                    }
            }

            Section("Alternative assets + interval animation") {
                Subtitle("Tap to start/stop animation.")

                FlipNumberView(value: $val3,
                               imageBundle: JDFlipNumberViewImageBundle(named: "JDFlipNumberViewModernAssets"),
                               animationStyle: isIntervalAnimating ? .interval(interval: 0.75, direction: .up) : .none)
                .frame(height: 80)
                .onTapGesture {
                    isIntervalAnimating.toggle()
                }
            }

            Section("FlipImageView") {
                Subtitle("Tap to change.")

                FlipImageView(image: activeImage)
                    .frame(width: 240/activeImage.size.height * activeImage.size.width, height: 240)
                    .onTapGesture {
                        activeImageIndex += 1
                    }
            }

            Section("Clock / Current Time") {
                Subtitle("Tap to toggle animation (\(isClockAnimating ? "on" : "off").")

                FlipClockView(animationsEnabled: isClockAnimating)
                    .frame(height: 70)
                    .onTapGesture {
                        isClockAnimating.toggle()
                    }
            }

            Section("Countdown to NYE") {
                Subtitle("days/h/min/sec, tap to toggle animation (\(isCountdownAnimating ? "on" : "off")")

                DateCountdownFlipView(targetDate: nyeDate, animationsEnabled: isCountdownAnimating)
                    .frame(height: 70)
                    .onTapGesture {
                        isCountdownAnimating.toggle()
                    }
            }
        }
    }
}

struct SwiftExample_Previews: PreviewProvider {
    static var previews: some View {
        SwiftExample()
    }
}
