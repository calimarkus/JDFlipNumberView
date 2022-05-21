//
//  JDFlipNumberView.h
//
//  Created by Markus Emrich on 27.02.11.
//  Copyright 2011 Markus Emrich. All rights reserved.
//



@protocol JDFlipNumberViewDelegate;
@class JDFlipNumberViewImageBundle;

typedef void(^JDFlipAnimationCompletionBlock)(BOOL finished);

@interface JDFlipNumberView : UIView

@property (nonatomic, weak) id<JDFlipNumberViewDelegate> delegate;

@property (nonatomic, assign) NSInteger value;
@property (nonatomic, assign) NSUInteger maximumValue;
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, assign) BOOL reverseFlippingAllowed;
@property (nonatomic, assign) NSUInteger zDistance;
@property (nonatomic, assign) NSUInteger digitCount;
@property (nonatomic, assign) CGFloat relativeDigitMargin;
@property (nonatomic, assign) CGFloat absoluteDigitMargin;

- (instancetype)initWithDigitCount:(NSUInteger)digitCount;
- (instancetype)initWithDigitCount:(NSUInteger)digitCount
             imageBundle:(JDFlipNumberViewImageBundle *)imageBundle;

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


