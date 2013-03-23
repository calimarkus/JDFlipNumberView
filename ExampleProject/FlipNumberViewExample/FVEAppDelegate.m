//
//  FVEAppDelegate.m
//  FlipNumberViewExample
//
//  Created by Markus Emrich on 07.08.12.
//  Copyright (c) 2012 markusemrich. All rights reserved.
//

#import "FVEAppDelegate.h"
#import "UIFont+FlipNumberViewExample.h"

#import "FVEViewController.h"

@implementation FVEAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    FVEViewController *viewController = [[FVEViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    
    [self setupAppearance];
    
    return YES;
}

- (void)setupAppearance;
{
    [[UINavigationBar appearance] setTintColor: [UIColor colorWithHue:0.2 saturation:0.8 brightness:0.6 alpha:1]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{ UITextAttributeFont:[UIFont boldCustomFontOfSize:16] }];
    [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:2 forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:-1 forBarMetrics:UIBarMetricsLandscapePhone];
}

@end
