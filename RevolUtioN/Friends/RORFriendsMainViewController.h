//
//  RORFriendsMainViewController.h
//  WalkFun
//
//  Created by Bjorn on 13-11-6.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORFriendsViewController.h"

@interface RORFriendsMainViewController : RORFriendsViewController{
    double searchViewTop;
    User_Base *userInfo;
    NSMutableArray *contentList;
    NSArray *latestPage;
    int pageCount;
    BOOL noMoreData;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *addButton;
@property (strong, nonatomic) IBOutlet UIView *searchFriendView;
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) IBOutlet UILabel *searchResultUserNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *searchResultUserIdLabel;
@property (strong, nonatomic) IBOutlet UIImageView *tableViewContainer;
@property (strong, nonatomic) IBOutlet UIButton *expandButton;
@property (strong, nonatomic) IBOutlet UIImageView *searchResultUserSex;
@property (strong, nonatomic) IBOutlet UILabel *searchResultUserLvLabel;
@end
