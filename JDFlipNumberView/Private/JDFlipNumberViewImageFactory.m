//
//  JDFlipNumberViewImageFactory.m
//  FlipNumberViewExample
//
//  Created by Markus Emrich on 05.12.12.
//  Copyright (c) 2012 markusemrich. All rights reserved.
//

#import "JDFlipNumberViewImageFactory.h"

#import "JDFlipNumberViewImageBundle.h"
#import "JDFlipNumberViewImageTuple.h"
#import "JDFlipNumberViewImageSet.h"

@implementation JDFlipNumberViewImageFactory

+ (JDFlipNumberViewImageSet *)generateImagesForImageBundle:(JDFlipNumberViewImageBundle *)imageBundle {
    NSMutableArray<JDFlipNumberViewImageTuple *> *tuples = [NSMutableArray array];
	
    NSString *filename = imageBundle.imageBundlePath;
    NSAssert(filename != nil, @"Image bundle path not found: %@", imageBundle);
    if (!filename) return nil;
    
	// create bottom top images
    for (NSInteger digit = 0; digit < 10; digit ++) {
        // create path & image
        NSString *imageName = [NSString stringWithFormat: @"%ld.png", (long)digit];
        NSString *bundleImageName = [filename stringByAppendingPathComponent:imageName];
        UIImage *sourceImage = [[UIImage alloc] initWithContentsOfFile:bundleImageName];
        NSAssert(sourceImage != nil, @"Did not find image '%@' in bundle '%@'", imageName, filename);
        
        // generate & save images
        [tuples addObject:[self generateImagesFromImage:sourceImage]];
	}

    return [[JDFlipNumberViewImageSet alloc] initWithImageTuples:tuples];
}

+ (JDFlipNumberViewImageTuple *)generateImagesFromImage:(UIImage*)image {
    return [[JDFlipNumberViewImageTuple alloc] initWithTopImage:[self generateImageHalfFromImage:image isTop:YES]
                                                    bottomImage:[self generateImageHalfFromImage:image isTop:NO]];
}

+ (UIImage *)generateImageHalfFromImage:(UIImage *)image
                                  isTop:(BOOL)isTop {
    CGSize size = CGSizeMake(image.size.width, image.size.height/2);
    CGFloat yPoint = (isTop) ? 0 : -size.height;

    // draw half of the image in a new image
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [image drawAtPoint:CGPointMake(0,yPoint)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
