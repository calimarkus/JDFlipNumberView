//
//  JDCountdownFlipView.m
//
//  Created by Markus Emrich on 12.03.11.
//  Copyright 2011 Markus Emrich. All rights reserved.
//

#import "JDFlipNumberView.h"

#import "JDDateCountdownFlipView.h"

static CGFloat kFlipAnimationUpdateInterval = 0.5; // = 2 times per second

@interface JDDateCountdownFlipView ()
@property (nonatomic) NSInteger dayDigitCount;
@property (nonatomic, copy) NSString *imageBundleName;
@property (nonatomic, strong) JDFlipNumberView* dayFlipNumberView;
@property (nonatomic, strong) JDFlipNumberView* hourFlipNumberView;
@property (nonatomic, strong) JDFlipNumberView* minuteFlipNumberView;
@property (nonatomic, strong) JDFlipNumberView* secondFlipNumberView;

@property (nonatomic, strong) NSTimer *animationTimer;
@end

@implementation JDDateCountdownFlipView

- (id)init
{
    return [self initWithDayDigitCount:3];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [self initWithDayDigitCount:3];
    if (self) {
        self.frame = frame;
    }
    return self;
}

- (id)initWithDayDigitCount:(NSInteger)dayDigits;
{
    return [self initWithDayDigitCount:dayDigits imageBundleName:nil];
}

- (id)initWithDayDigitCount:(NSInteger)dayDigits
            imageBundleName:(NSString*)imageBundleName;
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _dayDigitCount = dayDigits;
        // view setup
        self.backgroundColor = [UIColor clearColor];
        self.autoresizesSubviews = NO;
		
        // setup flipviews
        _imageBundleName = imageBundleName;
        self.dayFlipNumberView = [[JDFlipNumberView alloc] initWithDigitCount:_dayDigitCount imageBundleName:imageBundleName];
        self.hourFlipNumberView = [[JDFlipNumberView alloc] initWithDigitCount:2 imageBundleName:imageBundleName];
        self.minuteFlipNumberView = [[JDFlipNumberView alloc] initWithDigitCount:2 imageBundleName:imageBundleName];
        self.secondFlipNumberView = [[JDFlipNumberView alloc] initWithDigitCount:2 imageBundleName:imageBundleName];
        
        // set maximum values
        self.hourFlipNumberView.maximumValue = 23;
        self.minuteFlipNumberView.maximumValue = 59;
        self.secondFlipNumberView.maximumValue = 59;
        
        // disable reverse flipping
        self.dayFlipNumberView.reverseFlippingDisabled = YES;
        self.hourFlipNumberView.reverseFlippingDisabled = YES;
        self.minuteFlipNumberView.reverseFlippingDisabled = YES;
        self.secondFlipNumberView.reverseFlippingDisabled = YES;

        [self setZDistance: 60];
        
        // set inital frame
        CGRect frame = self.hourFlipNumberView.frame;
        self.frame = CGRectMake(0, 0, frame.size.width*(dayDigits+7), frame.size.height);
        
        // add subviews
        for (JDFlipNumberView* view in @[self.dayFlipNumberView, self.hourFlipNumberView, self.minuteFlipNumberView, self.secondFlipNumberView]) {
            [self addSubview:view];
        }
        
        // set inital dates
        self.targetDate = [NSDate date];
        [self setupUpdateTimer];
    }
    return self;
}

#pragma mark setter

- (NSUInteger)zDistance;
{
    return self.dayFlipNumberView.zDistance;
}

- (void)setZDistance:(NSUInteger)zDistance;
{
    for (JDFlipNumberView* view in @[self.dayFlipNumberView, self.hourFlipNumberView, self.minuteFlipNumberView, self.secondFlipNumberView]) {
        [view setZDistance:zDistance];
    }
}

- (void)setTargetDate:(NSDate *)targetDate;
{
    _targetDate = targetDate;
    [self updateValuesAnimated:NO];
}

