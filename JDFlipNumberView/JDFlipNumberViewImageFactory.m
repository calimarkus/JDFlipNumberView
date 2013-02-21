//
//  JDFlipNumberViewImageFactory.m
//  FlipNumberViewExample
//
//  Created by Markus Emrich on 05.12.12.
//  Copyright (c) 2012 markusemrich. All rights reserved.
//

#import "JDFlipNumberViewImageFactory.h"

static JDFlipNumberViewImageFactory *sharedInstance;

@interface JDFlipNumberViewImageFactory ()
@property (nonatomic, strong) NSArray *topImages;
@property (nonatomic, strong) NSArray *bottomImages;
@property (nonatomic, strong) NSString *imageBundle;
- (void)setup;
@end

@implementation JDFlipNumberViewImageFactory

+ (JDFlipNumberViewImageFactory*)sharedInstance;
{
    if (sharedInstance != nil) {
        return sharedInstance;
    }
    
    return [[self alloc] init];
}

- (id)init
{
    @synchronized(self)
    {
        if (sharedInstance != nil) {
            return sharedInstance;
        }
        
        self = [super init];
        if (self) {
            sharedInstance = self;
            self.imageBundle = @"JDFlipNumberView";
            [self setup];
        }
        return self;
    }
}

- (void)setup;
{
    // create default images
    [self generateImagesFromBundleNamed:self.imageBundle];
    
    // register for memory warnings
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveMemoryWarning:)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];
}

+ (id)allocWithZone:(NSZone *)zone;
{
    if (sharedInstance != nil) {
        return sharedInstance;
    }
    return [super allocWithZone:zone];
}

#pragma mark -
#pragma mark getter

- (NSArray *)topImages;
{
    @synchronized(self)
    {
        if (_topImages.count == 0) {
            [self generateImagesFromBundleNamed:self.imageBundle];
        }
        
        return _topImages;
    }
}

- (NSArray *)bottomImages;
{
    @synchronized(self)
    {
        if (_bottomImages.count == 0) {
            [self generateImagesFromBundleNamed:self.imageBundle];
        }
        
        return _bottomImages;
    }
}

- (CGSize)imageSize
{
    return ((UIImage*)self.topImages[0]).size;
}

#pragma mark -
#pragma mark image generation
- (void)generateImagesFromBundleNamed:(NSString*)bundleName;
{
    self.imageBundle = bundleName;
    // create image array
	NSMutableArray* topImages = [NSMutableArray arrayWithCapacity:10];
	NSMutableArray* bottomImages = [NSMutableArray arrayWithCapacity:10];
	
	// create bottom and top images
    for (NSInteger j=0; j<10; j++) {
        for (int i=0; i<2; i++) {
            NSString *imageName = [NSString stringWithFormat: @"%d.png", j];
            NSString *bundleImageName = [NSString stringWithFormat: @"%@.bundle/%@", bundleName, imageName];
            NSString *path = [[NSBundle mainBundle] pathForResource:bundleImageName ofType:nil];
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
	self.topImages    = [NSArray arrayWithArray:topImages];
	self.bottomImages = [NSArray arrayWithArray:bottomImages];
}

#pragma mark -
#pragma mark memory

// clear memory
- (void)didReceiveMemoryWarning:(NSNotification*)notification;
{
    self.topImages = @[];
    self.bottomImages = @[];
}

@end
