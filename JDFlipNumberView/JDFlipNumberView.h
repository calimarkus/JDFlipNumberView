//
//  JDFlipNumberView.h
//
//  Created by Markus Emrich on 27.02.11.
//  Copyright 2011 Markus Emrich. All rights reserved.
//



@protocol JDFlipNumberViewDelegate;

typedef void(^JDFlipAnimationCompletionBlock)(BOOL finished);

@interface JDFlipNumberView : UIView

@property (nonatomic, weak) id<JDFlipNumberViewDelegate> delegate;
@property (nonatomic, assign) NSInteger value;
@property (nonatomic, assign) NSUInteger maximumValue;
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, readonly) NSUInteger digitCount;


- (id)initWithDigitCount:(NSUInteger)digitCount;

- (void)setZDistance:(NSUInteger)zDistance;

// direct value manipulation (jump to value)
- (void)setValue:(NSInteger)newValue animated:(BOOL)animated;
- (NSUInteger)validValueFromValue:(NSInteger)value;

// animate over every value between old and new value
- (void)animateToValue:(NSInteger)newValue duration:(CGFloat)duration;
- (void)animateToValue:(NSInteger)newValue duration:(CGFloat)duration completion:(JDFlipAnimationCompletionBlock)completion;

// basic animation
- (void)animateToNextNumber;
- (void)animateToPreviousNumber;

// timed animation
- (void)animateUpWithTimeInterval:(NSTimeInterval)timeInterval;
- (void)animateDownWithTimeInterval:(NSTimeInterval)timeInterval;

// cancel animation
- (void)stopAnimation;

@end


#pragma mark -
#pragma mark delegate

@protocol JDFlipNumberViewDelegate <NSObject>
@optional
- (void)flipNumberView:(JDFlipNumberView*)flipNumberView willChangeToValue:(NSUInteger)newValue;
- (void)flipNumberView:(JDFlipNumberView*)flipNumberView didChangeValueAnimated:(BOOL)animated;
@end;


