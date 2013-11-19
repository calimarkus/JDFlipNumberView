//
//  FVEDetailViewController.m
//  FlipNumberViewExample
//
//  Created by Markus Emrich on 07.08.12.
//  Copyright (c) 2012 markusemrich. All rights reserved.
//

#import "JDFlipNumberView.h"
#import "JDFlipClockView.h"
#import "JDFlipImageView.h"
#import "JDDateCountdownFlipView.h"
#import "UIView+JDFlipImageView.h"
#import "UIFont+FlipNumberViewExample.h"

#import "FVEDetailViewController.h"

@interface FVEDetailViewController () <JDFlipNumberViewDelegate>
@property (nonatomic) UIView *flipView;
@property (nonatomic) NSArray *webviews;
@property (nonatomic) NSIndexPath *indexPath;
@property (nonatomic) UILabel *infoLabel;
@property (nonatomic) NSString *imageBundleName;
@property (nonatomic) UISlider *distanceSlider;
@property (nonatomic) NSInteger imageIndex;
@end

@implementation FVEDetailViewController

- (id)initWithIndexPath:(NSIndexPath*)indexPath
{
    self = [super init];
    if (self) {
        _indexPath = indexPath;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    } else {
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }

    // add info label
    CGRect frame = CGRectInset(self.view.bounds, 10, 10);
    frame.size.height = 20;
    frame.origin.y = self.view.frame.size.height - frame.size.height - 10;
    self.infoLabel = [[UILabel alloc] initWithFrame: frame];
    self.infoLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    self.infoLabel.font = [UIFont customFontOfSize:15];
    self.infoLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    self.infoLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.25];
    self.infoLabel.shadowOffset = CGSizeMake(0, 1);
    self.infoLabel.backgroundColor = [UIColor clearColor];
    self.infoLabel.textAlignment = UITextAlignmentCenter;
    self.infoLabel.text = @"Tap anywhere to change the value!";
    [self.view addSubview: self.infoLabel];
    
    // setup flip number view style
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        self.imageBundleName = self.useAlternativeImages ? nil : @"JDFlipNumberViewIOS6";
    } else {
        self.imageBundleName = self.useAlternativeImages ? @"JDFlipNumberViewIOS6" : nil;
    }
    
    // show flipNumberView
    BOOL addGestureRecognizer = YES;
    NSInteger row = self.indexPath.row;
    if (row == 0) {
        [self showSingleDigit];
    } else if (row == 1) {
        [self showMultipleDigits];
    }  else if (row == 2) {
        [self showTargetedAnimation];
    }  else if (row == 3) {
        [self showTime];
        addGestureRecognizer = NO;
        self.infoLabel.text = @"The current time.";
    }  else if (row == 4) {
        [self showDateCountdown];
        addGestureRecognizer = NO;
        self.infoLabel.text = @"Counting the days…";
    }  else if (row == 5) {
        [self showFlipImage];
    }  else if (row == 6) {
        [self showWebView];
        self.infoLabel.text = @"Click to flip this webview!";
    }
    
    // add gesture recognizer
    if (addGestureRecognizer) {
        [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                         initWithTarget:self action:@selector(viewTapped:)]];
    }
}

- (void)showSingleDigit;
{
    JDFlipNumberView *flipView = [[JDFlipNumberView alloc] initWithDigitCount:1 imageBundleName:self.imageBundleName];
    flipView.value = arc4random() % 10;
    flipView.delegate = self;
    flipView.reverseFlippingDisabled = [self isReverseFlippingDisabled];
    [self.view addSubview: flipView];
    self.flipView = flipView;
}

- (void)showMultipleDigits;
{
    JDFlipNumberView *flipView = [[JDFlipNumberView alloc] initWithDigitCount:3 imageBundleName:self.imageBundleName];
    flipView.value = 32;
    flipView.maximumValue = 128;
    flipView.reverseFlippingDisabled = [self isReverseFlippingDisabled];
    [self.view addSubview: flipView];
    self.flipView = flipView;
    
    [flipView animateDownWithTimeInterval:0.3];
}

- (void)showTargetedAnimation;
{
    JDFlipNumberView *flipView  = [[JDFlipNumberView alloc] initWithDigitCount:5 imageBundleName:self.imageBundleName];
    flipView.value = 2300;
    flipView.delegate = self;
    flipView.reverseFlippingDisabled = [self isReverseFlippingDisabled];
    [self.view addSubview: flipView];
    self.flipView = flipView;
    
    [self animateToTargetValue:9250];
}

- (void)showTime;
{
    JDFlipClockView *flipView  = [[JDFlipClockView alloc] initWithImageBundleName:self.imageBundleName];
    flipView.showsSeconds = YES;
    [self.view addSubview: flipView];
    self.flipView = flipView;
}

- (void)showDateCountdown;
{
    // setup flipview
    JDDateCountdownFlipView *flipView = [[JDDateCountdownFlipView alloc] initWithDayDigitCount:3 imageBundleName:self.imageBundleName];
    [self.view addSubview: flipView];
    
    // countdown to silvester
    NSDateComponents *currentComps = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:[NSDate date]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"dd.MM.yy HH:mm"];
    flipView.targetDate = [dateFormatter dateFromString:[NSString stringWithFormat: @"01.01.%d 00:00", currentComps.year+1]];
    
    // add info labels
    NSInteger posx = 20;
    for (NSInteger i=0; i<4; i++) {
        CGFloat yPosition = 20;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            yPosition = 74.0;
        }
        CGRect frame = CGRectMake(posx, yPosition, 200, 200);
        UILabel *label = [[UILabel alloc] initWithFrame: frame];
        label.font = [UIFont customFontOfSize:12];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor darkGrayColor];
        label.text = (i==0) ? @"days" : (i==1) ? @"hours" : (i==2) ? @"minutes" : @"seconds";
        [label sizeToFit];
        label.frame = CGRectInset(label.frame, -4, -4);
        label.textAlignment = UITextAlignmentCenter;
        [self.view addSubview: label];
        
        posx += label.frame.size.width + 10;
    }
    
    self.flipView = flipView;
}

