//
//  JDFlipNumberViewImageCache.m
//
//  Created by Markus Emrich on 05.20.22.
//  Copyright (c) 2022 markusemrich. All rights reserved.
//

#import "JDFlipNumberViewImageCache.h"

#import "JDFlipNumberViewImageBundle.h"
#import "JDFlipNumberViewImageFactory.h"
#import "JDFlipNumberViewImageTuple.h"

@implementation JDFlipNumberViewImageCache {
    NSMutableDictionary<NSString *, JDFlipNumberViewImageSet *> *_bundleKeyToImageSets;
}

+ (instancetype)sharedInstance
{
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] initSharedInstance];
    });
    return _sharedInstance;
}

- (instancetype)initSharedInstance
{
    self = [super init];
    if (self) {
        _bundleKeyToImageSets = [NSMutableDictionary dictionary];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveMemoryWarning:)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
    }
    return self;
}

- (JDFlipNumberViewImageSet *)imageSetForImageBundle:(JDFlipNumberViewImageBundle *)imageBundle {
    NSString *path = imageBundle.imageBundlePath;
    if (_bundleKeyToImageSets[path] != nil) {
        return _bundleKeyToImageSets[path];
    }

    JDFlipNumberViewImageSet *const set = [JDFlipNumberViewImageFactory generateImagesForImageBundle:imageBundle];
    _bundleKeyToImageSets[path] = set;
    return set;
}

- (void)didReceiveMemoryWarning:(NSNotification*)notification {
    // drop all saved images
    [_bundleKeyToImageSets removeAllObjects];
}

@end
