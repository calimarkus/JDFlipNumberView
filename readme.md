JDFlipNumberView & JDFlipImageView
----------------------------------

| Target Value Animation | Animated Time Display |
| ------------- | ------------- |
| <img height="120" src="https://user-images.githubusercontent.com/807039/169300618-861a4d81-26cc-46c2-882b-1e4b6f0ffc4a.gif"> | <img height="100" src="https://user-images.githubusercontent.com/807039/169300625-9421b845-14c7-42c0-a00a-f4b8d97cce03.gif"> |

The `FlipNumberView` is simulating an analog flip display (e.g. like those at the airport / train station). It's well abstracted and easy to use. The `FlipImageView` let's you run a similar animation on any view, e.g. images. See the example project for working examples (You can run `pod try JDFlipNumberView` to open the example project quickly.). Please open a [Github issue], if you think anything is missing or wrong.

<img width="1000" alt="screenshot" src="https://user-images.githubusercontent.com/807039/169299475-7dd36912-7eeb-4f30-a7c7-459b11e7099e.png">

## Installation using CocoaPods

- `pod 'JDFlipNumberView'` all flip views, SwiftUI views & default imageset

To further limit what you depend on, use the following subpods. They don't include the default image bundle, thus they are much more lightweight. See [Customization](#customization) below for infos, on how to use your own images.

- `pod 'JDFlipNumberView/NoImageBundle'`, everything except the default image bundle
- `pod 'JDFlipNumberView/NoImageBundle-NoSwiftUI'`, everything except the default image bundle & the SwiftUI views

Even more targeted:

- `pod 'JDFlipNumberView/Core'`, only the `JDFlipNumberView`
- `pod 'JDFlipNumberView/FlipImageView'`, only the `JDFlipImageView`
- `pod 'JDFlipNumberView/FlipClockView'`, `/Core` + `JDFlipClockView`
- `pod 'JDFlipNumberView/DateCountdownFlipView'`, `/Core` + `JDDateCountdownFlipView`
- `pod 'JDFlipNumberView/DefaultImageBundle'`, the default image bundle, as it's not included automatically in the other subpods

(For infos on cocoapods, have a look the [cocoapods website])

## Manual Installation

1. Add all files from `JDFlipNumberView/JDFlipNumberView/*.{h,m}` to your project
2. Add the `JDFlipNumberView.bundle`, if you want to use the default images
3. Link against the `QuartzCore.framework`

## Contents

The main classes are

- `JDFlipNumberView` (SwiftUI: `FlipNumberView`)
  - The **Standard FlipNumberView**. It shows an integer value as FlipView.
  It has a choosable amount of digits. Can be animated in any way described in this document.

- `JDFlipImageView` (SwiftUI: `FlipImageView`)
  - An **Image View** with flip animations. Use it like a regular UIImageView, but set new images animated via `setImageAnimated:duration:completion:`
  
- `JDDateCountdownFlipView` (SwiftUI: `DateCountdownFlipView`)
  - __A date countdown.__ Create it with a target date and it will display an animated flipping countdown showing the remaining days, hours, minutes and seconds until that date.
  
- `JDFlipClockView` (SwiftUI: `FlipClockView`)
  - __A digital clock.__ Displays the current hour and minutes as animated flip views. Seconds can also be enabled. Always shows the current time.
  
- `UIView+JDFlipImageView`  
  - A **UIView category** that makes it possible to transition between any two views using a flip animation.

## Usage Example

After installing you only need to follow some simple steps to get started. Here is a working example: A 4-digit `FlipNumberView` animating down once every second.

Objective-C + UIKit:

```objc
// create a new FlipNumberView, set a value, start an animation
JDFlipNumberView *flipNumberView = [[JDFlipNumberView alloc] initWithDigitCount:4];
flipNumberView.value = 1337;
[flipNumberView animateDownWithTimeInterval: 1.0];

// add to view hierarchy and resize
[self.view addSubview: flipNumberView];
flipNumberView.frame = CGRectMake(20,100,300,100);
```

In SwiftUI it's even simpler:

```swift
struct SwiftExample: View {
    @State var value = 1337

    var body: some View {
        FlipNumberView(value: $value, animationStyle: .interval(interval: 1.0, direction: .down))
          .frame(height: 80)
    }
}
```

That's it. This will display a working, flipping, animating countdown view!  
See the example project for other examples.

## Available animations

- Simple (a single flip):

```objc
- (void)setValue:(NSInteger)newValue animated:(BOOL)animated;
- (void)animateToNextNumber;
- (void)animateToPreviousNumber;
```

- Continuous (Flipping through all numbers, until target is reached):

```objc
- (void)animateToValue:(NSInteger)newValue duration:(CGFloat)duration;
```
    
- Interval (A timed animation without a target value, flipping once per `timeInterval`):

```objc
- (void)animateUpWithTimeInterval:(NSTimeInterval)timeInterval;
- (void)animateDownWithTimeInterval:(NSTimeInterval)timeInterval;
```

In SwiftUI, see these:

```swift
public enum FlipNumberViewAnimationStyle {
    case none
    case simple
    case continuous(duration: Double)
    case interval(interval: Double, direction: FlipNumberViewIntervalAnimationDirection)
}
```

## Customization

**A) Replace original images**  
Replace the images within the `JDFlipNumberView.bundle`. (In the Finder just `Rightclick > Show Contents` to see the images.)

> When using Pods, make sure to use `pod 'JDFlipNumberView/Core'`, so the default bundle won't be copied. Just create a bundle named `JDFlipNumberView.bundle` in your project yourself.

**B) Use multiple bundles**  
Add another graphics bundle to your project. A bundle is nothing else, than a regular folder, but named with `.bundle` as extension. You need one image per digit. `0.png, 1.png, 2.png, etc.` See the next section on how to use multiple bundles.

#### Implementing a custom bundle

To use your own bundles, use the `imageBundle:` initializers:

```objc
[[JDFlipNumberView alloc] initWithDigitCount:<#count#> 
                                 imageBundle:[JDFlipNumberViewImageBundle imageBundleNamed:@"<#imageBundleName#>"]];
[[JDDateCountdownFlipView alloc] initWithDayDigitCount:<#count#> 
                                           imageBundle:[JDFlipNumberViewImageBundle imageBundleNamed:@"<#imageBundleName#>"]];
```

SwiftUI:

```swift
FlipNumberView(value: <#valueBinding#>, imageBundle: JDFlipNumberViewImageBundle(named: "<#imageBundleName#>"))
```

*Feel free to use the original `.psd` file from the `gfx` folder to create custom numbers.*

![digits](https://user-images.githubusercontent.com/807039/169639417-696466bd-28b7-4ed6-a406-863ac9f49a0b.png)

## Twitter

I'm [@calimarkus](http://twitter.com/calimarkus) on Twitter. Maybe [tweet](https://twitter.com/intent/tweet?button_hashtag=JDFlipNumberView&text=I%20discovered%20a%20very%20nice%20and%20simple-to-use%20animated%20FlipView%20for%20iOS:%20https://github.com/calimarkus/JDFlipNumberView&via=calimarkus), if you like `JDFlipNumberView`!

[![TweetButton](gfx/tweetbutton.png "Tweet")](https://twitter.com/intent/tweet?button_hashtag=JDFlipNumberView&text=I%20discovered%20a%20very%20nice%20and%20simple-to-use%20animated%20FlipView%20for%20iOS:%20https://github.com/calimarkus/JDFlipNumberView&via=calimarkus)


[Github issue]: https://github.com/calimarkus/JDFlipNumberView/issues
[cocoapods website]: http://cocoapods.org
