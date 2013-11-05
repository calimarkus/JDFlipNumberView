//
//  FVEDetailViewController.m
//  FlipNumberViewExample
//
//  Created by Markus Emrich on 07.08.12.
//  Copyright (c) 2012 markusemrich. All rights reserved.
//

#import "JDFlipNumberView.h"
#import "JDFlipNumberViewImageFactory.h"
#import "JDDateCountdownFlipView.h"
#import "UIFont+FlipNumberViewExample.h"

#import "FVEDetailViewController.h"

static CGFloat const FVEDetailControllerTargetedViewTag = 111;

@interface FVEDetailViewController () <JDFlipNumberViewDelegate>
@property (nonatomic) UIView *flipView;
@property (nonatomic) NSIndexPath *indexPath;
@property (nonatomic) UILabel *infoLabel;
@property (nonatomic) NSString *imageBundleName;
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
        [self showDateCountdown];
        addGestureRecognizer = NO;
    }
    
    // add gesture recognizer
    if (addGestureRecognizer) {
        self.infoLabel.text = @"Tap anywhere to change the value!";
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
    [flipView animateDownWithTimeInterval:0.3];
    [self.view addSubview: flipView];
    self.flipView = flipView;
}

- (void)showTargetedAnimation;
{
    JDFlipNumberView *flipView  = [[JDFlipNumberView alloc] initWithDigitCount:5 imageBundleName:self.imageBundleName];
    flipView.value = 2300;
    flipView.tag = FVEDetailControllerTargetedViewTag;
    flipView.reverseFlippingDisabled = [self isReverseFlippingDisabled];
    
    NSInteger targetValue = 9250;
    NSDate *startDate = [NSDate date];
    [flipView animateToValue:targetValue duration:2.50 completion:^(BOOL finished) {
        if (finished) {
            NSLog(@"Animation needed: %.2f seconds", [[NSDate date] timeIntervalSinceDate:startDate]);
        } else {
            NSLog(@"Animation canceled after: %.2f seconds", [[NSDate date] timeIntervalSinceDate:startDate]);
        }
        [self flipNumberView:flipView didChangeValueAnimated:finished];
    }];
    [self flipNumberView:flipView willChangeToValue:targetValue];
    
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

#pragma mark helper

- (BOOL)isReverseFlippingDisabled;
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"reverseFlippingDisabled"];
}

#pragma mark interaction

- (void)viewTapped:(UITapGestureRecognizer*)recognizer
{
    JDFlipNumberView *flipView = (JDFlipNumberView*)self.flipView;
    
    if (flipView.tag != FVEDetailControllerTargetedViewTag) {
        flipView.delegate = self;
    }

    NSInteger randomNumber = arc4random()%(int)floor(flipView.maximumValue/3.0) - floor(flipView.maximumValue/6.0);
    if (randomNumber == 0) randomNumber = 1;
    NSInteger newValue = ABS(flipView.value+randomNumber);
    
    if (self.indexPath.section == 0) {
        [flipView setValue:newValue animated:YES];
    } else {
        NSDate *startDate = [NSDate date];
        [flipView animateToValue:newValue duration:2.50 completion:^(BOOL finished) {
            if(finished) {
                NSLog(@"Animation needed: %.2f seconds", [[NSDate date] timeIntervalSinceDate:startDate]);
            } else {
                NSLog(@"Animation canceled after: %.2f seconds", [[NSDate date] timeIntervalSinceDate:startDate]);
            }
            [self flipNumberView:flipView didChangeValueAnimated:finished];
        }];
        [self flipNumberView:flipView willChangeToValue:newValue];
    }
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

    self.flipView.frame = CGRectInset(self.view.bounds, 20, 20);
    [self.flipView sizeToFit];
    self.flipView.center = CGPointMake(floor(self.view.frame.size.width/2.0),
                                       floor((self.view.frame.size.height/2.0)*multiplier));
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
