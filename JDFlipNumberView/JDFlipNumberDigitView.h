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

@property (nonatomic, assign) NSUInteger value;
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, assign) BOOL upscalingAllowed;
@property (nonatomic, assign) NSUInteger zDistance;
@property (nonatomic, copy) NSString *imageBundleName;

- (id)initWithImageBundle:(NSString*)imageBundleName;

- (void)setValue:(NSUInteger)value withAnimationType:(JDFlipAnimationType)animationType
      completion:(JDDigitAnimationCompletionBlock)completionBlock;

@end