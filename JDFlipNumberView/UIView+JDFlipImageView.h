//
//  UIView+JDFlipImageView.h
//  FlipNumberViewExample
//
//  Created by Markus on 19.11.13.
//  Copyright (c) 2013 markusemrich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JDFlipImageView.h"

@interface UIView (JDFlipImageView)

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

@end
