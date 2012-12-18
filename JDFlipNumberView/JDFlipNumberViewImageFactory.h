//
//  JDFlipNumberViewImageFactory.h
//  FlipNumberViewExample
//
//  Created by Markus Emrich on 05.12.12.
//  Copyright (c) 2012 markusemrich. All rights reserved.
//

#import <Foundation/Foundation.h>

#define JD_IMG_FACTORY [JDFlipNumberViewImageFactory sharedInstance]

@interface JDFlipNumberViewImageFactory : NSObject

@property (nonatomic, strong, readonly) NSArray *topImages;
@property (nonatomic, strong, readonly) NSArray *bottomImages;

@property (nonatomic, readonly) CGSize imageSize;

+ (JDFlipNumberViewImageFactory*)sharedInstance;
- (void)generateImagesFromBundleNamed:(NSString*)bundleName;

@end
