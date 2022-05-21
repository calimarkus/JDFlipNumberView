//
//  JDCountdownFlipView.h
//
//  Created by Markus Emrich on 12.03.11.
//  Copyright 2011 Markus Emrich. All rights reserved.
//

@class JDFlipNumberViewImageBundle;

@interface JDDateCountdownFlipView : UIView

@property (nonatomic, strong) NSDate *targetDate;
@property (nonatomic, assign) NSUInteger zDistance;
@property (nonatomic, assign) BOOL animationsEnabled;

- (instancetype)initWithDayDigitCount:(NSInteger)dayDigits;
- (instancetype)initWithDayDigitCount:(NSInteger)dayDigits
            imageBundle:(JDFlipNumberViewImageBundle *)imageBundle;

@end
