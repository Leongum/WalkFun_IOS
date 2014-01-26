//
//  RORHistoryPageViewController.h
//  RevolUtioN
//
//  Created by Bjorn on 13-8-19.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RORHistoryViewController.h"
#import "RORStatisticsViewController.h"
#import "RORViewController.h"
#import "RORBreathingControl.h"

@interface RORHistoryPageViewController : RORViewController<UIScrollViewDelegate>{
    BOOL isChecked[3];
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) NSMutableArray *contentViews;
@property (strong, nonatomic) RORStatisticsViewController *statisticsViewController;
@property (strong, nonatomic) RORHistoryViewController *listViewController;
@property (strong, nonatomic) IBOutlet UITableView *filterTableView;
@property (strong, nonatomic) IBOutlet UIView *coverView;
@property (strong, nonatomic) NSMutableArray *filter;

@property (strong, nonatomic) IBOutlet UIButton *formerPageButton;
@property (strong, nonatomic) IBOutlet UIButton *nextPageButton;

@property (assign) NSTimer *repeatingTimer;
@property (strong, nonatomic) IBOutlet RORNormalButton *syncButton;

@end
