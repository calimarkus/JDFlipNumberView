//
//  CountdownFlipView.h
//  OneTwoThree
//
//  Created by Markus Emrich on 12.03.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "GroupedFlipNumberView.h"


@interface DateCountdownFlipView : UIView <GroupedFlipNumberViewDelegate>
{
    GroupedFlipNumberView* mFlipNumberViewDay;
    GroupedFlipNumberView* mFlipNumberViewHour;
    GroupedFlipNumberView* mFlipNumberViewMinute;
    GroupedFlipNumberView* mFlipNumberViewSecond;
}

- (id)initWithTargetDate: (NSDate*) targetDate;

- (void) setTargetDate: (NSDate*) targetDate;
- (void) setZDistance: (NSUInteger) zDistance;

- (void) setDebugValues;

@end
