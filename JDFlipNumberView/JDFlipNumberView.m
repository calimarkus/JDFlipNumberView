//
//  JDFlipNumberView.m
//
//  Created by Markus Emrich on 27.02.11.
//  Copyright 2011 Markus Emrich. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "JDFlipNumberDigitView.h"

#import "JDFlipNumberView.h"


static CGFloat JDFlipAnimationMinimumTimeInterval = 0.01; // = 100 fps
static CGFloat JDFlipViewRelativeMargin = 0.05; // use 5% of width as margin


typedef NS_OPTIONS(NSUInteger, JDFlipAnimationDirection) {
	JDFlipAnimationDirectionUp,
	JDFlipAnimationDirectionDown
};

@interface JDFlipNumberView ()
@property (nonatomic, copy) NSString *imageBundleName;
@property (nonatomic, strong) NSArray *digitViews;
@property (nonatomic, assign) JDFlipAnimationType animationType;

@property (nonatomic, strong) NSTimer *animationTimer;
@property (nonatomic, assign) NSTimeInterval neededInterval;
@property (nonatomic, assign) NSTimeInterval intervalRest;
@property (nonatomic, assign) BOOL delegateEnabled;
@property (nonatomic, assign) BOOL targetMode;
@property (nonatomic, assign) NSInteger targetValue;
@property (nonatomic, copy) JDFlipAnimationCompletionBlock completionBlock;

- (void)setValue:(NSInteger)newValue animatedInCurrentDirection:(BOOL)animated;
- (void)animateInDirection:(JDFlipAnimationDirection)direction
              timeInterval:(NSTimeInterval)timeInterval;
@end

@implementation JDFlipNumberView

- (id)initWithFrame:(CGRect)frame;
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInitForDigitCount:1];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInitForDigitCount:3];
    }
    return self;
}

- (id)initWithDigitCount:(NSUInteger)digitCount;
{
    return [self initWithDigitCount:digitCount imageBundleName:nil];
}

- (id)initWithDigitCount:(NSUInteger)digitCount
         imageBundleName:(NSString*)imageBundleName;
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _imageBundleName = imageBundleName;
        [self commonInitForDigitCount:digitCount];
    }
    return self;
}

- (void)commonInitForDigitCount:(NSUInteger)digitCount;
{
    self.backgroundColor = [UIColor clearColor];
    self.autoresizesSubviews = NO;
    
    // setup properties
    self.digitCount = digitCount;
    self.animationType = JDFlipAnimationTypeTopDown;
    self.reverseFlippingDisabled = YES;
    self.targetMode = NO;
    self.delegateEnabled = YES;
    
    // update frame
    CGSize digitSize = [self.digitViews.lastObject bounds].size;
    super.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                             digitCount*digitSize.width, digitSize.height);
}

#pragma mark -
#pragma mark external access

- (NSInteger)value;
{
	NSMutableString* stringValue = [NSMutableString stringWithCapacity:self.digitViews.count];
	for (JDFlipNumberDigitView* view in self.digitViews) {
		[stringValue appendFormat: @"%lu", (unsigned long)view.value];
	}
	
	return [stringValue intValue];
}

- (void)setValue:(NSInteger)value;
{
    [self setValue:value animated:NO];
}

- (void)setValue:(NSInteger)newValue animated:(BOOL)animated;
{
    [self stopAnimation];
    
    // reset animation Duration
    self.animationDuration = 1.0;
    
    // automatically detect animation type
    self.animationType = JDFlipAnimationTypeTopDown;
    if (newValue < self.value) {
        self.animationType = JDFlipAnimationTypeBottomUp;
    }
    
    // animate to new value
    [self setValue:newValue animatedInCurrentDirection:animated];
}

