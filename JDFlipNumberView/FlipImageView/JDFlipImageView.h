//
//  JDFlipImageView.h
//  FlipNumberViewExample
//
//  Created by Markus Emrich on 16.11.13.
//  Copyright (c) 2013 markusemrich. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JDFlipImageViewFlipDirection.h"

extern const NSTimeInterval JDFlipImageViewDefaultFlipDuration;

typedef void(^JDFlipImageViewCompletionBlock)(BOOL finished);

NS_ASSUME_NONNULL_BEGIN

@interface JDFlipImageView : UIView

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) JDFlipImageViewFlipDirection flipDirection;
@property (nonatomic, assign) NSInteger zDistance;

- (instancetype)initWithImage:(UIImage*)image;

- (void)setImageAnimated:(UIImage*)image;

- (void)setImageAnimated:(UIImage*)image
              completion:(JDFlipImageViewCompletionBlock _Nullable)completion;

- (void)setImageAnimated:(UIImage*)image
                duration:(CGFloat)duration
              completion:(JDFlipImageViewCompletionBlock _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
