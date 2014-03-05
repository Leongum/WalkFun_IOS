//
//  UserItemScrollView.h
//  WalkFun
//
//  Created by Bjorn on 14-2-17.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemIconView.h"
#import "ItemDetailCoverView.h"

#define COUNT_LINE 3
#define MARGIN_TOP_BOTTOM 10
#define MARGIN_LEFT_RIGHT 20
#define MARGIN_BETWEEN_LINES 10
#define SIZE_ITEM_ICON 78

@interface UserItemScrollView : UIScrollView<UIScrollViewDelegate>{
    NSMutableArray *contentList;
    CGSize itemIconSize;
    double marginBetweenItems;
    
    ItemDetailCoverView *itemDetailCoverView;
}

-(void)initContent:(NSArray *)content;
@end
