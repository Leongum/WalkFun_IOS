//
//  ItemUseTargetViewController.h
//  WalkFun
//
//  Created by Bjorn on 14-2-17.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "RORViewController.h"
#import "RORFriendService.h"
#import "RORUserServices.h"
#import "RORUserPropsService.h"
#import "RORVirtualProductService.h"
#import "RORMissionServices.h"

@interface ItemUseTargetViewController : RORViewController{
    NSArray *contentList;
    
    Friend *selectedFriend;
    BOOL isItemAboutFight;
    BOOL toSelf;
    BOOL isSucceeded;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) Virtual_Product *selectedItem;
@property (strong, nonatomic) id delegate;
@end
