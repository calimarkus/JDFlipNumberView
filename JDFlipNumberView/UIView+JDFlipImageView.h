//
//  UIView+JDFlipImageView.h
//  FlipNumberViewExample
//
//  Created by Markus on 19.11.13.
//  Copyright (c) 2013 markusemrich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JDFlipImageView.h"

typedef void(^JDFlipImageViewViewUpdateBlock)(void);

@interface UIView (JDFlipImageView)

// Flip transition to another view

- (void)flipToView:(UIView*)view;

- (void)flipToView:(UIView*)view
        completion:(JDFlipImageViewCompletionBlock)completion;

- (void)flipToView:(UIView*)view
          duration:(CGFloat)duration
        completion:(JDFlipImageViewCompletionBlock)completion;

- (void)flipToView:(UIView*)view
          duration:(CGFloat)duration
         direction:(JDFlipImageViewFlipDirection)direction
        completion:(JDFlipImageViewCompletionBlock)completion;

- (void)flipToView:(UIView*)view
          duration:(CGFloat)duration
        removeView:(BOOL)removeFromSuperView
         direction:(JDFlipImageViewFlipDirection)direction
        completion:(JDFlipImageViewCompletionBlock)completion;

// Update a view using a flip animation

- (void)updateWithFlipAnimationUpdates:(JDFlipImageViewViewUpdateBlock)updates;

- (void)updateWithFlipAnimationUpdates:(JDFlipImageViewViewUpdateBlock)updates
                             completion:(JDFlipImageViewCompletionBlock)completion;

- (void)updateWithFlipAnimationDuration:(CGFloat)duration
                                updates:(JDFlipImageViewViewUpdateBlock)updates
                             completion:(JDFlipImageViewCompletionBlock)completion;

- (void)updateWithFlipAnimationDuration:(CGFloat)duration
                              direction:(JDFlipImageViewFlipDirection)direction
                                updates:(JDFlipImageViewViewUpdateBlock)updates
                             completion:(JDFlipImageViewCompletionBlock)completion;

@end
