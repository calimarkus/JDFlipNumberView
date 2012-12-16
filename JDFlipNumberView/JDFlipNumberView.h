//
//  FlipNumberView.h
//
//  Created by Markus Emrich on 26.02.11.
//  Copyright 2011 Markus Emrich. All rights reserved.
//


@protocol JDFlipNumberViewDelegate;


typedef NS_OPTIONS(NSUInteger, JDFlipAnimationType) {
    JDFlipAnimationTypeNone,
	JDFlipAnimationTypeTopDown,
	JDFlipAnimationTypeBottomUp
};


@interface JDFlipNumberView : UIView

@property (nonatomic, weak) id<JDFlipNumberViewDelegate> delegate;
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, assign) NSUInteger value;

- (void)setValue:(NSUInteger)value withAnimationType:(JDFlipAnimationType)animation;

- (void)setFrame:(CGRect)rect allowUpscaling:(BOOL)upscalingAllowed;
- (void)setZDistance:(NSUInteger)zDistance;

@end


#pragma mark -
#pragma mark JDFlipNumberViewDelegate

@protocol JDFlipNumberViewDelegate <NSObject>
@optional
- (void)flipNumberView:(JDFlipNumberView*)flipNumberView willChangeToValue:(NSUInteger)newValue animated:(BOOL)animated;
- (void)flipNumberView:(JDFlipNumberView*)flipNumberView didChangeValueAnimated:(BOOL)animated;
@end;