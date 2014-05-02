//
//  UIView+JDFlipImageView.m
//  FlipNumberViewExample
//
//  Created by Markus on 19.11.13.
//  Copyright (c) 2013 markusemrich. All rights reserved.
//

#import "UIView+JDFlipImageView.h"
#import <QuartzCore/QuartzCore.h>

@interface UIView (JDFlipImageViewHidden)
- (UIImage*)imageSnapshotAfterScreenUpdates:(BOOL)afterScreenUpdates;
- (JDFlipImageView*)addFlipViewWithAnimationFromImage:(UIImage*)fromImage
                                              toImage:(UIImage*)toImage
                                             duration:(NSTimeInterval)duration
                                            direction:(JDFlipImageViewFlipDirection)direction
                                           completion:(JDFlipImageViewCompletionBlock)completion;
@end

@implementation UIView (JDFlipImageView)

#pragma mark Flip transition to another view

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
    // screenshots
    UIImage *oldImage = [self imageSnapshotAfterScreenUpdates:NO];
    UIImage *newImage = [view imageSnapshotAfterScreenUpdates:YES];
    
    // add new view
    [self.superview insertSubview:view belowSubview:self];
    view.frame = self.frame;
    
    // create & add flipview
    [self addFlipViewWithAnimationFromImage:oldImage toImage:newImage
                                   duration:duration direction:direction
                                 completion:completion];

    // remove old view
    if (removeFromSuperView) {
        [self removeFromSuperview];
    }
}

#pragma mark View updates using a flip animation

- (void)updateWithFlipAnimationUpdates:(JDFlipImageViewViewUpdateBlock)updates;
{
    [self updateWithFlipAnimationDuration:JDFlipImageViewDefaultFlipDuration
                                direction:JDFlipImageViewFlipDirectionDown
                                  updates:updates completion:nil];
}

- (void)updateWithFlipAnimationUpdates:(JDFlipImageViewViewUpdateBlock)updates
                            completion:(JDFlipImageViewCompletionBlock)completion;
{
    [self updateWithFlipAnimationDuration:JDFlipImageViewDefaultFlipDuration
                                direction:JDFlipImageViewFlipDirectionDown
                                  updates:updates completion:completion];
}

- (void)updateWithFlipAnimationDuration:(CGFloat)duration
                                updates:(JDFlipImageViewViewUpdateBlock)updates
                             completion:(JDFlipImageViewCompletionBlock)completion;
{
    [self updateWithFlipAnimationDuration:duration
                                direction:JDFlipImageViewFlipDirectionDown
                                  updates:updates completion:completion];
}

- (void)updateWithFlipAnimationDuration:(CGFloat)duration
                              direction:(JDFlipImageViewFlipDirection)direction
                                updates:(JDFlipImageViewViewUpdateBlock)updates
                             completion:(JDFlipImageViewCompletionBlock)completion;
{
    // screenshots & updates
    UIImage *oldImage = [self imageSnapshotAfterScreenUpdates:NO];
    if (updates) updates();
    UIImage *newImage = [self imageSnapshotAfterScreenUpdates:YES];
    
    // create & add flipview
    [self addFlipViewWithAnimationFromImage:oldImage toImage:newImage
                                   duration:duration direction:direction
                                 completion:completion];
}

#pragma mark Reused Code

- (UIImage*)imageSnapshotAfterScreenUpdates:(BOOL)afterScreenUpdates;
{
    CGSize size = self.bounds.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000 // only when SDK is >= ios7
        if ([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
            [self drawViewHierarchyInRect:(CGRect){CGPointZero, size} afterScreenUpdates:afterScreenUpdates];
        } else {
            [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        }
    #else
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    #endif
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (JDFlipImageView*)addFlipViewWithAnimationFromImage:(UIImage*)fromImage
                                              toImage:(UIImage*)toImage
                                             duration:(NSTimeInterval)duration
                                            direction:(JDFlipImageViewFlipDirection)direction
                                           completion:(JDFlipImageViewCompletionBlock)completion;
{
    NSParameterAssert(fromImage);
    NSParameterAssert(toImage);
    if (!fromImage || !toImage) return nil;
    
    // create & add flipview
    JDFlipImageView *flipImageView = [[JDFlipImageView alloc] initWithImage:fromImage];
    flipImageView.frame = self.frame;
    flipImageView.flipDirection = direction;
    [self.superview insertSubview:flipImageView aboveSubview:self];
    
    // hide actual view while animating (for transculent views)
    self.hidden = YES;
    
    // animate
    __weak typeof(self) blockSelf = self;
    __weak typeof(flipImageView) blockFlipImageView = flipImageView;
    [flipImageView setImageAnimated:toImage duration:duration completion:^(BOOL finished) {
        [blockFlipImageView removeFromSuperview];
        // show view again
        blockSelf.hidden = NO;
        
        // call completion
        if (completion) {
            completion(finished);
        }
    }];
    
    return flipImageView;
}

@end