- (void)setValue:(NSInteger)newValue animatedInCurrentDirection:(BOOL)animated;
{
    // stay in max bounds
    newValue = [self validValueFromValue:newValue];
    
    // inform delegate
	if (animated && self.delegateEnabled && !self.targetMode && [self.delegate respondsToSelector: @selector(flipNumberView:willChangeToValue:)]) {
		[self.delegate flipNumberView:self willChangeToValue:newValue];
	}
    
    // convert to string
	NSString* stringValue = [NSString stringWithFormat: @"%50ld", (long)newValue];
	
    // udpate all flipviews, that have changed
    __block NSUInteger completedDigits = 0;
	for (int i=0; i<stringValue.length && i<self.digitViews.count; i++) {
		JDFlipNumberDigitView* view = (JDFlipNumberDigitView*)self.digitViews[self.digitViews.count-(1+i)];
		NSInteger newValue = [[stringValue substringWithRange:NSMakeRange(stringValue.length-(1+i), 1)] intValue];
        if (newValue != view.value) {
            if(animated) {
                JDFlipAnimationType type = self.animationType;
                if (type == JDFlipAnimationTypeBottomUp && self.reverseFlippingDisabled) {
                    type = JDFlipAnimationTypeTopDown;
                }
                [view setValue:newValue withAnimationType:type completion:^(BOOL completed){
                    completedDigits++;
                    if (completedDigits == self.digitViews.count) {
                        // inform delegate, when all digits finished animation
                        if (animated && !self.targetMode && [self.delegate respondsToSelector: @selector(flipNumberView:didChangeValueAnimated:)]) {
                            [self.delegate flipNumberView:self didChangeValueAnimated:NO];
                        }
                    }
                }];
            } else {
                view.value = newValue;
            }
        } else {
            // also count not animated view
            completedDigits++;
        }
	}
    
    // inform delegate
    if (!animated && [self.delegate respondsToSelector: @selector(flipNumberView:didChangeValueAnimated:)]) {
        [self.delegate flipNumberView:self didChangeValueAnimated:NO];
    }
}

- (NSUInteger)validValueFromValue:(NSInteger)value;
{
    if (value < 0) {
        value += floor(ABS(value)/self.maximumValue)*self.maximumValue;
        value += (self.maximumValue+1);
    }
	return value%(self.maximumValue+1);
}

- (NSUInteger)zDistance;
{
    return [self.digitViews[0] zDistance];
}

- (void)setZDistance:(NSUInteger)zDistance;
{
	for (JDFlipNumberDigitView* view in self.digitViews) {
		[view setZDistance: zDistance];
	}
}

- (void)setMaximumValue:(NSUInteger)maximumValue;
{
    NSInteger absoluteMaximum = pow(10, self.digitViews.count)-1;
    _maximumValue = MIN(maximumValue,absoluteMaximum);
    if(self.value > maximumValue) {
        self.value = maximumValue;
    }
}

- (CGFloat)animationDuration;
{
    JDFlipNumberDigitView *digit = self.digitViews[0];
    return digit.animationDuration;
}

- (void)setAnimationDuration:(CGFloat)animationDuration;
{
    for (NSInteger i=self.digitViews.count-1; i>=0; i--) {
        JDFlipNumberDigitView *digit = self.digitViews[i];
        digit.animationDuration = animationDuration;
        animationDuration *= 10;
    }
}

- (void)setDigitCount:(NSUInteger)digitCount;
{
    digitCount = MAX(1,digitCount);
    if (digitCount == _digitCount) return;
    _digitCount = digitCount;
    
    // remember value
    NSInteger currentValue = self.value;
    
    // remove current digit views
    for (JDFlipNumberDigitView *digit in self.digitViews) {
        [digit removeFromSuperview];
    }
    
    // init & add new digit views
    JDFlipNumberDigitView* view = nil;
    NSMutableArray* digitViews = [[NSMutableArray alloc] initWithCapacity:digitCount];
    for (int i = 0; i < digitCount; i++) {
        view = [[JDFlipNumberDigitView alloc] initWithImageBundle:self.imageBundleName];
        [self addSubview:view];
        [digitViews addObject:view];
    }
    self.digitViews = [digitViews copy];
    
    // update max value
    self.maximumValue = pow(10, digitCount)-1;
    
    // set value again
    [self setValue:currentValue];
    
    // relayout
    [self setNeedsLayout];
}

- (void)setImageBundleName:(NSString*)imageBundleName;
{
    _imageBundleName = imageBundleName;
    
    // update digits
    for (JDFlipNumberDigitView *digit in self.digitViews) {
        [digit setImageBundleName:imageBundleName];
    }
}

#pragma mark -
#pragma mark animation

- (void)animateToNextNumber;
{
	[self stopAnimation];
    self.animationType = JDFlipAnimationTypeTopDown;
	[self setValue:self.value+1 animatedInCurrentDirection:YES];
}

