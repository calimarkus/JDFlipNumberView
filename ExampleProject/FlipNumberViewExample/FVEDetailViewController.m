//
//  FVEDetailViewController.m
//  FlipNumberViewExample
//
//  Created by Markus Emrich on 07.08.12.
//  Copyright (c) 2012 markusemrich. All rights reserved.
//

#import "JDFlipNumberView.h"
#import "JDGroupedFlipNumberView.h"
#import "JDDateCountdownFlipView.h"

#import "FVEDetailViewController.h"

@interface FVEDetailViewController ()
@property (nonatomic) NSIndexPath *indexPath;
- (void)showSingleDigit;
- (void)showMultipleDigits;
- (void)showDateCountdown;
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
    
    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    
    if (self.indexPath.section == 1 || self.indexPath.row == 1) {
        [self showMultipleDigits];
    } else if (self.indexPath.row == 0) {
        [self showSingleDigit];
    } else {
        [self showDateCountdown];
    }
}

- (void)showSingleDigit;
{
    JDFlipNumberView *flipView = [[JDFlipNumberView alloc] initWithIntValue: 9];
    [flipView animateDownWithTimeInterval: 1.0];
    [self.view addSubview: flipView];
}

- (void)showMultipleDigits;
{
    JDGroupedFlipNumberView *flipView = [[JDGroupedFlipNumberView alloc] initWithFlipNumberViewCount: 5];
    flipView.intValue = 11115;
    flipView.tag = 99;
    [self.view addSubview: flipView];
    
    if (self.indexPath.section == 0) {
        [flipView animateDownWithTimeInterval: 0.4];
    } else {
        [flipView animateToValue: 9250 withDuration: 3.0];
        
        // add random number button
        UIButton *button = [UIButton buttonWithType: UIButtonTypeRoundedRect];
        button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        button.frame = CGRectMake(20, 10, self.view.frame.size.width-40, 38);
        [button setTitle:@"Jump to random number" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview: button];
    }
}

- (void)showDateCountdown;
{
    // countdown to silvester
    NSDateComponents *currentComps = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:[NSDate date]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"dd.MM.yy HH:mm"];
    NSDate *date = [dateFormatter dateFromString: [NSString stringWithFormat: @"01.01.%d 00:00", currentComps.year+1]];
    
    JDDateCountdownFlipView *flipView = [[JDDateCountdownFlipView alloc] initWithTargetDate: date];
    [self.view addSubview: flipView];
    
    // add info labels
    NSInteger posx = 20;
    for (NSInteger i=0; i<4; i++) {
        CGRect frame = CGRectMake(posx, 20, 200, 200);
        UILabel *label = [[UILabel alloc] initWithFrame: frame];
        label.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:12];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor darkGrayColor];
        label.text = (i==0) ? @"days" : (i==1) ? @"hours" : (i==2) ? @"minutes" : @"seconds";
        [label sizeToFit];
        label.frame = CGRectInset(label.frame, -4, -4);
        label.textAlignment = UITextAlignmentCenter;
        [self.view addSubview: label];
        
        posx += label.frame.size.width + 10;
    }
}

- (void)buttonTouched:(id)sender
{
    JDGroupedFlipNumberView *flipView = (JDGroupedFlipNumberView*)[self.view viewWithTag: 99];

    @try {
        NSInteger randomNumber = ABS(flipView.intValue + arc4random()%10000 - 5000);
        NSLog(@"%d", randomNumber);
        [flipView animateToValue:randomNumber withDuration:2.5];
    } @catch (NSException *exception) {}
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self layoutSubviews];
}

- (void)layoutSubviews
{
    UIView* view = [[self.view subviews] objectAtIndex: 0];
    
    view.frame = CGRectMake(0, 0, self.view.frame.size.width-40, self.view.frame.size.height-40);
    view.center = CGPointMake(self.view.frame.size.width /2,
                              (self.view.frame.size.height/2)*0.9);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self layoutSubviews];
}

@end
