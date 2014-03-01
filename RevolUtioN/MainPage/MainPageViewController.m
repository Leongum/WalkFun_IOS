//
//  MainPageViewController.m
//  WalkFun
//
//  Created by Bjorn on 14-2-18.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "MainPageViewController.h"

@interface MainPageViewController ()

@end

@implementation MainPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    if ([titleView superview] != self.view){
        [titleView removeFromSuperview];
        [[self parentViewController].view addSubview:titleView];
//    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self syncPageFromServer];
}

-(void)syncPageFromServer{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshTitleLayout:(double)offset{
    currentOffset = offset;
    double x = fabs(currentOffset);
    double h = CGRectGetHeight(titleView.frame);
    double newY = 0 - x/160 * h;
    titleView.center = CGPointMake(titleView.center.x, newY+h/2);
}

-(void)setPage:(NSInteger)pageNumber{
    page = pageNumber;
    [self refreshTitleLayout:abs(pageNumber-1)*320];
}

-(double)getCurrentOffset{
    return currentOffset;
}

@end
