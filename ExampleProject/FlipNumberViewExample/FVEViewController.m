//
//  FVEViewController.m
//  FlipNumberViewExample
//
//  Created by Markus Emrich on 07.08.12.
//  Copyright (c) 2012 markusemrich. All rights reserved.
//

#import "FVEDetailViewController.h"

#import "FVEViewController.h"

@implementation FVEViewController

- (instancetype)init
{
    self = [super initWithStyle: UITableViewStyleInsetGrouped];
    if (self) {
        self.title = @"JDFlipNumberView Examples";
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.tableView.backgroundColor = [UIColor systemGray6Color];
    }
    return self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 40.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"FlipNumberView Examples";
        case 1:
            return @"Other FlipView Examples";
        case 2:
            return @"Settings";
        default:
            return nil;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 5;
        case 1:
            return 5;
        case 2:
            return 1;
        default:
            return 0;
    }
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
            cell.detailTextLabel.text = @"A FlipNumberView with one digit.";
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"Multiple Digits";
            cell.detailTextLabel.text = @"A FlipNumberView with multiple digits.";
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"Animate to a target value";
            cell.detailTextLabel.text = @"A FlipNumberView using animateToValue:duration:";
        } else if (indexPath.row == 3) {
            cell.textLabel.text = @"Alternative assets";
            cell.detailTextLabel.text = @"A FlipNumberView using different images.";
        } else if (indexPath.row == 4) {
            cell.textLabel.text = @"SwiftUI Example";
            cell.detailTextLabel.text = @"A FlipNumberView used through SwiftUI.";
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"JDFlipImageView";
            cell.detailTextLabel.text = @"Flipping images!";
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"UIView+JDFlipImageView #1";
            cell.detailTextLabel.text = @"using flipToView:";
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"UIView+JDFlipImageView #2";
            cell.detailTextLabel.text = @"using updateWithFlipAnimationUpdates:";
        } else if (indexPath.row == 3) {
            cell.textLabel.text = @"JDFlipClock";
            cell.detailTextLabel.text = @"Displaying the time animated.";
        } else if (indexPath.row == 4) {
            cell.textLabel.text = @"JDDateCountdownFlipView";
            cell.detailTextLabel.text = @"An animated New Years Countdown.";
        }
    } else {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Allow flipping bottom-up";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *aSwitch = [[UISwitch alloc] init];
            [aSwitch addTarget:self action:@selector(bottomUpSwitchTouched:) forControlEvents:UIControlEventValueChanged];
            aSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"reverseFlippingAllowed"];
            cell.accessoryView = aSwitch;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        UISwitch *aSwitch = (UISwitch *)[[tableView cellForRowAtIndexPath:indexPath] accessoryView];
        [aSwitch setOn:!aSwitch.on animated:YES];
        
        if (indexPath.row == 0) {
            [self bottomUpSwitchTouched:aSwitch];
        }
        return;
    }
    
    FVEDetailViewController* viewController = [[FVEDetailViewController alloc] initWithIndexPath:indexPath];
    viewController.title = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    [self.navigationController pushViewController: viewController animated: YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)bottomUpSwitchTouched:(UISwitch*)sender;
{
    [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:@"reverseFlippingAllowed"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
