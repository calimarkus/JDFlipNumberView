//
//  JDFlipNumberView.h
//
//  Created by Markus Emrich on 27.02.11.
//  Copyright 2011 Markus Emrich. All rights reserved.
//

@protocol JDFlipNumberViewDelegate;
@class JDFlipNumberViewImageBundle;

typedef void(^JDFlipAnimationCompletionBlock)(BOOL finished);

NS_ASSUME_NONNULL_BEGIN

@interface JDFlipNumberView : UIView

@property (nonatomic, weak) id<JDFlipNumberViewDelegate> delegate;

@property (nonatomic, assign) NSInteger value;
@property (nonatomic, assign) NSInteger maximumValue;
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, assign) BOOL reverseFlippingAllowed;
@property (nonatomic, assign) NSInteger zDistance;
@property (nonatomic, assign) NSInteger digitCount;
@property (nonatomic, assign) CGFloat relativeDigitMargin;
@property (nonatomic, assign) CGFloat absoluteDigitMargin;

- (instancetype)initWithInitialValue:(NSInteger)value;
- (instancetype)initWithInitialValue:(NSInteger)value
                          digitCount:(NSInteger)digitCount;
- (instancetype)initWithInitialValue:(NSInteger)value
                          digitCount:(NSInteger)digitCount
                         imageBundle:(JDFlipNumberViewImageBundle * _Nullable)imageBundle;
- (instancetype)initWithInitialValue:(NSInteger)value
                         imageBundle:(JDFlipNumberViewImageBundle * _Nullable)imageBundle;

- (instancetype)initWithDigitCount:(NSInteger)digitCount;
- (instancetype)initWithDigitCount:(NSInteger)digitCount
                         imageBundle:(JDFlipNumberViewImageBundle * _Nullable)imageBundle;

// direct value manipulation (jump to value)
- (void)setValue:(NSInteger)newValue animated:(BOOL)animated;
- (NSInteger)validValueFromValue:(NSInteger)value;

// animate over every value between old and new value
- (void)animateToValue:(NSInteger)newValue duration:(CGFloat)duration;
- (void)animateToValue:(NSInteger)newValue duration:(CGFloat)duration completion:(JDFlipAnimationCompletionBlock _Nullable)completion;

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

- (void)flipNumberView:(JDFlipNumberView*)flipNumberView willChangeToValue:(NSInteger)newValue;
- (void)flipNumberView:(JDFlipNumberView*)flipNumberView didChangeValueAnimated:(BOOL)animated;
@end;

NS_ASSUME_NONNULL_END
