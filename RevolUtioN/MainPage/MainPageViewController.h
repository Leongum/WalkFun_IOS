//
//  MainPageViewController.h
//  WalkFun
//
//  Created by Bjorn on 14-2-18.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "RORViewController.h"

@interface MainPageViewController : RORViewController{
    NSInteger page;
    
    UIView *titleView;
    double currentOffset;
}

-(void)refreshTitleLayout:(double)offset;

-(void)setPage:(NSInteger)pageNumber;
-(double)getCurrentOffset;

@end
