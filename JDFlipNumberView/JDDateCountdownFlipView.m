//
//  JDCountdownFlipView.m
//
//  Created by Markus Emrich on 12.03.11.
//  Copyright 2011 Markus Emrich. All rights reserved.
//

#import "JDDateCountdownFlipView.h"


@implementation JDDateCountdownFlipView

- (id)init
{
    return [self initWithTargetDate: [NSDate date]];
}


- (id)initWithTargetDate: (NSDate*) targetDate
{
    self = [super initWithFrame: CGRectZero];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.autoresizesSubviews = NO;
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
		
        mFlipNumberViewDay    = [[JDGroupedFlipNumberView alloc] initWithFlipNumberViewCount: 3];
        mFlipNumberViewHour   = [[JDGroupedFlipNumberView alloc] initWithFlipNumberViewCount: 2];
        mFlipNumberViewMinute = [[JDGroupedFlipNumberView alloc] initWithFlipNumberViewCount: 2];
        mFlipNumberViewSecond = [[JDGroupedFlipNumberView alloc] initWithFlipNumberViewCount: 2];
        
        mFlipNumberViewDay.delegate    = self;
        mFlipNumberViewHour.delegate   = self;
        mFlipNumberViewMinute.delegate = self;
        mFlipNumberViewSecond.delegate = self;
        
        mFlipNumberViewHour.maximumValue = 23;
        mFlipNumberViewMinute.maximumValue = 59;
        mFlipNumberViewSecond.maximumValue = 59;
        
        [self setZDistance: 60];
        
        CGRect frame = mFlipNumberViewHour.frame;
        CGFloat spacing = floorf(frame.size.width*0.1);
        
        self.frame = CGRectMake(0, 0, frame.size.width*4+spacing*3, frame.size.height);
        
        frame.origin.x += frame.size.width + spacing;
        mFlipNumberViewHour.frame = frame;
        frame.origin.x += frame.size.width + spacing;
        mFlipNumberViewMinute.frame = frame;
        frame.origin.x += frame.size.width + spacing;
        mFlipNumberViewSecond.frame = frame;
        
        [self addSubview: mFlipNumberViewDay];
        [self addSubview: mFlipNumberViewHour];
        [self addSubview: mFlipNumberViewMinute];
        [self addSubview: mFlipNumberViewSecond];
        
        [self setTargetDate: targetDate];
        
        [mFlipNumberViewSecond animateDownWithTimeInterval: 1.0];
    }
    return self;
}

- (void)dealloc
{
    [mFlipNumberViewDay release];
    [mFlipNumberViewHour release];
    [mFlipNumberViewMinute release];
    [mFlipNumberViewSecond release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark DEBUG

- (void) setDebugValues
{
    // DEBUG
    
    mFlipNumberViewHour.maximumValue = 2;
    mFlipNumberViewMinute.maximumValue = 2;
    mFlipNumberViewSecond.maximumValue = 4;
    
    mFlipNumberViewHour.intValue = 2;
    mFlipNumberViewMinute.intValue = 2;
    mFlipNumberViewSecond.intValue = 4;
    
    [mFlipNumberViewSecond animateDownWithTimeInterval: 0.5];
}

#pragma mark -

- (void) setZDistance: (NSUInteger) zDistance
{
    [mFlipNumberViewDay setZDistance: zDistance];
    [mFlipNumberViewHour setZDistance: zDistance];
    [mFlipNumberViewMinute setZDistance: zDistance];
    [mFlipNumberViewSecond setZDistance: zDistance];
}

- (void) setTargetDate: (NSDate*) targetDate
{
    NSUInteger flags = NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents* dateComponents = [[NSCalendar currentCalendar] components: flags fromDate: [NSDate date] toDate: targetDate options: 0];
    
    mFlipNumberViewDay.intValue    = [dateComponents day];
    mFlipNumberViewHour.intValue   = [dateComponents hour];
    mFlipNumberViewMinute.intValue = [dateComponents minute];
    mFlipNumberViewSecond.intValue = [dateComponents second];
}

- (void) setFrame: (CGRect) rect
{
    CGFloat digitWidth = rect.size.width/10.0;
    CGFloat margin     = digitWidth/3.0;
    CGFloat currentX   = 0;
    
    mFlipNumberViewDay.frame = CGRectMake(currentX, 0, digitWidth*3, rect.size.height);
    currentX   += mFlipNumberViewDay.frame.size.width;
    
    for (JDGroupedFlipNumberView* view in [NSArray arrayWithObjects: mFlipNumberViewHour, mFlipNumberViewMinute, mFlipNumberViewSecond, nil])
    {
        currentX   += margin;
        view.frame = CGRectMake(currentX, 0, digitWidth*2, rect.size.height);
        currentX   += view.frame.size.width;
    }
    
    // take bottom right of last view for new size, to match size of subviews
    CGRect lastFrame = mFlipNumberViewSecond.frame;
    rect.size.width  = ceil(lastFrame.size.width  + lastFrame.origin.x);
    rect.size.height = ceil(lastFrame.size.height + lastFrame.origin.y);
    
    [super setFrame: rect];
}

#pragma mark -
#pragma mark GroupedFlipNumberViewDelegate


- (void) groupedFlipNumberView: (JDGroupedFlipNumberView*) groupedFlipNumberView willChangeToValue: (NSUInteger) newValue
{
//    LOG(@"ToValue: %d", newValue);
    
    JDGroupedFlipNumberView* animateView = nil;
    
    if (groupedFlipNumberView == mFlipNumberViewSecond) {
        animateView = mFlipNumberViewMinute;
    }
    else if (groupedFlipNumberView == mFlipNumberViewMinute) {
        animateView = mFlipNumberViewHour;
    }
    else if (groupedFlipNumberView == mFlipNumberViewHour) {
        animateView = mFlipNumberViewDay;
    }
    
    if (animateView != nil)
    {
        if (groupedFlipNumberView.currentDirection == eFlipDirectionDown && newValue == groupedFlipNumberView.maximumValue)
        {
            [animateView animateToPreviousNumber];
        }
        else if (groupedFlipNumberView.currentDirection == eFlipDirectionUp && newValue == 0)
        {
            [animateView animateToNextNumber];
        }
    }
}


- (void) groupedFlipNumberView: (JDGroupedFlipNumberView*) groupedFlipNumberView didChangeValue: (NSUInteger) newValue animated: (BOOL) animated
{
}

@end
