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
    self.backButton.alpha = 0;
    
    contentList = [RORFriendService fetchUserAction:[RORUserUtils getUserId]];
    [RORUtils setFontFamily:APP_FONT forView:self.view andSubViews:YES];
    
    [RORUserUtils writeToUserInfoPList:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0], @"MessageReceivedNumber", nil]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

-(IBAction)backAction:(id)sender{
//    [self dismissViewControllerAnimated:YES completion:^(){}];
    [super backAction:sender];
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
    [desLabel setLineBreakMode:NSLineBreakByWordWrapping];
    desLabel.numberOfLines = 2;
    desLabel.text = [NSString stringWithFormat:@"%@%@",action.actionFromId.integerValue==[RORUserUtils getUserId].integerValue?@"你":action.actionFromName, action.actionName];

    [RORUtils setFontFamily:APP_FONT forView:cell andSubViews:YES];
    return cell;
}

@end
