//
//  JDFlipNumberDigitView.h
//
//  Created by Markus Emrich on 26.02.11.
//  Copyright 2011 Markus Emrich. All rights reserved.
//


@protocol JDFlipNumberDigitViewDelegate;

typedef NS_OPTIONS(NSUInteger, JDFlipAnimationType) {
    JDFlipAnimationTypeNone,
	JDFlipAnimationTypeTopDown,
	JDFlipAnimationTypeBottomUp
};

typedef void(^JDDigitAnimationCompletionBlock)(BOOL finished);


@interface JDFlipNumberDigitView : UIView

@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, assign) NSUInteger value;

- (void)setValue:(NSUInteger)value withAnimationType:(JDFlipAnimationType)animationType
      completion:(JDDigitAnimationCompletionBlock)completionBlock;

- (void)setFrame:(CGRect)rect allowUpscaling:(BOOL)upscalingAllowed;
- (void)setZDistance:(NSUInteger)zDistance;

@end