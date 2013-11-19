//
//  UIView+JDFlipImageView.m
//  FlipNumberViewExample
//
//  Created by Markus on 19.11.13.
//  Copyright (c) 2013 markusemrich. All rights reserved.
//

#import "UIView+JDFlipImageView.h"

@implementation UIView (JDFlipImageView)

- (void)flipToView:(UIView*)view;
{
    [self flipToView:view duration:JDFlipImageViewDefaultFlipDuration removeView:YES
           direction:JDFlipImageViewFlipDirectionDown completion:nil];
}

- (void)flipToView:(UIView*)view
        completion:(JDFlipImageViewCompletionBlock)completion;
{
    [self flipToView:view duration:JDFlipImageViewDefaultFlipDuration removeView:YES
           direction:JDFlipImageViewFlipDirectionDown completion:completion];
}

- (void)flipToView:(UIView*)view
          duration:(CGFloat)duration
        completion:(JDFlipImageViewCompletionBlock)completion;
{
    [self flipToView:view duration:duration removeView:YES
           direction:JDFlipImageViewFlipDirectionDown completion:completion];
}

- (void)flipToView:(UIView*)view
          duration:(CGFloat)duration
         direction:(JDFlipImageViewFlipDirection)direction
        completion:(JDFlipImageViewCompletionBlock)completion;
{
    [self flipToView:view duration:duration removeView:YES
           direction:direction completion:completion];
}

- (void)flipToView:(UIView*)view
          duration:(CGFloat)duration
        removeView:(BOOL)removeFromSuperView
         direction:(JDFlipImageViewFlipDirection)direction
        completion:(JDFlipImageViewCompletionBlock)completion;
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000 // only when SDK is >= ios7
    if ([self respondsToSelector:@selector(snapshotViewAfterScreenUpdates:)]) {
        CGSize size = self.bounds.size;
        
        // old screenshot
        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
        [self drawViewHierarchyInRect:(CGRect){CGPointZero, size} afterScreenUpdates:NO];
        UIImage *oldImage = UIGraphicsGetImageFromCurrentImageContext();
        [view drawViewHierarchyInRect:(CGRect){CGPointZero, size} afterScreenUpdates:YES];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        // add new view
        [self.superview addSubview:view];
        
        // create & add flipview
        JDFlipImageView *flipImageView = [[JDFlipImageView alloc] initWithImage:oldImage];
        flipImageView.frame = self.frame;
        view.frame = self.frame;
        [self.superview addSubview:flipImageView];

        // animate
        __weak typeof(flipImageView) blockFlipImageView = flipImageView;
        [flipImageView setImageAnimated:newImage duration:duration completion:^(BOOL finished) {
            [blockFlipImageView removeFromSuperview];
            if (completion) {
                completion(finished);
            }
        }];
        
        // remove old view
        if (removeFromSuperView) {
            [self removeFromSuperview];
        }
    }
#endif
}

@end
