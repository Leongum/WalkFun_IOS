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
    NSArray *latestPage;
    int pageCount;
    BOOL noMoreData;
}

@property (strong, nonatomic) IBOutlet UIView *friendTitleView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIImageView *tableViewContainer;
@property (strong, nonatomic) IBOutlet UIButton *expandButton;

@end
