//
//  JDFlipImageView.h
//  FlipNumberViewExample
//
//  Created by Markus Emrich on 16.11.13.
//  Copyright (c) 2013 markusemrich. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JDFlipImageViewCompletionBlock)(BOOL finished);

@interface JDFlipImageView : UIView

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) BOOL animateBottomUp;

- (id)initWithImage:(UIImage*)image;

- (void)setImageAnimated:(UIImage*)image
                duration:(CGFloat)duration
              completion:(JDFlipImageViewCompletionBlock)completion;

@end
