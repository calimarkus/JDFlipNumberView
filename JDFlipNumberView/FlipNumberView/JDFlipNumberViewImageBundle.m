//
//  JDFlipNumberViewImageTuple.m
//
//  Created by Markus Emrich on 05.20.22.
//  Copyright (c) 2022 markusemrich. All rights reserved.
//

#import "JDFlipNumberViewImageBundle.h"

static NSString *const JDFlipNumberViewDefaultBundle = @"JDFlipNumberView";

@implementation JDFlipNumberViewImageBundle {
    NSBundle *_bundle;
    NSString *_imageBundleName;
}

- (instancetype)initWithImageBundleName:(NSString *)imageBundleName
                               inBundle:(NSBundle *)bundle {
    self = [super init];
    if (self) {
        _bundle = bundle;
        _imageBundleName = ([imageBundleName hasSuffix:@".bundle"]
                            ? [imageBundleName copy]
                            : [NSString stringWithFormat: @"%@.bundle", imageBundleName]);
    }
    return self;
}

+ (instancetype)imageBundleNamed:(NSString *)name inBundle:(NSBundle *)bundle {
    return [[JDFlipNumberViewImageBundle alloc] initWithImageBundleName:name inBundle:bundle];
}

+ (instancetype)imageBundleNamed:(NSString *)imageBundleName {
    return [JDFlipNumberViewImageBundle imageBundleNamed:imageBundleName inBundle:[NSBundle mainBundle]];
}

+ (instancetype)defaultImageBundle {
    return [self imageBundleNamed:JDFlipNumberViewDefaultBundle
                         inBundle:[NSBundle bundleForClass:[self class]]];
}

- (NSString *)imageBundlePath {
    return [_bundle pathForResource:_imageBundleName ofType:nil];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ - ImageBundleName: '%@' in NSBundle: %@", [super description], _imageBundleName, _bundle.bundleIdentifier ?: _bundle.bundlePath];
}

@end
