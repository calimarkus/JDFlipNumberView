JDFlipNumberView
------------------

See [screenshots](#screenshots) below.

The Flip Number View is simulating an analog flip display (like those for the departure time on the airport).

It is using CoreAnimation to get the desired effect. It's well abstracted and should be really easy to use. But it still needs some work, so feel free to contribute!

## Contents

You get three classes for different usecases:

- `JDFlipNumberView`  
  __A single animated digit.__ Range 0-9.
- `JDGroupedFlipNumberView`  
  A grouped and chained choosable number of flipviews for higher numbers.  
  It is using a variable amount of `JDFlipNumberView` instances itself and chains them together.
- `JDDateCountdownFlipView`  
  __A date countdown.__ Just init with a target date and add it as a subview.  
  It is using four `JDGroupedFlipNumberView` instances itself and chains them together.

## How to use

Recommend: Use [cocoapods] to install it.  

(OR add all files from `JDFlipNumberView/JDFlipNumberView/` manually to your project, including the `JDFlipNumberView.bundle`.  
And you also need to link the `QuartzCore.framework`)

In any case, after installing, you only need to follow these three steps, to use it:

> 1. Init the class
> 2. Set an int value (or a date)
> 3. Start the animation

__Example:__ A countdown view from 1000 seconds to 0.

    JDGroupedFlipNumberView *flipNumberView = [[JDGroupedFlipNumberView alloc] initWithFlipNumberViewCount: 4];
    flipNumberView.intValue = 1000;
    [flipNumberView animateDownWithTimeInterval: 1.0];
    
    [self.view addSubview: flipNumberView];
    flipNumberView.frame = CGRectMake(10,100,300,100);

That's it.  
This will display a working, flipping, animating countdown view!

## How to start the animation?

Use any of the following methods:

    // basic animation
    - (void) animateToNextNumber;
    - (void) animateToPreviousNumber;
    
    // timed animation
    - (void) animateUpWithTimeInterval: (NSTimeInterval) timeInterval;
    - (void) animateDownWithTimeInterval: (NSTimeInterval) timeInterval;

## Screenshots

![Overview](https://raw.github.com/jaydee3/JDFlipNumberView/master/Screenshots/menu.png "Overview")

![Single Digit](https://raw.github.com/jaydee3/JDFlipNumberView/master/Screenshots/singledigit.png "Single Digit")

![Date Countdown](https://raw.github.com/jaydee3/JDFlipNumberView/master/Screenshots/datecountdown.png "Date Countdown")


[cocoapods]: https://github.com/CocoaPods/CocoaPods/