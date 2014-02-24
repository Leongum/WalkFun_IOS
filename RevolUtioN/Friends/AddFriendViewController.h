//
//  AddFriendViewController.h
//  WalkFun
//
//  Created by Bjorn on 14-2-21.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "RORViewController.h"
#import "RORFriendService.h"
#import "RORUserServices.h"
#import "FriendInfoViewController.h"

@interface AddFriendViewController : RORViewController{
    NSArray *contentList;
    NSInteger recommendPage;
    
    Search_Friend *addingFriend;
    BOOL isAddingSuccess;
}

@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) IBOutlet UILabel *tableTitleLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *refreshRecommendButton;


@end
