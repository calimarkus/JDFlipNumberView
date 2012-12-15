//
//  FlipNumberView.h
//
//  Created by Markus Emrich on 26.02.11.
//  Copyright 2011 Markus Emrich. All rights reserved.
//


@protocol JDFlipNumberViewDelegate;

@interface JDFlipNumberView : UIView

@property (nonatomic, weak) id<JDFlipNumberViewDelegate> delegate;
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, assign) NSUInteger intValue;

- (void)setIntValue:(NSUInteger)intValue animated:(BOOL)animated;

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