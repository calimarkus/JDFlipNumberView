//
//  JDCountdownFlipView.h
//
//  Created by Markus Emrich on 12.03.11.
//  Copyright 2011 Markus Emrich. All rights reserved.
//


#import "JDGroupedFlipNumberView.h"


@interface JDDateCountdownFlipView : UIView <JDGroupedFlipNumberViewDelegate>
{
    JDGroupedFlipNumberView* mFlipNumberViewDay;
    JDGroupedFlipNumberView* mFlipNumberViewHour;
    JDGroupedFlipNumberView* mFlipNumberViewMinute;
    JDGroupedFlipNumberView* mFlipNumberViewSecond;
}

- (id)initWithTargetDate: (NSDate*) targetDate;

- (void) setTargetDate: (NSDate*) targetDate;
- (void) setZDistance: (NSUInteger) zDistance;

- (void) setDebugValues;

@end
