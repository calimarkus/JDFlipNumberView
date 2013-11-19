//
//  JDFlipImageView.h
//  FlipNumberViewExample
//
//  Created by Markus Emrich on 16.11.13.
//  Copyright (c) 2013 markusemrich. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const NSTimeInterval JDFlipImageViewDefaultFlipDuration;

typedef void(^JDFlipImageViewCompletionBlock)(BOOL finished);

typedef NS_ENUM(NSInteger, JDFlipImageViewFlipDirection) {
    JDFlipImageViewFlipDirectionDown,
    JDFlipImageViewFlipDirectionUp
};

@interface JDFlipImageView : UIView

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) JDFlipImageViewFlipDirection flipDirection;
@property (nonatomic, assign) NSUInteger zDistance;

- (id)initWithImage:(UIImage*)image;

- (void)setImageAnimated:(UIImage*)image;

- (void)setImageAnimated:(UIImage*)image
              completion:(JDFlipImageViewCompletionBlock)completion;

- (void)setImageAnimated:(UIImage*)image
                duration:(CGFloat)duration
              completion:(JDFlipImageViewCompletionBlock)completion;

@end
