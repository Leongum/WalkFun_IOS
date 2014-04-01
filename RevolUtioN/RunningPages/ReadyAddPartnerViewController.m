//
//  ReadyAddPartnerViewController.m
//  WalkFun
//
//  Created by Bjorn on 14-3-25.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "ReadyAddPartnerViewController.h"

@interface ReadyAddPartnerViewController ()

@end

@implementation ReadyAddPartnerViewController
@synthesize delegate;

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
    
    contentList = [RORFriendService fetchFriendFansList];
    
    [RORUtils setFontFamily:APP_FONT forView:self.view andSubViews:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

-(IBAction)backAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^(){}];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return contentList.count;
}

- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = nil;
    UITableViewCell *cell = nil;
    identifier = @"friendCell";
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    Friend *userFriend = [contentList objectAtIndex:indexPath.row];
    User_Base *thisFriend = [RORUserServices fetchUser:userFriend.userId];
    if (!thisFriend)
        thisFriend = [RORUserServices syncUserInfoById:userFriend.userId];
    UILabel *friendNameLabel = (UILabel *)[cell viewWithTag:100];
    friendNameLabel.text = thisFriend.nickName;
    UILabel *friendFightLabel = (UILabel *)[cell viewWithTag:101];
    friendFightLabel.text = [NSString stringWithFormat:@"%ld+%ld",(long)thisFriend.userDetail.fight.integerValue, (long)thisFriend.userDetail.fightPlus.integerValue];
    
    [RORUtils setFontFamily:APP_FONT forView:cell andSubViews:YES];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Friend *userFriend = [contentList objectAtIndex:indexPath.row];
    User_Base *friend = [RORUserServices fetchUser:userFriend.userId];
    int addFight = friend.userDetail.fight.intValue + friend.userDetail.fightPlus.intValue;
    addFight/=5;
    NSString *alertMessage = [NSString stringWithFormat:@"确定要与【%@】结伴吗？\n\n战斗力: +%d\n  ", friend.userName ,addFight];
    
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"找伙伴" andMessage:alertMessage];
    [alertView addButtonWithTitle:@"取消"
                             type:SIAlertViewButtonTypeCancel
                          handler:^(SIAlertView *alertView) {
                          }];
    [alertView addButtonWithTitle:@"确定"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView) {
                              [delegate setValue:friend forKey:@"selectedFriend"];
                              [self backAction:self];
                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    
    [alertView show];
}
@end
