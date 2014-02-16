//
//  RORMainViewController.h
//  WalkFun
//
//  Created by Bjorn on 14-2-14.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "RORViewController.h"

@interface RORMainViewController : RORViewController<UIScrollViewDelegate>{
    UIViewController *friendViewController, *firstViewController, *itemViewController;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) NSMutableArray *contentViews;

@end
