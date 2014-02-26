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
    
//    UIButton *testButton = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
//    [testButton setTitle:@"test" forState:UIControlStateNormal];
//    [self addSubview:testButton];
//    [testButton addTarget:self action:@selector(didSelectItem:) forControlEvents:UIControlEventTouchUpInside];
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
    self.contentSize =
    CGSizeMake(0,
               (content.count/COUNT_LINE+1)*(SIZE_ITEM_ICON + MARGIN_BETWEEN_LINES)
               - MARGIN_BETWEEN_LINES
               + MARGIN_TOP_BOTTOM*2 );
    
    for (int i=0; i<content.count; i++){
        NSInteger column = i%COUNT_LINE;
        NSInteger row = i/COUNT_LINE;
        ItemIconView *itemIcon = [[ItemIconView alloc]initWithFrame:CGRectMake(MARGIN_LEFT_RIGHT + column*(SIZE_ITEM_ICON + marginBetweenItems), MARGIN_TOP_BOTTOM + row * (SIZE_ITEM_ICON + MARGIN_BETWEEN_LINES), SIZE_ITEM_ICON, SIZE_ITEM_ICON)];
        [itemIcon fillContentWith:[content objectAtIndex:i]];
        [itemIcon addTarget:self action:@selector(didSelectItem:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:itemIcon];
    }
}

-(IBAction)didSelectItem:(id)sender{
    ItemIconView *itemIcon = (ItemIconView *)sender;
    
    UIViewController *controller = (UIViewController *)self.delegate;
    itemDetailCoverView = [[ItemDetailCoverView alloc]initWithFrame:controller.view.frame andUserItem:itemIcon.userItem];
    itemDetailCoverView.delegate = self.delegate;
    [[controller parentViewController].view addSubview:itemDetailCoverView];
    [itemDetailCoverView appear:self];
}

@end
