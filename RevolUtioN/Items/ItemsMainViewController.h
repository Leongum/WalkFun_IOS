//
//  ItemsMainViewController.h
//  WalkFun
//
//  Created by Bjorn on 14-2-14.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "MainPageViewController.h"
#import "CoverView.h"
#import "UserItemScrollView.h"
#import "RORUserPropsService.h"

@interface ItemsMainViewController : MainPageViewController<UIScrollViewDelegate>{
    NSArray *itemList;
    UIViewController *parentController;
    CoverView *mallCoverView;
}

@property (strong, nonatomic) IBOutlet CoverView *itemDetailCoverView;

@property (strong, nonatomic) IBOutlet UserItemScrollView *userItemScrollView;
@property (strong, nonatomic) IBOutlet UIView *itemMainTitleView;

@end