- (void)showFlipImage;
{
    self.distanceSlider = [[UISlider alloc] init];
    self.distanceSlider.minimumValue = 100;
    self.distanceSlider.maximumValue = 1500;
    [self.distanceSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.distanceSlider];
    
    JDFlipImageView *flipImageView  = [[JDFlipImageView alloc] initWithImage:[UIImage imageNamed:@"example01.jpg"]];
    [self.view addSubview: flipImageView];
    self.flipView = flipImageView;
}

- (void)showWebView;
{
    UIWebView *webview1 = [[UIWebView alloc] initWithFrame:CGRectInset(self.view.bounds, 20.0, 80.0)];
    webview1.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    webview1.backgroundColor = [UIColor magentaColor];
    webview1.userInteractionEnabled = NO;
    [webview1 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.duckduckgo.com/"]]];
    [self.view addSubview:webview1];
    
    UIWebView *webview2 = [[UIWebView alloc] initWithFrame:CGRectInset(self.view.bounds, 20.0, 80.0)];
    webview2.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    webview2.backgroundColor = [UIColor cyanColor];
    webview2.userInteractionEnabled = NO;
    [webview2 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.google.com/"]]];
    
    self.webviews = @[webview1, webview2];
}

#pragma mark helper

- (BOOL)isReverseFlippingDisabled;
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"reverseFlippingDisabled"];
}

#pragma mark interaction

- (void)sliderValueChanged:(UISlider*)slider;
{
    [(JDFlipNumberView*)self.flipView setZDistance:slider.value];
    self.infoLabel.text = [NSString stringWithFormat: @"zDistance: %.0f", slider.value];
}

- (void)viewTapped:(UITapGestureRecognizer*)recognizer
{
    if ([self.flipView isKindOfClass:[JDFlipImageView class]])
    {
        JDFlipImageView *flipImageView = (JDFlipImageView*)self.flipView;
        
        self.imageIndex = (self.imageIndex+1)%3;
        [flipImageView setImageAnimated:[UIImage imageNamed:[NSString stringWithFormat: @"example%02d.jpg", self.imageIndex+1]]];
    }
    else if (self.webviews != nil) {
        if ([self.webviews[0] superview] != nil) {
            [self.webviews[0] flipToView:self.webviews[1]];
        } else {
            [self.webviews[1] flipToView:self.webviews[0]];
        }
    }
    else if (self.flipView != nil)
    {
        JDFlipNumberView *flipView = (JDFlipNumberView*)self.flipView;
        
        // set delegate after first touch
        if (self.indexPath.row == 1) {
            flipView.delegate = self;
        }

        NSInteger randomNumber = arc4random()%(int)floor(flipView.maximumValue/3.0) - floor(flipView.maximumValue/6.0);
        if (randomNumber == 0) randomNumber = 1;
        NSInteger newValue = ABS(flipView.value+randomNumber);
        
        if (self.indexPath.row < 2) {
            [flipView setValue:newValue animated:YES];
        } else {
            [self animateToTargetValue:newValue];
        }
    }
}

- (void)animateToTargetValue:(NSInteger)targetValue;
{
    JDFlipNumberView *flipView = (JDFlipNumberView*)self.flipView;
    
    NSDate *startDate = [NSDate date];
    [flipView animateToValue:targetValue duration:2.50 completion:^(BOOL finished) {
        if (finished) {
            NSLog(@"Animation needed: %.2f seconds", [[NSDate date] timeIntervalSinceDate:startDate]);
        } else {
            NSLog(@"Animation canceled after: %.2f seconds", [[NSDate date] timeIntervalSinceDate:startDate]);
        }
    }];
}

#pragma mark layout

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (!self.flipView) {
        return;
    }
    
    CGFloat multiplier = 0.9;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        multiplier = 1.0;
    }
    
    CGRect frame = self.view.bounds;
    if (self.distanceSlider) {
        frame.size.height -= 160;
        self.distanceSlider.frame = CGRectMake(10, frame.size.height+80,
                                               frame.size.width-20, 44);
    }

    self.flipView.frame = CGRectInset(frame, 20, 20);
    [self.flipView sizeToFit];
    self.flipView.center = CGPointMake(floor(self.view.frame.size.width/2.0),
                                       floor((self.view.frame.size.height/2.0)*multiplier));
    
    // update zDistance
    if (self.distanceSlider) {
        self.distanceSlider.value = [(JDFlipNumberView*)self.flipView zDistance];
        self.infoLabel.text = @"Tap to flip to next image!";
    }
}

#pragma mark rotation

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight | UIInterfaceOrientationPortrait;
}

#pragma mark delegate

- (void)flipNumberView:(JDFlipNumberView*)flipNumberView willChangeToValue:(NSUInteger)newValue;
{
    self.infoLabel.text = [NSString stringWithFormat: @"Will animate to %d", newValue];
}

- (void)flipNumberView:(JDFlipNumberView*)flipNumberView didChangeValueAnimated:(BOOL)animated;
{
    self.infoLabel.text = [NSString stringWithFormat: @"Finished animation to %d.", flipNumberView.value];
}

@end
