//
//  JDCountdownFlipView.h
//
//  Created by Markus Emrich on 12.03.11.
//  Copyright 2011 Markus Emrich. All rights reserved.
//

@class JDFlipNumberViewImageBundle;

NS_ASSUME_NONNULL_BEGIN

@interface JDDateCountdownFlipView : UIView

@property (nonatomic, strong) NSDate *targetDate;
@property (nonatomic, assign) NSInteger zDistance;
@property (nonatomic, assign) BOOL animationsEnabled;

- (instancetype)initWithDayDigitCount:(NSInteger)dayDigits;
- (instancetype)initWithDayDigitCount:(NSInteger)dayDigits
                          imageBundle:(JDFlipNumberViewImageBundle * _Nullable)imageBundle;

@end

NS_ASSUME_NONNULL_END
