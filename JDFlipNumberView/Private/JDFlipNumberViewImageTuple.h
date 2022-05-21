//
//  JDFlipNumberViewImageTuple.h
//
//  Created by Markus Emrich on 05.20.22.
//  Copyright (c) 2022 markusemrich. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JDFlipNumberViewImageTuple : NSObject

@property (nonatomic, readonly) UIImage *topImage;
@property (nonatomic, readonly) UIImage *bottomImage;

- (instancetype)initWithTopImage:(UIImage *)topImage
                     bottomImage:(UIImage *)bottomImage;

@end

NS_ASSUME_NONNULL_END
