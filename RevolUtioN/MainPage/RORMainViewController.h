//
//  RORMainViewController.h
//  WalkFun
//
//  Created by Bjorn on 14-2-14.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "RORViewController.h"
#import "MainPageViewController.h"
#import "RORUserPropsService.h"
#import "RORMissionHistoyService.h"
#import "RORRunHistoryServices.h"

#define PAGE_QUANTITY 3

@interface RORMainViewController : RORViewController<UIScrollViewDelegate>{
    MainPageViewController *friendViewController, *firstViewController, *itemViewController;
    UIStoryboard *mainStoryboard;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) NSMutableArray *contentViews;

@end
