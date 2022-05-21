//
//  JDFlipNumberViewImageFactory.h
//  FlipNumberViewExample
//
//  Created by Markus Emrich on 05.12.12.
//  Copyright (c) 2012 markusemrich. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JDFlipNumberViewImageBundle;
@class JDFlipNumberViewImageSet;
@class JDFlipNumberViewImageTuple;

NS_ASSUME_NONNULL_BEGIN

@interface JDFlipNumberViewImageFactory : NSObject

+ (JDFlipNumberViewImageSet *)generateImagesForImageBundle:(JDFlipNumberViewImageBundle *)imageBundle;

+ (JDFlipNumberViewImageTuple *)generateImagesFromImage:(UIImage*)image;

@end

NS_ASSUME_NONNULL_END
