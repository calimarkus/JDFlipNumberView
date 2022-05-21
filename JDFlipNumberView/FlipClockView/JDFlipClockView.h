//
//  JDFlipClockView.h
//  FlipNumberViewExample
//
//  Created by Markus Emrich on 09.11.13.
//  Copyright (c) 2013 markusemrich. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JDFlipNumberViewImageBundle;

NS_ASSUME_NONNULL_BEGIN

@interface JDFlipClockView : UIView

/// The margin between hours/minutes/seconds relative to the width of the hours, range 0-1
@property (nonatomic, assign) CGFloat relativeDigitMargin;
@property (nonatomic, assign) BOOL animationsEnabled;
@property (nonatomic, assign) BOOL showsSeconds;
@property (nonatomic, assign) NSInteger zDistance;

- (instancetype)initWithImageBundle:(JDFlipNumberViewImageBundle * _Nullable)imageBundle;

@end

NS_ASSUME_NONNULL_END

