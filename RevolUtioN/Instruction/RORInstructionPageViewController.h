//
//  RORInstructionPageViewController.h
//  WalkFun
//
//  Created by Bjorn on 13-10-18.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORViewController.h"

@interface RORInstructionPageViewController : RORViewController<UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) NSMutableArray *contentViews;

@end
