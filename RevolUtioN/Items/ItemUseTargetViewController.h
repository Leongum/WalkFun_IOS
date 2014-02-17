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

@interface ItemUseTargetViewController : RORViewController{
    NSArray *contentList;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
