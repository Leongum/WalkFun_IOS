//
//  ItemUseTargetViewController.m
//  WalkFun
//
//  Created by Bjorn on 14-2-17.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "ItemUseTargetViewController.h"

@interface ItemUseTargetViewController ()

@end

@implementation ItemUseTargetViewController
@synthesize selectedItem;

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

    //todo:load content
    contentList = [RORFriendService fetchFriendEachFansList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Actions

-(IBAction)backAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^(){}];
}

- (IBAction)use2Self:(id)sender {
    toSelf = YES;

    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"选择目标" andMessage:@"确定对【自己】使用吗？"];
    [alertView addButtonWithTitle:@"取消"
                             type:SIAlertViewButtonTypeCancel
                          handler:^(SIAlertView *alertView) {
                          }];
    [alertView addButtonWithTitle:@"确定"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView) {
                              if (toSelf)
                                  [self useItemTo:[RORUserUtils getUserId]];
                              else
                                  [self useItemTo:selectedFriend.friendId];
                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    
    alertView.willShowHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, willShowHandler2", alertView);
    };
    alertView.didShowHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, didShowHandler2", alertView);
    };
    alertView.willDismissHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, willDismissHandler2", alertView);
    };
    alertView.didDismissHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, didDismissHandler2", alertView);
    };
    
    [alertView show];
}

-(void)useItemTo:(NSNumber *)userId{
    //todo
    User_Base *toThisUser = [RORUserServices fetchUser:userId];
    if (!toThisUser)
        toThisUser = [RORUserServices syncUserInfoById:userId];
    Action_Define *action = [RORSystemService fetchActionDefineByPropId:selectedItem.productId];
    [self startIndicator:self];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        isSucceeded = [RORFriendService createAction:toThisUser.userId withActionToUserName:toThisUser.nickName withActionId:action.actionId];
        //触发并完成了任务
        Mission *todayMission = [RORMissionServices getTodayMission];
        if (todayMission){
            if (todayMission.missionTypeId.integerValue == MissionTypeUseItem &&
                userId.integerValue != [RORUserUtils getUserId].integerValue &&
                action.actionId.integerValue == todayMission.triggerPropId.integerValue){
                NSMutableDictionary *userInfoList = [RORUserUtils getUserInfoPList];
                NSNumber *missionUseItemQuantity = [userInfoList valueForKey:@"missionUseItemQuantity"];
                int q = missionUseItemQuantity.integerValue;
                q--;
                if (q<0)
                    q=0;
                [userInfoList setObject:[NSNumber numberWithInteger:q] forKey:@"missionUseItemQuantity"];
                [RORUserUtils writeToUserInfoPList:userInfoList];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isSucceeded){
                [self sendSuccess:@"使用成功"];
            } else {
                [self sendAlart:@"网络错误！"];
            }
            [self backAction:self];
        });
    });
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 3;
    return contentList.count;
}

- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = nil;
    UITableViewCell *cell = nil;
    identifier = @"friendCell";
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    Friend *friend = [contentList objectAtIndex:indexPath.row];
    UILabel *friendNameLabel = (UILabel *)[cell viewWithTag:100];
    friendNameLabel.text = friend.userName;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Friend *thisFriend = [contentList objectAtIndex:indexPath.row];
    selectedFriend = thisFriend;
    
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"选择目标" andMessage:[NSString stringWithFormat:@"确定对【%@】使用吗？", thisFriend.userName]];
    [alertView addButtonWithTitle:@"取消"
                             type:SIAlertViewButtonTypeCancel
                          handler:^(SIAlertView *alertView) {
                          }];
    [alertView addButtonWithTitle:@"确定"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView) {
                              if (toSelf)
                                  [self useItemTo:[RORUserUtils getUserId]];
                              else
                                  [self useItemTo:selectedFriend.friendId];
                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    
    alertView.willShowHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, willShowHandler2", alertView);
    };
    alertView.didShowHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, didShowHandler2", alertView);
    };
    alertView.willDismissHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, willDismissHandler2", alertView);
    };
    alertView.didDismissHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, didDismissHandler2", alertView);
    };
    
    [alertView show];
}

#pragma mark - AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }else if(buttonIndex == 1){
        if (toSelf)
            [self useItemTo:[RORUserUtils getUserId]];
        else
            [self useItemTo:selectedFriend.friendId];
    }
}

@end
