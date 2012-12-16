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


@interface JDFlipNumberDigitView : UIView

@property (nonatomic, weak) id<JDFlipNumberDigitViewDelegate> delegate;
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, assign) NSUInteger value;

- (void)setValue:(NSUInteger)value withAnimationType:(JDFlipAnimationType)animation;

- (void)setFrame:(CGRect)rect allowUpscaling:(BOOL)upscalingAllowed;
- (void)setZDistance:(NSUInteger)zDistance;

@end


#pragma mark -
#pragma mark JDFlipNumberViewDelegate

@protocol JDFlipNumberDigitViewDelegate <NSObject>
@optional
- (void)flipNumberDigit:(JDFlipNumberDigitView*)flipNumberDigit willChangeToValue:(NSUInteger)newValue animated:(BOOL)animated;
- (void)flipNumberDigit:(JDFlipNumberDigitView*)flipNumberDigit didChangeValueAnimated:(BOOL)animated;
@end;