//
//  UserItemScrollView.h
//  WalkFun
//
//  Created by Bjorn on 14-2-17.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemIconView.h"
#import "CoverView.h"

#define COUNT_LINE 3
#define MARGIN_TOP_BOTTOM 10
#define MARGIN_LEFT_RIGHT 20
#define MARGIN_BETWEEN_LINES 10

@interface UserItemScrollView : UIScrollView<UIScrollViewDelegate>{
    NSMutableArray *contentList;
    CGSize itemIconSize;
    double marginBetweenItems;
    
    CoverView *itemDetailCoverView;
    Virtual_Product *item;
    UIViewController *parentViewController;
}

-(void)initContent:(NSArray *)content;
@end
