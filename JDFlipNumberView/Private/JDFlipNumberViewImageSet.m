//
//  JDFlipNumberViewImageTuple.m
//
//  Created by Markus Emrich on 05.20.22.
//  Copyright (c) 2022 markusemrich. All rights reserved.
//

#import "JDFlipNumberViewImageSet.h"

#import "JDFlipNumberViewImageTuple.h"

@implementation JDFlipNumberViewImageSet : NSObject

- (instancetype)initWithImageTuples:(NSArray<JDFlipNumberViewImageTuple *> *)imageTuples {
    self = [super init];
    if (self) {
        NSMutableArray *topImages = [NSMutableArray array];
        NSMutableArray *bottomImages = [NSMutableArray array];
        for (JDFlipNumberViewImageTuple *tuple in imageTuples) {
            [topImages addObject:tuple.topImage];
            [bottomImages addObject:tuple.bottomImage];
        }
        _topImages = topImages;
        _bottomImages = bottomImages;
    }
    return self;
}

@end
