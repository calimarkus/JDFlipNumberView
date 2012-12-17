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
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 40;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 320, 40)];
    view.backgroundColor = [UIColor clearColor];
    UILabel* label = [[UILabel alloc] initWithFrame: CGRectMake(20, 10, 290, 30)];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithWhite:0.65 alpha:1.0];
    label.shadowOffset = CGSizeMake(0,-1);
    label.shadowColor = [UIColor colorWithWhite:0 alpha:0.33];
    label.font = [UIFont boldCustomFontOfSize: 16];
    [view addSubview: label];
    
    NSString* text = @"Basic usage";
    if (section==1) text = @"Targeted animation";
    label.text = [text uppercaseString];
    
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (section==0) ? 3 : 1;
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
    
    if(indexPath.section == 0) {
        if(indexPath.row == 0) {
            cell.textLabel.text = @"Single Digit";
            cell.detailTextLabel.text = @"A JDFlipNumberView instance.";
        } else if(indexPath.row == 1) {
            cell.textLabel.text = @"Bigger Number";
            cell.detailTextLabel.text = @"A JDGroupedFlipNumberView instance.";
        } else {
            cell.textLabel.text = @"Silvester Countdown";
            cell.detailTextLabel.text = @"A JDDateCountdownView instance.";
        }
    } else {
        cell.textLabel.text = @"Bigger Number";
        cell.detailTextLabel.text = @"With targeted animations.";
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
