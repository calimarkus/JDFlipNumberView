//
//  JDFlipNumberView.m
//
//  Created by Markus Emrich on 27.02.11.
//  Copyright 2011 Markus Emrich. All rights reserved.
//

#import "JDFlipNumberDigitView.h"

#import "JDFlipNumberView.h"


static CGFloat JDFlipAnimationMinimumTimeInterval = 0.01; // = 100 fps
static CGFloat JDFlipViewRelativeMargin = 0.15; // use 15% of width as margin


typedef NS_OPTIONS(NSUInteger, JDFlipAnimationDirection) {
	JDFlipAnimationDirectionUp,
	JDFlipAnimationDirectionDown
};

@interface JDFlipNumberView ()
@property (nonatomic, strong) NSArray *digitViews;
@property (nonatomic, assign) JDFlipAnimationType animationType;

@property (nonatomic, strong) NSTimer *animationTimer;
@property (nonatomic, assign) NSTimeInterval neededInterval;
@property (nonatomic, assign) NSTimeInterval intervalRest;
@property (nonatomic, assign) BOOL targetMode;
@property (nonatomic, assign) NSInteger targetValue;
@property (nonatomic, copy) JDFlipAnimationCompletionBlock completionBlock;

- (void)setValue:(NSInteger)newValue animatedInCurrentDirection:(BOOL)animated;
- (void)animateInDirection:(JDFlipAnimationDirection)direction
              timeInterval:(NSTimeInterval)timeInterval;
@end

@implementation JDFlipNumberView

- (id)init;
{
	return [self initWithDigitCount:1];
}

- (id)initWithDigitCount:(NSUInteger)digitCount;
{
    self = [super initWithFrame:CGRectZero];
    if (self)
	{
		self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        self.autoresizesSubviews = NO;
        _digitCount = digitCount;
        
        // init single digit views
		JDFlipNumberDigitView* view = nil;
		NSMutableArray* allViews = [[NSMutableArray alloc] initWithCapacity:digitCount];
		for (int i = 0; i < digitCount; i++) {
			view = [[JDFlipNumberDigitView alloc] init];
			view.frame = CGRectMake(i*view.frame.size.width, 0, view.frame.size.width, view.frame.size.height);
			[self addSubview: view];
			[allViews addObject: view];
		}
		self.digitViews = [[NSArray alloc] initWithArray: allViews];
        
        // setup properties
        self.animationType = JDFlipAnimationTypeTopDown;
        self.maximumValue = pow(10, digitCount)-1;
        self.targetMode = NO;
		super.frame = CGRectMake(0, 0, digitCount*view.frame.size.width, view.frame.size.height);
    }
    return self;
}


#pragma mark -
#pragma mark external access

- (NSInteger)value;
{
	NSMutableString* stringValue = [NSMutableString stringWithCapacity:self.digitViews.count];
	for (JDFlipNumberDigitView* view in self.digitViews) {
		[stringValue appendFormat: @"%d", view.value];
	}
	
	return [stringValue intValue];
}

- (void)setValue:(NSInteger)value;
{
    [self stopAnimation];
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
	if (animated && [self.delegate respondsToSelector: @selector(flipNumberView:willChangeToValue:)]) {
		[self.delegate flipNumberView:self willChangeToValue:newValue];
	}
    
    // convert to string
	NSString* stringValue = [NSString stringWithFormat: @"%50d", newValue];
	
    // udpate all flipviews, that have changed
    __block NSUInteger completedDigits = 0;
	for (int i=0; i<stringValue.length && i<self.digitViews.count; i++) {
		JDFlipNumberDigitView* view = (JDFlipNumberDigitView*)self.digitViews[self.digitViews.count-(1+i)];
		NSInteger newValue = [[stringValue substringWithRange:NSMakeRange(stringValue.length-(1+i), 1)] intValue];
        if (newValue != view.value) {
            if(animated) {
                [view setValue:newValue withAnimationType:self.animationType completion:^(BOOL completed){
                    completedDigits = completedDigits + 1;
                    if (completedDigits == self.digitViews.count) {
                        // inform delegate, when all digits finished animation
                        if (animated && [self.delegate respondsToSelector: @selector(flipNumberView:didChangeValueAnimated:)]) {
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
            if (self.completionBlock != nil) {
                self.completionBlock(YES);
                self.completionBlock = nil;
            }
            [self stopAnimation];
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
	NSString* strvalue = [NSString stringWithFormat: @"%50d", newValue];
	strvalue = [strvalue substringWithRange:NSMakeRange(strvalue.length-self.digitViews.count, self.digitViews.count)];
	self.targetValue = [self validValueFromValue:[strvalue intValue]];

    if (self.targetValue == self.value) {
        return;
    }
    
	// determine direction
	JDFlipAnimationDirection direction = JDFlipAnimationDirectionUp;
	if (self.targetValue < self.value) {
        direction = JDFlipAnimationDirectionDown;
	}
	
	// determine speed per digit
	NSInteger difference = ABS(self.targetValue-self.value);
	CGFloat speed = ABS(duration/difference);
	[self animateInDirection:direction timeInterval:speed];
	
	// enable target mode (this has do be done after animation start)
	self.targetMode = YES;
}


#pragma mark -
#pragma mark cancel animation

- (void)stopAnimation;
{
    if (self.targetMode && self.completionBlock != nil) {
        self.completionBlock(NO);
    }
    
	self.targetMode = NO;
    [self.animationTimer invalidate];
    self.animationTimer = nil;
    self.intervalRest = 0;
    self.completionBlock = nil;
}

#pragma mark -
#pragma mark resizing

- (void)setFrame:(CGRect)frame;
{
	if (self.digitViews && self.digitViews.count > 0)
    {
        JDFlipNumberView* previousView = nil;
		NSUInteger i, count = self.digitViews.count;
        NSUInteger xWidth = (frame.size.width*(1-JDFlipViewRelativeMargin))/count;
		for (i = 0; i < count; i++) {
			JDFlipNumberView* view = self.digitViews[i];
            CGFloat xpos = 0;
            if (previousView) {
                xpos = floor(CGRectGetMaxX(previousView.frame)+CGRectGetWidth(previousView.frame)*JDFlipViewRelativeMargin);
            }
			view.frame = CGRectMake(xpos, 0, xWidth, frame.size.height);
			previousView = self.digitViews[i];
		}
        
		// take bottom right of last view for new size, to match size of subviews
		frame.size.width  = ceil(previousView.frame.size.width  + previousView.frame.origin.x);
		frame.size.height = ceil(previousView.frame.size.height + previousView.frame.origin.y);
	}
    
    [super setFrame:frame];
}

@end


