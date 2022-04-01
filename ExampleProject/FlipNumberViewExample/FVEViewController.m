//
//  FVEViewController.m
//  FlipNumberViewExample
//
//  Created by Markus Emrich on 07.08.12.
//  Copyright (c) 2012 markusemrich. All rights reserved.
//

#import "FVEDetailViewController.h"

#import "FVEViewController.h"

@interface FVEViewController ()
@property (nonatomic, assign) BOOL useAlternativeImages;
@end

@implementation FVEViewController

- (id)init
{
    self = [super initWithStyle: UITableViewStyleGrouped];
    if (self) {
        self.title = @"JDFlipNumberView Examples";
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
        
        [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"reverseFlippingDisabled":@YES}];
    }
    return self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 40.0;
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
    label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    label.textColor = [UIColor colorWithWhite:0.66 alpha:1.0];
    [view addSubview: label];
    
    // set text
    NSString* text = @"Number Examples";
    if (section==1) text = @"Other Examples";
    if (section==2) text = @"Settings";
    label.text = [text uppercaseString];
    
    // position label
    [label sizeToFit];
    label.center = CGPointMake(CGRectGetMidX(label.frame)+20, view.center.y);
    
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==1) return 3;
    if (section==2) return 2;
    
    return 5;
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
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"Animate to a target value";
            cell.detailTextLabel.text = @"A FlipView using animateToValue:duration:";
        } else if (indexPath.row == 3) {
            cell.textLabel.text = @"Flip Clock";
            cell.detailTextLabel.text = @"A JDFlipClockView instance.";
        } else if (indexPath.row == 4) {
            cell.textLabel.text = @"New Years Countdown (Date)";
            cell.detailTextLabel.text = @"A JDDateCountdownFlipView instance.";
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Flip Image View";
            cell.detailTextLabel.text = @"A JDFlipImageView instance.";
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"Update a view with a Flip animation";
            cell.detailTextLabel.text = @"using flipToView:";
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"Flip view transition!";
            cell.detailTextLabel.text = @"using updateWithFlipAnimationUpdates:";
        }
    } else {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Reverse Flipping Disabled";
            cell.detailTextLabel.text = @"Stop flipping bottom-up";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *aSwitch = [[UISwitch alloc] init];
            [aSwitch addTarget:self action:@selector(switchTouched:) forControlEvents:UIControlEventValueChanged];
            aSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"reverseFlippingDisabled"];
            cell.accessoryView = aSwitch;
        } else {
            cell.textLabel.text = @"Use alternative Images";
            cell.detailTextLabel.text = @"Switch between iOS6 & iOS7 style";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *aSwitch = [[UISwitch alloc] init];
            [aSwitch addTarget:self action:@selector(styleSwitchTouched:) forControlEvents:UIControlEventValueChanged];
            aSwitch.on = self.useAlternativeImages;
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
            [self switchTouched:aSwitch];
        } else {
            [self styleSwitchTouched:aSwitch];
        }
        return;
    }
    
    FVEDetailViewController* viewController = [[FVEDetailViewController alloc] initWithIndexPath:indexPath];
    viewController.useAlternativeImages = self.useAlternativeImages;
    viewController.title = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    [self.navigationController pushViewController: viewController animated: YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)switchTouched:(UISwitch*)sender;
{
    [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:@"reverseFlippingDisabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)styleSwitchTouched:(UISwitch*)sender;
{
    self.useAlternativeImages = sender.on;
}

@end
