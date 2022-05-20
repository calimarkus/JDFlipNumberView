//
//  JDFlipNumberViewImageTuple.m
//
//  Created by Markus Emrich on 05.20.22.
//  Copyright (c) 2022 markusemrich. All rights reserved.
//

#import "JDFlipNumberViewImageTuple.h"

@implementation JDFlipNumberViewImageTuple

- (instancetype)initWithTopImage:(UIImage *)topImage
                     bottomImage:(UIImage *)bottomImage {
    self = [super init];
    if (self) {
        _topImage = topImage;
        _bottomImage = bottomImage;
    }
    return self;
}

@end
