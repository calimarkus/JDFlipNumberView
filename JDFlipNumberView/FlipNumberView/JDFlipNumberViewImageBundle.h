//
//  JDFlipNumberViewImageTuple.h
//
//  Created by Markus Emrich on 05.20.22.
//  Copyright (c) 2022 markusemrich. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JDFlipNumberViewImageBundle : NSObject

@property (nonatomic, readonly) NSString * __nullable imageBundlePath;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

+ (instancetype)imageBundleNamed:(NSString *)name inBundle:(NSBundle *)bundle;

/// defaults to [NSBundle mainBundle]
+ (instancetype)imageBundleNamed:(NSString *)imageBundleName;

+ (instancetype)defaultImageBundle;

@end

NS_ASSUME_NONNULL_END