- (void)animateToPreviousNumber;
{
	[self stopAnimation];
    self.animationType = JDFlipAnimationTypeBottomUp;
    [self setValue:self.value-1 animatedInCurrentDirection:YES];
}

#pragma mark -
#pragma mark timed animation

- (void)animateUpWithTimeInterval:(NSTimeInterval)timeInterval;
{
    [self stopAnimation];
    [self animateInDirection:JDFlipAnimationDirectionUp timeInterval:timeInterval];
}

- (void)animateDownWithTimeInterval:(NSTimeInterval)timeInterval;
{
    [self stopAnimation];
    [self animateInDirection:JDFlipAnimationDirectionDown timeInterval:timeInterval];
}

- (void)animateInDirection:(JDFlipAnimationDirection)direction
              timeInterval:(NSTimeInterval)timeInterval;
{
    // set animation type
    self.animationType = JDFlipAnimationTypeTopDown;
    if (direction == JDFlipAnimationDirectionDown) {
        self.animationType = JDFlipAnimationTypeBottomUp;
    }
    
    // setup timer
    self.neededInterval = timeInterval;
    self.animationDuration = timeInterval;
    CGFloat actualInterval = MAX(JDFlipAnimationMinimumTimeInterval, timeInterval);
    
    self.animationTimer = [NSTimer timerWithTimeInterval:actualInterval
                                                  target:self
                                                selector:@selector(handleTimer:)
                                                userInfo:nil
                                                 repeats:YES];
    [self.animationTimer fire]; // fire instantly for first change
    [[NSRunLoop currentRunLoop] addTimer:self.animationTimer forMode:NSRunLoopCommonModes];
}

- (void)handleTimer:(NSTimer*)timer
{
    // if timer is too slow, add more than 1 per timer call
    NSInteger step = 1;
    if (timer.timeInterval > self.neededInterval) {
        CGFloat ratio = timer.timeInterval/self.neededInterval;
        step = floor(ratio);
        self.intervalRest += ratio-step;
        if (self.intervalRest > 1) {
            step += floor(self.intervalRest);
            self.intervalRest -= floor(self.intervalRest);
        }
    }
    
    // calc new value
    NSInteger newValue = self.value+step;
    if (self.animationType == JDFlipAnimationTypeBottomUp) {
        newValue = self.value-step;
    }
    
    // check target mode finish conditions
    if (self.targetMode) {
        if (newValue == self.targetValue ||
            (self.animationType == JDFlipAnimationTypeTopDown && newValue > self.targetValue) ||
            (self.animationType == JDFlipAnimationTypeBottomUp && newValue < self.targetValue)) {
            [self setValue:self.targetValue animatedInCurrentDirection:YES];
            JDFlipAnimationCompletionBlock completion = self.completionBlock;
            self.completionBlock = nil;
            [self stopAnimation];
            if (completion) {
                completion(YES);
            }
            return;
        }
    }
    
    // get valid value
    newValue = [self validValueFromValue:newValue];
    
    // animate new value
    [self setValue:newValue animatedInCurrentDirection:YES];
}

#pragma mark -
#pragma mark targeted animation

- (void)animateToValue:(NSInteger)newValue duration:(CGFloat)duration;
{
    [self animateToValue:newValue duration:duration completion:nil];
}

- (void)animateToValue:(NSInteger)newValue duration:(CGFloat)duration completion:(JDFlipAnimationCompletionBlock)completion;
{
    [self stopAnimation];
    
    if (completion) {
        self.completionBlock = completion;
    }
    
	// save target value in valid range
	NSString* strvalue = [NSString stringWithFormat: @"%50ld", (long)newValue];
	strvalue = [strvalue substringWithRange:NSMakeRange(strvalue.length-self.digitViews.count, self.digitViews.count)];
	self.targetValue = [self validValueFromValue:[strvalue intValue]];

    if (self.targetValue == self.value) {
        return;
    }
    
    // inform delegate
	if ([self.delegate respondsToSelector: @selector(flipNumberView:willChangeToValue:)]) {
		[self.delegate flipNumberView:self willChangeToValue:self.targetValue];
	}
    
	// determine direction
	JDFlipAnimationDirection direction = JDFlipAnimationDirectionUp;
	if (self.targetValue < self.value) {
        direction = JDFlipAnimationDirectionDown;
	}
	
    // don't send delegate messages
    self.delegateEnabled = NO;
    
	// determine speed per digit
	NSInteger difference = ABS(self.targetValue-self.value);
	CGFloat speed = ABS(duration/difference);
	[self animateInDirection:direction timeInterval:speed];
	
    // send delegate messages again
    self.delegateEnabled = YES;
	
	// enable target mode (this has do be done after animation start)
	self.targetMode = YES;
}


