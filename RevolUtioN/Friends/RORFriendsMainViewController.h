//
//  RORFriendsMainViewController.h
//  WalkFun
//
//  Created by Bjorn on 13-11-6.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "MainPageViewController.h"
#import "RORUserServices.h"
#import "RORDBCommon.h"
#import "RORFriendService.h"

@interface RORFriendsMainViewController : MainPageViewController{
    double searchViewTop;
    User_Base *userInfo;
    NSArray *contentList;
    NSArray *fansList;
    NSArray *followList;
    NSArray *friendList;
    
    BOOL isDeletingSuccess;
    Friend *deletingFriend;
    
    BOOL showFollow, showFans;
}

@property (strong, nonatomic) IBOutlet UIView *friendTitleView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *expandButton;

@property (strong, nonatomic) IBOutlet UIButton *showFollowButton;
@property (strong, nonatomic) IBOutlet UIButton *showFansButton;
@property (strong, nonatomic) IBOutlet UIButton *endDeletingButton;
@property (strong, nonatomic) IBOutlet UIButton *startDeletingButton;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@end
