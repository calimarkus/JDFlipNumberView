//
//  JDCountdownFlipView.h
//
//  Created by Markus Emrich on 12.03.11.
//  Copyright 2011 Markus Emrich. All rights reserved.
//


#import "JDFlipNumberView.h"


@interface JDDateCountdownFlipView : UIView

@property (nonatomic, strong) NSDate *targetDate;

- (id)initWithDayDigitCount:(NSInteger)dayDigits;

- (void)setZDistance:(NSUInteger)zDistance;

- (void)start;
- (void)stop;

- (void)updateValuesAnimated:(BOOL)animated;

@end
