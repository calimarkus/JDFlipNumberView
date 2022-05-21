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


NS_ASSUME_NONNULL_BEGIN

@interface JDFlipNumberDigitView : UIView

@property (nonatomic, assign) NSInteger value;
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, assign) BOOL upscalingAllowed;
@property (nonatomic, assign) NSInteger zDistance;

- (instancetype)initWithImageBundle:(JDFlipNumberViewImageBundle * _Nullable)imageBundle;

- (void)setValueAnimated:(NSInteger)value
           animationType:(JDFlipAnimationType)animationType
              completion:(JDDigitAnimationCompletionBlock _Nullable)completionBlock;

@end

NS_ASSUME_NONNULL_END
