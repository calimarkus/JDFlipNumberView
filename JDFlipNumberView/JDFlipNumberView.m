//
//  JDFlipNumberView.m
//
//  Created by Markus Emrich on 27.02.11.
//  Copyright 2011 Markus Emrich. All rights reserved.
//

#import "JDFlipNumberDigitView.h"

#import "JDFlipNumberView.h"


typedef NS_OPTIONS(NSUInteger, JDFlipAnimationDirection) {
	JDFlipAnimationDirectionUp,
	JDFlipAnimationDirectionDown
};

@interface JDFlipNumberView ()
@property (nonatomic, strong) NSArray *digitViews;
@property (nonatomic, strong) NSTimer *animationTimer;
@property (nonatomic, assign) BOOL targetMode;
@property (nonatomic, assign) NSInteger targetValue;
@property (nonatomic, assign) JDFlipAnimationType animationType;
- (void)setValue:(NSInteger)newValue animatedInCurrentDirection:(BOOL)animated;
- (void)animateInDirection:(JDFlipAnimationDirection)direction
              timeInterval:(NSTimeInterval)timeInterval;
- (NSUInteger)validValueFromValue:(NSInteger)value;
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
    [self setValue:value animated:NO];
}

- (void)setValue:(NSInteger)newValue animated:(BOOL)animated;
{
    self.animationType = JDFlipAnimationTypeTopDown;
    if (newValue < self.value) {
        self.animationType = JDFlipAnimationTypeBottomUp;
    }
    
    [self setValue:newValue animatedInCurrentDirection:animated];
}

- (void)setValue:(NSInteger)newValue animatedInCurrentDirection:(BOOL)animated;
{
    // stay in max bounds
    newValue = [self validValueFromValue:newValue];
    
    // convert to string
	NSString* stringValue = [NSString stringWithFormat: @"%50d", newValue];
	
    // udpate all flipviews, that have changed
	for (int i=0; i<stringValue.length && i<self.digitViews.count; i++) {
		JDFlipNumberDigitView* view = (JDFlipNumberDigitView*)self.digitViews[self.digitViews.count-(1+i)];
		NSInteger newValue = [[stringValue substringWithRange:NSMakeRange(stringValue.length-(1+i), 1)] intValue];
        if (newValue != view.value) {
            [view setValue:newValue withAnimationType:self.animationType];
        }
	}
	
	if ([self.delegate respondsToSelector: @selector(flipNumberView:didChangeValueAnimated:)]) {
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
    self.animationDuration = timeInterval;
    
    // choose selector
    self.animationType = JDFlipAnimationTypeTopDown;
    if (direction == JDFlipAnimationDirectionDown) {
        self.animationType = JDFlipAnimationTypeBottomUp;
    }
    
    // setup timer
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                                           target:self
                                                         selector:@selector(handleTimer:)
                                                         userInfo:nil
                                                          repeats:YES];
}

- (void)handleTimer:(NSTimer*)timer
{
    NSInteger newValue = self.value+1;
    if (self.animationType == JDFlipAnimationTypeBottomUp) {
        newValue = self.value-1;
    }
    newValue = [self validValueFromValue:newValue];
    
    if (self.targetMode) {
        if (newValue == self.targetValue ||
            (self.animationType == JDFlipAnimationTypeTopDown && newValue > self.targetValue) ||
            (self.animationType == JDFlipAnimationTypeBottomUp && newValue < self.targetValue)) {
            [self setValue:self.targetValue animatedInCurrentDirection:YES];
            [self stopAnimation];
            return;
        }
    }
    
    [self setValue:newValue animatedInCurrentDirection:YES];
}

#pragma mark -
#pragma mark targeted animation

- (void)animateToValue:(NSInteger)newValue withDuration:(CGFloat)duration;
{
    [self stopAnimation];
    
	// save target value in valid range
	NSString* strvalue = [NSString stringWithFormat: @"%50d", newValue];
	strvalue = [strvalue substringWithRange:NSMakeRange(strvalue.length-self.digitViews.count, self.digitViews.count)];
	self.targetValue = [strvalue intValue];

    if (newValue == self.value) {
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
    
    // @TOOD: fix targeted animation, use startDate and endDate and targetValue
    // because too small timeIntervals cannot be handled by NSTimer.
    // use 1/60.0 maximum timer interval for 60fps updates
}


#pragma mark -
#pragma mark cancel animation

- (void)stopAnimation;
{
	self.targetMode = NO;
    [self.animationTimer invalidate];
    self.animationTimer = nil;
}

#pragma mark -
#pragma mark resizing

- (void)setFrame:(CGRect)frame;
{
    JDFlipNumberView* view = nil;
	if (self.digitViews && self.digitViews.count > 0) {
		NSUInteger i, count = self.digitViews.count, xWidth = frame.size.width/count;
		for (i = 0; i < count; i++) {
			view = self.digitViews[i];
			view.frame = CGRectMake(i*xWidth, 0, xWidth, frame.size.height);
		}
	}
    
    if (view) {
		// take bottom right of last view for new size, to match size of subviews
		frame.size.width  = ceil(view.frame.size.width  + view.frame.origin.x);
		frame.size.height = ceil(view.frame.size.height + view.frame.origin.y);
    }
    
    [super setFrame:frame];
}

@end


