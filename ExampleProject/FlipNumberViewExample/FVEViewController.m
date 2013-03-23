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
        self.tableView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.rowHeight = 52.0;
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 60;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    view.backgroundColor = [UIColor clearColor];
    
    // add label
    UILabel* label = [[UILabel alloc] init];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    label.shadowOffset = CGSizeMake(0,-1);
    label.shadowColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    label.font = [UIFont boldCustomFontOfSize: 16];
    [view addSubview: label];
    
    // set text
    NSString* text = @"Basic usage";
    if (section==1) text = @"Targeted animation";
    if (section==2) text = @"Date Countdown";
    label.text = [text uppercaseString];
    
    // position label
    [label sizeToFit];
    label.center = CGPointMake(CGRectGetMidX(label.frame)+20, view.center.y);
    
    // add line
    CGRect frame = label.frame;
    frame.size.height = 3;
    frame.origin.y = label.frame.origin.y + label.frame.size.height;
    UIView *lineView = [[UIView alloc] initWithFrame:frame];
    lineView.backgroundColor = label.textColor;
    [view addSubview:lineView];
    
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
    } else {
        cell.textLabel.text = @"Silvester Countdown";
        cell.detailTextLabel.text = @"A JDDateCountdownFlipView instance.";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FVEDetailViewController* viewController = [[FVEDetailViewController alloc] initWithIndexPath:indexPath];
    viewController.title = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    [self.navigationController pushViewController: viewController animated: YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
