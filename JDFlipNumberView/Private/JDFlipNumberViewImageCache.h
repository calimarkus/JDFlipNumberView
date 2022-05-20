//
//  JDFlipNumberViewImageCache.h
//
//  Created by Markus Emrich on 05.20.22.
//  Copyright (c) 2022 markusemrich. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JDFlipNumberViewImageSet;
@class JDFlipNumberViewImageBundle;

@interface JDFlipNumberViewImageCache : NSObject

+ (JDFlipNumberViewImageCache *)sharedInstance;

- (JDFlipNumberViewImageSet *)imageSetForImageBundle:(JDFlipNumberViewImageBundle *)imageBundle;

@end
