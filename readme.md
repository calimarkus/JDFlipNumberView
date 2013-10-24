JDFlipNumberView 2.0
-----------------------

The FlipNumberView is simulating an analog flip display (like those for the departure time on the airport). It's well abstracted and damn easy to use. Please open a [Github issue], if you think anything is missing or wrong.

![Screenshots](gfx/screenshots.png "Screenshots")

## Installation

**A) Use CocoaPods** (preferred way, see [cocoapods website])

> 1) add `pod 'JDFlipNumberView'` to your Podfile  
> 2) run `pod install` 

**B) Manual way** (not needed, if you use cocoapods):

> 1) Add all files from `JDFlipNumberView/JDFlipNumberView/*` to your 
> project, including the `JDFlipNumberView.bundle`  
> 2) Link with the `QuartzCore.framework`

## Contents

The two main classes are:

- `JDFlipNumberView`  
  The **Standard FlipNumberView**. It shows an integer value as FlipView.
  It has a choosable amount of digits.
- `JDDateCountdownFlipView`  
  __A date countdown.__ Just init with a target date and it will show the remaining days, hours, minutes and seconds until that date.

## Usage

In any case, after installing, you only need to follow some simple steps to get started. Here is a full example usage:

__Example:__ A 4 digit FlipNumberView animating down every second.

    // create a new FlipNumberView, set a value, start an animation
    JDFlipNumberView *flipNumberView = [[JDFlipNumberView alloc] initWithDigitCount:4];
    flipNumberView.value = 1337;
    [flipNumberView animateDownWithTimeInterval: 1.0];
    
    // add to view hierarchy and resize
    [self.view addSubview: flipNumberView];
    flipNumberView.frame = CGRectMake(20,100,300,100);

That's it. This will display a working, flipping, animating countdown view!

## Possible animations

Basic animations:

    - (void)setValue:(NSInteger)newValue animated:(BOOL)animated;
    - (void)animateToNextNumber;
    - (void)animateToPreviousNumber;

Targeted animation over time:

    - (void)animateToValue:(NSInteger)newValue duration:(CGFloat)duration;
    
Timed animation without target value:

    - (void)animateUpWithTimeInterval:(NSTimeInterval)timeInterval;
    - (void)animateDownWithTimeInterval:(NSTimeInterval)timeInterval;

## Customization

*You may use the original `.psd` file from the `gfx` folder to create custom graphics.*

**A) Replace original images**  
Replace the images within the JDFlipNumberView.bundle. But the next pod install will revert your changes.

**B) Use your own bundle**  
Add your own graphics bundle to your project. You need one image per digit. `0.png, 1.png, 2.png, etc.`  

Before using any FlipNumberViews, set your own images like this:

    [JD_IMG_FACTORY generateImagesFromBundleNamed:@"yourBundleName"]

## Twitter

I'm [@jaydee3](http://twitter.com/jaydee3) on Twitter.  
Feel free to [post a tweet](https://twitter.com/intent/tweet?button_hashtag=JDFlipNumberView&text=I%20discovered%20a%20very%20nice%20and%20simple-to-use%20animated%20FlipView%20for%20iOS:%20https://github.com/jaydee3/JDFlipNumberView&via=jaydee3), if you like the FlipNumberView.  

[![TweetButton](gfx/tweetbutton.png "Tweet")](https://twitter.com/intent/tweet?button_hashtag=JDFlipNumberView&text=I%20discovered%20a%20very%20nice%20and%20simple-to-use%20animated%20FlipView%20for%20iOS:%20https://github.com/jaydee3/JDFlipNumberView&via=jaydee3)



[Github issue]: https://github.com/jaydee3/JDFlipNumberView/issues
[cocoapods website]: http://cocoapods.org
[wiki page]: https://github.com/jaydee3/JDFlipNumberView/wiki/Apps-using-JDFlipNumberView