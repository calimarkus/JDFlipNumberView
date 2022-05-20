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
    if (bundleName) {
        NSArray *images = [self topImagesForBundleNamed:bundleName];
        if (images.count > 0) {
            return [images[0] size];
        }
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
	
    // append .bundle to name
    NSString *filename = bundleName;
    if (![filename hasSuffix:@".bundle"]) filename = [NSString stringWithFormat: @"%@.bundle", filename];
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
    NSAssert(bundlePath != nil, @"Bundle named '%@' not found!", filename);
    if (!bundlePath) return;
    
	// create bottom and top images
    for (NSInteger digit=0; digit<10; digit++)
    {
        // create path & image
        NSString *imageName = [NSString stringWithFormat: @"%ld.png", (long)digit];
        NSString *bundleImageName = [NSString stringWithFormat: @"%@/%@", filename, imageName];
        NSString *path = [[NSBundle mainBundle] pathForResource:bundleImageName ofType:nil];
        UIImage *sourceImage = [[UIImage alloc] initWithContentsOfFile:path];
        NSAssert(sourceImage != nil, @"Did not find image '%@' in bundle named '%@'", imageName, filename);
        
        // generate & save images
        NSArray *images = [self generateImagesFromImage:sourceImage];
        [topImages addObject:images[0]];
        [bottomImages addObject:images[1]];
	}
	
    // save images
	self.topImages[bundleName]    = [NSArray arrayWithArray:topImages];
	self.bottomImages[bundleName] = [NSArray arrayWithArray:bottomImages];
}

- (NSArray*)generateImagesFromImage:(UIImage*)image;
{
    NSMutableArray *images = [NSMutableArray array];
    
    for (int i=0; i<2; i++) {
        CGSize size = CGSizeMake(image.size.width, image.size.height/2);
        CGFloat yPoint = (i==0) ? 0 : -size.height;
        
        // draw half of the image in a new image
        UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
        [image drawAtPoint:CGPointMake(0,yPoint)];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        // save image
        [images addObject:image];
    }
    
    return images;
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
