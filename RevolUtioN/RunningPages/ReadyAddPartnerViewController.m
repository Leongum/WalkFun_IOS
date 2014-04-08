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
    cdDict = [[NSMutableDictionary alloc]init];
    
    for (Friend *userFriend in contentList){
        int days = [RORUtils daysBetweenDate1:userFriend.lastWalkTime andDate2:[NSDate date]];
        [cdDict setObject:[NSNumber numberWithInt:days] forKey:userFriend.userId];
    }
    
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
    
    
    Friend *userFriend = [contentList objectAtIndex:indexPath.row];
    int days = ((NSNumber *)[cdDict objectForKey:userFriend.userId]).intValue;
    
    if (days>4) {
        identifier = @"friendCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    } else {
        identifier = @"friendDisabledCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    
    User_Base *thisFriend = [RORUserServices fetchUser:userFriend.userId];
    if (!thisFriend)
        thisFriend = [RORUserServices syncUserInfoById:userFriend.userId];
    UILabel *friendNameLabel = (UILabel *)[cell viewWithTag:100];
    friendNameLabel.text = thisFriend.nickName;
    UILabel *friendFightLabel = (UILabel *)[cell viewWithTag:101];
    int addFight = thisFriend.userDetail.fight.intValue + thisFriend.userDetail.fightPlus.intValue;
    addFight/=5;
    friendFightLabel.text = [NSString stringWithFormat:@" +%d",addFight];
    if (days<=4){
        UILabel *leftDaysLabel = (UILabel *)[cell viewWithTag:102];
        leftDaysLabel.text = [NSString stringWithFormat:@"%d天", 5-days];
    } else {
        UILabel *upLabel = (UILabel *)[cell viewWithTag:102];
        upLabel.alpha = (thisFriend.userDetail.fightPlus.integerValue>0);
    }
    
    [RORUtils setFontFamily:APP_FONT forView:cell andSubViews:YES];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Friend *userFriend = [contentList objectAtIndex:indexPath.row];
    int days = ((NSNumber *)[cdDict objectForKey:userFriend.userId]).intValue;
    if (days>4){
        User_Base *friend = [RORUserServices fetchUser:userFriend.userId];
        int addFight = friend.userDetail.fight.intValue + friend.userDetail.fightPlus.intValue;
        addFight/=5;
        NSString *alertMessage = [NSString stringWithFormat:@"确定要与【%@】结伴吗？\n\n战斗力: +%d\n  ", friend.nickName ,addFight];
        
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
    } else {
        [self sendAlart:@"让人家再歇歇嘛"];
    }
}
@end