#pragma mark -
#pragma mark cancel animation

- (void)stopAnimation;
{
	self.targetMode = NO;
    [self.animationTimer invalidate];
    self.animationTimer = nil;
    self.intervalRest = 0;
    self.completionBlock = nil;
    
    if (self.targetMode) {
        // inform delegate
        if ([self.delegate respondsToSelector:@selector(flipNumberView:didChangeValueAnimated:)]) {
            [self.delegate flipNumberView:self didChangeValueAnimated:NO];
        }
        // call completion block
        if (self.completionBlock != nil) {
            JDFlipAnimationCompletionBlock completion = self.completionBlock;
            self.completionBlock = nil;
            completion(NO);
        }
    }
}

#pragma mark -
#pragma mark layout

- (NSUInteger)marginForWidth:(CGFloat)width;
{
    if (self.digitViews.count <= 1) return 0;
    return ((width*JDFlipViewRelativeMargin)/(self.digitViews.count-1));
}

- (CGSize)sizeThatFits:(CGSize)size;
{
	if (self.digitViews && self.digitViews.count > 0)
    {
        CGFloat xpos = 0;
        CGSize lastSize = CGSizeZero;
		NSUInteger i, count = self.digitViews.count;
        NSUInteger margin = [self marginForWidth:size.width];
        NSUInteger xWidth = ((size.width-margin*(count-1))/count);
		for (i = 0; i < count; i++) {
			JDFlipNumberDigitView* view = self.digitViews[i];
			lastSize = [view sizeThatFits:CGSizeMake(xWidth, size.height)];
			xpos += lastSize.width + margin;
		}
        xpos -= margin;
        
        // take bottom right of last view for new size, to match size of subviews
        return CGSizeMake(floor(xpos), floor(lastSize.height));
	}
    
    return [super sizeThatFits:size];
}

- (void)layoutSubviews;
{
    [super layoutSubviews];
    
	if (self.digitViews && self.digitViews.count > 0)
    {
        CGSize frameSize = self.bounds.size;
        
        CGFloat xpos = 0;
		NSUInteger i, count = self.digitViews.count;
        NSUInteger margin = [self marginForWidth:frameSize.width];
        NSUInteger xWidth = ((frameSize.width-margin*(count-1))/count);
        
        // allow upscaling for layout
		for (i = 0; i < count; i++) {
			JDFlipNumberDigitView* view = self.digitViews[i];
            view.upscalingAllowed = YES;
        }
        
        // apply calculated size to first digitView & update to actual sizes
        JDFlipNumberDigitView *firstDigit = self.digitViews[0];
        firstDigit.frame = CGRectMake(0, 0, floor(xWidth), floor(frameSize.height));
        xWidth = firstDigit.frame.size.width;
        margin = [self marginForWidth:xWidth];
        
		for (i = 0; i < count; i++) {
			JDFlipNumberDigitView* view = self.digitViews[i];
			view.frame = CGRectMake(round(xpos), 0, floor(xWidth), floor(frameSize.height));
            xpos = floor(CGRectGetMaxX(view.frame)+margin);
		}
        xpos -= margin;
        
        // center views in superview
        CGPoint centerOffset = CGPointMake(xpos, firstDigit.frame.size.height);
        centerOffset.x = floor((self.bounds.size.width - centerOffset.x)/2.0);
        centerOffset.y = floor((self.bounds.size.height - centerOffset.y)/2.0);
        for (NSInteger i=0; i<count; i++) {
			JDFlipNumberDigitView* view = self.digitViews[i];
            view.frame = CGRectOffset(view.frame, centerOffset.x, centerOffset.y);
        }
        
        // stop upscaling, so sizeToFit works properly
		for (i = 0; i < count; i++) {
			JDFlipNumberDigitView* view = self.digitViews[i];
            view.upscalingAllowed = NO;
        }
	}
}

@end


