//
//  JDFlipNumberDigitView.h
//
//  Created by Markus Emrich on 26.02.11.
//  Copyright 2011 Markus Emrich. All rights reserved.
//


@protocol JDFlipNumberDigitViewDelegate;
@class JDFlipNumberViewImageBundle;

typedef NS_OPTIONS(NSInteger, JDFlipAnimationType) {
    JDFlipAnimationTypeNone,
	JDFlipAnimationTypeTopDown,
	JDFlipAnimationTypeBottomUp
};

typedef void(^JDDigitAnimationCompletionBlock)(BOOL finished);


@interface JDFlipNumberDigitView : UIView

@property (nonatomic, assign) NSInteger value;
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, assign) BOOL upscalingAllowed;
@property (nonatomic, assign) NSInteger zDistance;
@property (nonatomic, readonly) JDFlipNumberViewImageBundle *imageBundle;

- (instancetype)initWithImageBundle:(JDFlipNumberViewImageBundle *)imageBundle;

- (void)setValue:(NSInteger)value withAnimationType:(JDFlipAnimationType)animationType
      completion:(JDDigitAnimationCompletionBlock)completionBlock;

@end
