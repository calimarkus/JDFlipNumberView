//
//  JDFlipNumberViewImageFactory.m
//  FlipNumberViewExample
//
//  Created by Markus Emrich on 05.12.12.
//  Copyright (c) 2012 markusemrich. All rights reserved.
//

#import "JDFlipNumberViewImageFactory.h"

@interface JDFlipNumberViewImageFactory ()
@property (nonatomic, strong) NSMutableDictionary *topImages;
@property (nonatomic, strong) NSMutableDictionary *bottomImages;
@end

@implementation JDFlipNumberViewImageFactory

+ (instancetype)sharedInstance;
{
    static JDFlipNumberViewImageFactory *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _topImages = [NSMutableDictionary dictionary];
        _bottomImages = [NSMutableDictionary dictionary];
        
        // register for memory warnings
        [[NSNotificationCenter defaultCenter]
         addObserver:self selector:@selector(didReceiveMemoryWarning:)
         name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

#pragma mark -
#pragma mark getter

- (NSArray *)topImagesForBundleNamed:(NSString *)bundleName;
{
    if ([_topImages[bundleName] count] == 0) {
        [self generateImagesFromBundleNamed:bundleName];
    }
    
    return _topImages[bundleName];
}

- (NSArray *)bottomImagesForBundleNamed:(NSString *)bundleName;
{
    if ([_bottomImages[bundleName] count] == 0) {
        [self generateImagesFromBundleNamed:bundleName];
    }
    
    return _bottomImages[bundleName];
}

- (CGSize)imageSizeForBundleNamed:(NSString *)bundleName;
{
    NSArray *images = self.topImages[bundleName];
    if (images.count > 0) {
        return [images[0] size];
    }
    return CGSizeZero;
}

#pragma mark -
#pragma mark image generation

- (void)generateImagesFromBundleNamed:(NSString*)bundleName;
{
    // create image array
	NSMutableArray* topImages = [NSMutableArray arrayWithCapacity:10];
	NSMutableArray* bottomImages = [NSMutableArray arrayWithCapacity:10];
	
	// create bottom and top images
    for (NSInteger j=0; j<10; j++) {
        for (int i=0; i<2; i++) {
            NSString *imageName = [NSString stringWithFormat: @"%d.png", j];
            NSString *bundleImageName = [NSString stringWithFormat: @"%@.bundle/%@", bundleName, imageName];
            NSString *path = [[NSBundle mainBundle] pathForResource:bundleImageName ofType:nil];
            
            NSAssert(path != nil, @"Bundle named '%@' not found!", bundleName);
            
			UIImage *sourceImage = [[UIImage alloc] initWithContentsOfFile:path];
			CGSize size		= CGSizeMake(sourceImage.size.width, sourceImage.size.height/2);
			CGFloat yPoint	= (i==0) ? 0 : -size.height;
			
            NSAssert(sourceImage != nil, @"Did not find image %@.png in bundle %@.bundle", imageName, bundleName);
            
            // draw half of image and create new image
			UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
			[sourceImage drawAtPoint:CGPointMake(0,yPoint)];
			UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
			UIGraphicsEndImageContext();
            
            // save image
            if (i==0) {
                [topImages addObject:image];
            } else {
                [bottomImages addObject:image];
            }
		}
	}
	
    // save images
	self.topImages[bundleName]    = [NSArray arrayWithArray:topImages];
	self.bottomImages[bundleName] = [NSArray arrayWithArray:bottomImages];
}

#pragma mark -
#pragma mark memory

- (void)didReceiveMemoryWarning:(NSNotification*)notification;
{
    // remove all saved images
    _topImages = [NSMutableDictionary dictionary];
    _bottomImages = [NSMutableDictionary dictionary];
}

@end
