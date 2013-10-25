//
//  UIFont+FlipNumberViewExample.m
//  FlipNumberViewExample
//
//  Created by Markus Emrich on 16.12.12.
//  Copyright (c) 2012 markusemrich. All rights reserved.
//

#import "UIFont+FlipNumberViewExample.h"

@implementation UIFont (FlipNumberViewExample)

+ (UIFont*)customFontOfSize:(CGFloat)size;
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        UIFont *font = [UIFont fontWithName:@"AvenirNextCondensed-Bold" size:size];
        if (![font.fontName isEqualToString:@"AvenirNextCondensed-Bold"]) {
            font = [UIFont boldSystemFontOfSize:size];
        }
        return font;
    } else {
        return [UIFont fontWithName:@"HelveticaNeue-Light" size:size];
    }
}

@end