#pragma mark layout

- (CGSize)sizeThatFits:(CGSize)size;
{
    if (self.dayFlipNumberView == nil) {
        return [super sizeThatFits:size];
    }
    
    CGFloat digitWidth = size.width/(self.dayFlipNumberView.digitCount+7);
    CGFloat margin     = digitWidth/4.0;
    CGFloat currentX   = 0;
    
    // check first number size
    CGSize firstSize = CGSizeMake(digitWidth * self.dayDigitCount, size.height);
    firstSize = [self.dayFlipNumberView sizeThatFits:firstSize];
    currentX += firstSize.width;
    
    // check other numbers
    CGSize nextSize;
    for (JDFlipNumberView* view in @[self.hourFlipNumberView, self.minuteFlipNumberView, self.secondFlipNumberView]) {
        currentX += margin;
        nextSize = CGSizeMake(digitWidth*2, size.height);
        nextSize = [view sizeThatFits:nextSize];
        currentX += nextSize.width;
    }
    
    // use bottom right of last number
    size.width  = ceil(currentX);
    size.height = ceil(nextSize.height);
    
    return size;
}

- (void)layoutSubviews;
{
    [super layoutSubviews];
    
    if (self.dayFlipNumberView == nil) {
        return;
    }
    
    CGSize size = [self sizeThatFits:self.bounds.size];
    CGFloat digitWidth = size.width/(self.dayFlipNumberView.digitCount+7);
    CGFloat margin     = digitWidth/4.0;
    CGFloat currentX = round((self.bounds.size.width - size.width)/2.0);
    
    // resize first flipview
    self.dayFlipNumberView.frame = CGRectMake(currentX, 0, digitWidth * self.dayDigitCount, size.height);
    currentX += self.dayFlipNumberView.frame.size.width;
    
    // update flipview frames
    for (JDFlipNumberView* view in @[self.hourFlipNumberView, self.minuteFlipNumberView, self.secondFlipNumberView]) {
        currentX   += margin;
        view.frame = CGRectMake(currentX, 0, digitWidth*2, size.height);
        currentX   += view.frame.size.width;
    }
}

#pragma mark update timer


- (void)start;
{
    if (self.animationTimer == nil) {
        [self setupUpdateTimer];
    }
}

- (void)stop;
{
    [self.animationTimer invalidate];
    self.animationTimer = nil;
}

- (void)setupUpdateTimer;
{
    self.animationTimer = [NSTimer timerWithTimeInterval:kFlipAnimationUpdateInterval
                                                  target:self
                                                selector:@selector(handleTimer:)
                                                userInfo:nil
                                                 repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.animationTimer forMode:NSRunLoopCommonModes];
}

- (void)handleTimer:(NSTimer*)timer;
{
    [self updateValuesAnimated:YES];
}

- (void)updateValuesAnimated:(BOOL)animated;
{
    if (self.targetDate == nil) {
        return;
    }
    
    if ([self.targetDate timeIntervalSinceDate:[NSDate date]] > 0) {
        NSUInteger flags = NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSDateComponents* dateComponents = [[NSCalendar currentCalendar] components:flags fromDate:[NSDate date] toDate:self.targetDate options:0];
        
        [self.dayFlipNumberView setValue:[dateComponents day] animated:animated];
        [self.hourFlipNumberView setValue:[dateComponents hour] animated:animated];
        [self.minuteFlipNumberView setValue:[dateComponents minute] animated:animated];
        [self.secondFlipNumberView setValue:[dateComponents second] animated:animated];
    } else {
        [self.dayFlipNumberView setValue:0 animated:animated];
        [self.hourFlipNumberView setValue:0 animated:animated];
        [self.minuteFlipNumberView setValue:0 animated:animated];
        [self.secondFlipNumberView setValue:0 animated:animated];
        [self stop];
    }
}

@end
