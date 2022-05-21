//
//  UIView+JDFlipImageView.h
//  FlipNumberViewExample
//
//  Created by Markus on 19.11.13.
//  Copyright (c) 2013 markusemrich. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JDFlipImageViewFlipDirection.h"

typedef void(^JDFlipImageViewCompletionBlock)(BOOL finished);
typedef void(^JDFlipImageViewViewUpdateBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface UIView (JDFlipImageView)

// Flip transition to another view

- (void)flipToView:(UIView*)view;

- (void)flipToView:(UIView*)view
        completion:(JDFlipImageViewCompletionBlock _Nullable)completion;

- (void)flipToView:(UIView*)view
          duration:(CGFloat)duration
        completion:(JDFlipImageViewCompletionBlock _Nullable)completion;

- (void)flipToView:(UIView*)view
          duration:(CGFloat)duration
         direction:(JDFlipImageViewFlipDirection)direction
        completion:(JDFlipImageViewCompletionBlock _Nullable)completion;

- (void)flipToView:(UIView*)view
          duration:(CGFloat)duration
        removeView:(BOOL)removeFromSuperView
         direction:(JDFlipImageViewFlipDirection)direction
        completion:(JDFlipImageViewCompletionBlock _Nullable)completion;

// Update a view using a flip animation

- (void)updateWithFlipAnimationUpdates:(JDFlipImageViewViewUpdateBlock)updates;

- (void)updateWithFlipAnimationUpdates:(JDFlipImageViewViewUpdateBlock)updates
                             completion:(JDFlipImageViewCompletionBlock _Nullable)completion;

- (void)updateWithFlipAnimationDuration:(CGFloat)duration
                                updates:(JDFlipImageViewViewUpdateBlock)updates
                             completion:(JDFlipImageViewCompletionBlock _Nullable)completion;

- (void)updateWithFlipAnimationDuration:(CGFloat)duration
                              direction:(JDFlipImageViewFlipDirection)direction
                                updates:(JDFlipImageViewViewUpdateBlock)updates
                             completion:(JDFlipImageViewCompletionBlock _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
