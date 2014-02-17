//
//  ItemsMainViewController.h
//  WalkFun
//
//  Created by Bjorn on 14-2-14.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "RORViewController.h"
#import "CoverView.h"
#import "UserItemScrollView.h"
#import "RORUserPropsService.h"

@interface ItemsMainViewController : RORViewController<UIScrollViewDelegate>{
    NSArray *itemList;
    UIViewController *parentController;
    CoverView *mallCoverView;
}

@property (strong, nonatomic) IBOutlet CoverView *itemDetailCoverView;

@property (strong, nonatomic) IBOutlet UserItemScrollView *userItemScrollView;

@end
