//
//
//  Created by Markus Emrich on 19.05.22
//

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
        .padding([.leading, .trailing], 10.0)
        .padding([.top, .bottom], 6.0)
        .foregroundColor(.black)
        .font(.subheadline)
        .overlay(
            RoundedRectangle(cornerRadius: 11).stroke(Color.black, lineWidth: 1.5)
        )
    }
}

struct SectionTitle: View {
    let title:String
    let subtitle:String

    var body: some View {
        VStack {
            Spacer().frame(height: 30.0)
            Text("\(title):")
            Spacer().frame(height: 2.0)
            Text("(\(subtitle))")
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

    let imageNames = ["example01.jpg", "example02.jpg", "example03.jpg"]
    var activeImage: UIImage {
        UIImage(imageLiteralResourceName: imageNames[activeImageIndex % imageNames.count])
    }

    var body: some View {
        ScrollView {
            Group {
                SectionTitle(title: "Simple animation",
                             subtitle: "Tap to change")

                FlipNumberView(value: $val1, digitCount: digitCount, animationStyle: .simple, zDistance: 150)
                    .frame(height: 80)
                    .onTapGesture {
                        val1 = Int(arc4random() % UInt32.max)
                    }

                HStack {
                    SimpleRoundButton(title: "Add Digit") {
                        digitCount += 1
                    }
                    SimpleRoundButton(title: "Remove Digit") {
                        digitCount = max(1, digitCount-1)
                    }
                }
            }

            Group {
                SectionTitle(title: "Continous animation",
                             subtitle: "Tap to change")

                FlipNumberView(value: $val2)
                    .frame(height: 80)
                    .onTapGesture {
                        val2 = Int(arc4random() % 1000000)
                    }
            }

            Group {
                SectionTitle(title: "Alternative assets + interval animation",
                             subtitle: "Tap to start/stop")

                FlipNumberView(value: $val3,
                               imageBundleName: "JDFlipNumberViewModernAssets",
                               animationStyle: isIntervalAnimating ? .interval(interval: 0.75, direction: .up) : .none)
                .frame(height: 80)
                .onTapGesture {
                    isIntervalAnimating.toggle()
                }
            }

            Group {
                SectionTitle(title: "FlipImageView",
                             subtitle: "Tap to change")

                FlipImageView(image: activeImage)
                    .frame(width: 240/activeImage.size.height * activeImage.size.width, height: 240)
                    .onTapGesture {
                        activeImageIndex += 1
                    }
            }

            Spacer().frame(height: 30.0)
        }
    }
}

struct SwiftExample_Previews: PreviewProvider {
    static var previews: some View {
        SwiftExample()
    }
}
