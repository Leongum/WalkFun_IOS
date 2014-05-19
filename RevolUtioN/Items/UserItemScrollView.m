//
//  UserItemScrollView.m
//  WalkFun
//
//  Created by Bjorn on 14-2-17.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "UserItemScrollView.h"

@implementation UserItemScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self customInit];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self customInit];
    }
    return self;
}

-(void)customInit{
    self.contentSize =
    CGSizeMake(0, CGRectGetHeight(self.frame));
    
    itemIconSize = CGSizeMake(SIZE_ITEM_ICON, SIZE_ITEM_ICON);
    marginBetweenItems = (CGRectGetWidth(self.frame) - MARGIN_LEFT_RIGHT * (COUNT_LINE-1) - SIZE_ITEM_ICON*COUNT_LINE) / (COUNT_LINE-1);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)initContent:(NSArray *)content{
    for (UIView * view in [self subviews]){
        [view removeFromSuperview];
    }
    
    if (content==nil)
        return;
    
    self.contentSize =
    CGSizeMake(0,
               (content.count/COUNT_LINE+1)*(SIZE_ITEM_ICON + MARGIN_BETWEEN_LINES)
               - MARGIN_BETWEEN_LINES
               + MARGIN_TOP_BOTTOM*2 );
    
    for (int i=0; i<content.count; i++){
        NSInteger column = i%COUNT_LINE;
        NSInteger row = i/COUNT_LINE;
        ItemIconView *itemIcon = [[ItemIconView alloc]initWithFrame:CGRectMake(MARGIN_LEFT_RIGHT + column*(SIZE_ITEM_ICON + marginBetweenItems), MARGIN_TOP_BOTTOM + row * (SIZE_ITEM_ICON + MARGIN_BETWEEN_LINES), SIZE_ITEM_ICON, SIZE_ITEM_ICON)];
        itemIcon.delegate = self.delegate;
        [itemIcon fillContentWith:[content objectAtIndex:i]];
        [self addSubview:itemIcon];
    }
}



@end
