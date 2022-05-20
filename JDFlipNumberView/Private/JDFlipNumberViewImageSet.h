//
//  JDFlipNumberViewImageTuple.h
//
//  Created by Markus Emrich on 05.20.22.
//  Copyright (c) 2022 markusemrich. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JDFlipNumberViewImageTuple;

@interface JDFlipNumberViewImageSet : NSObject

@property (nonatomic, readonly) NSArray<UIImage *> *topImages;
@property (nonatomic, readonly) NSArray<UIImage *> *bottomImages;

- (instancetype)initWithImageTuples:(NSArray<JDFlipNumberViewImageTuple *> *)imageTuples;

@end
