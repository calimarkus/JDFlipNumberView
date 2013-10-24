//
//  FVEViewController.m
//  FlipNumberViewExample
//
//  Created by Markus Emrich on 07.08.12.
//  Copyright (c) 2012 markusemrich. All rights reserved.
//

#import "FVEDetailViewController.h"
#import "UIFont+FlipNumberViewExample.h"

#import "FVEViewController.h"

@interface FVEViewController ()

@end

@implementation FVEViewController

- (id)init
{
    self = [super initWithStyle: UITableViewStyleGrouped];
    if (self) {
        self.title = @"JDFlipNumberView Examples";
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Examples" style:UIBarButtonItemStyleBordered target:nil action:nil];
        self.tableView.backgroundView = nil;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.rowHeight = 52.0;

        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
            self.tableView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
        }
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        return 60.0;
    } else {
        return 40.0;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat height = [self tableView:tableView heightForHeaderInSection:section];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, height)];
    view.backgroundColor = [UIColor clearColor];
    
    // add label
    UILabel* label = [[UILabel alloc] init];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldCustomFontOfSize: 16];
    [view addSubview: label];

    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        label.textColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        label.shadowOffset = CGSizeMake(0,-1);
        label.shadowColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    } else {
        label.textColor = [UIColor colorWithWhite:0.66 alpha:1.0];
    }
    
    // set text
    NSString* text = @"Basic usage";
    if (section==1) text = @"Targeted animation";
    if (section==2) text = @"Date Countdown";
    if (section==3) text = @"Settings";
    label.text = [text uppercaseString];
    
    // position label
    [label sizeToFit];
    label.center = CGPointMake(CGRectGetMidX(label.frame)+20, view.center.y);
    
    // add line
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        CGRect frame = label.frame;
        frame.size.height = 3;
        frame.origin.y = label.frame.origin.y + label.frame.size.height;
        UIView *lineView = [[UIView alloc] initWithFrame:frame];
        lineView.backgroundColor = label.textColor;
        [view addSubview:lineView];
    }
    
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (section==0) ? 2 : 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"identifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont boldSystemFontOfSize: 15];
        cell.detailTextLabel.font = [UIFont systemFontOfSize: 13];
    }
    
    cell.accessoryView = nil;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Single Digit";
            cell.detailTextLabel.text = @"A FlipView with one digit.";
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"Multiple Digits";
            cell.detailTextLabel.text = @"A FlipView with multiple digits.";
        }
    } else if (indexPath.section == 1) {
        cell.textLabel.text = @"Animate to a target value";
        cell.detailTextLabel.text = @"A FlipView using animateToValue:duration:";
    } else if (indexPath.section == 2) {
        cell.textLabel.text = @"Silvester Countdown";
        cell.detailTextLabel.text = @"A JDDateCountdownFlipView instance.";
    } else {
        cell.textLabel.text = @"Reverse Flipping Disabled";
        cell.detailTextLabel.text = @"Stop flipping bottom-up";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UISwitch *aSwitch = [[UISwitch alloc] init];
        [aSwitch addTarget:self action:@selector(switchTouched:) forControlEvents:UIControlEventValueChanged];
        aSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"reverseFlippingDisabled"];
        cell.accessoryView = aSwitch;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        UISwitch *aSwitch = (UISwitch *)[[tableView cellForRowAtIndexPath:indexPath] accessoryView];
        [aSwitch setOn:!aSwitch.on animated:YES];
        [self switchTouched:aSwitch];
        return;
    }
    
    FVEDetailViewController* viewController = [[FVEDetailViewController alloc] initWithIndexPath:indexPath];
    viewController.title = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    [self.navigationController pushViewController: viewController animated: YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)switchTouched:(UISwitch*)sender;
{
    [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:@"reverseFlippingDisabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
