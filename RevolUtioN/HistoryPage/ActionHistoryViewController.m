//
//  ActionHistoryViewController.m
//  WalkFun
//
//  Created by Bjorn on 14-3-10.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "ActionHistoryViewController.h"

@interface ActionHistoryViewController ()

@end

@implementation ActionHistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    contentList = [RORFriendService fetchUserAction:[RORUserUtils getUserId]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

-(IBAction)backAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^(){}];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return contentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"actionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Action *action = [contentList objectAtIndex:indexPath.row];
    
    UILabel *dateLabel = (UILabel *)[cell viewWithTag:100];
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *formatDateString = [formate stringFromDate:(NSDate *)action.updateTime];
    dateLabel.text = formatDateString;
    
    UILabel *desLabel = (UILabel *)[cell viewWithTag:101];
    desLabel.text = [NSString stringWithFormat:@"%@%@",action.actionFromId.integerValue==[RORUserUtils getUserId].integerValue?@"你":action.actionFromName, action.actionName];

    return cell;
}

@end
