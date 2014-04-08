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
//        [itemIcon addTarget:self action:@selector(didSelectItem:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:itemIcon];
    }
}

//-(IBAction)didSelectItem:(id)sender{
//    parentViewController = (UIViewController *)self.delegate;
//    while ([parentViewController parentViewController]) {
//        parentViewController = [parentViewController parentViewController];
//    }
//    ItemIconView *itemIcon = (ItemIconView *)sender;
//    
//    UIStoryboard *itemStoryboard = [UIStoryboard storyboardWithName:@"ItemsStoryboard" bundle:[NSBundle mainBundle]];
//    UIViewController *itemViewController =  [itemStoryboard instantiateViewControllerWithIdentifier:@"itemDetailCoverViewController"];
//    itemDetailCoverView = (CoverView *)itemViewController.view;
//    
//    UILabel *itemNameLabel = (UILabel *)[itemDetailCoverView viewWithTag:100];
//    UIImageView *itemIconView = (UIImageView *)[itemDetailCoverView viewWithTag:101];
//    UILabel *itemEffectLabel = (UILabel *)[itemDetailCoverView viewWithTag:102];
//    UILabel *itemDescLabel = (UILabel *)[itemDetailCoverView viewWithTag:103];
//    UIButton *useButton = (UIButton *)[itemDetailCoverView viewWithTag:104];
//    
//    [itemDescLabel setLineBreakMode:NSLineBreakByWordWrapping];
//    itemDescLabel.numberOfLines = 0;
//    
//    item = [RORVirtualProductService fetchVProduct:itemIcon.userItem.productId];;
//
//    itemNameLabel.text = item.productName;
//    itemIconView.image = [RORVirtualProductService getImageOf:item];
//    NSArray *itemInfoStringList = [item.productDescription componentsSeparatedByString:@"\\n\\n"];
//    if (itemInfoStringList.count>1)
//        itemEffectLabel.text = [itemInfoStringList objectAtIndex:1];
//    itemDescLabel.text = [itemInfoStringList objectAtIndex:0];
//
//    [useButton addTarget:self action:@selector(useItemAction:) forControlEvents:UIControlEventTouchUpInside];
//    [itemDetailCoverView addCoverBgImage];
//    [parentViewController.view addSubview:itemDetailCoverView];
//    
//    [RORUtils setFontFamily:APP_FONT forView:itemDetailCoverView andSubViews:YES];
//
//    [itemDetailCoverView appear:self];
//}

//-(IBAction)useItemAction:(id)sender{
//    UIStoryboard *itemStoryboard = [UIStoryboard storyboardWithName:@"ItemsStoryboard" bundle:[NSBundle mainBundle]];
//    UIViewController *itemViewController =  [itemStoryboard instantiateViewControllerWithIdentifier:@"ItemUseTargetViewController"];
//    if ([itemViewController respondsToSelector:@selector(setSelectedItem:)]){
//        [itemViewController setValue:item forKey:@"selectedItem"];
//    }
//    [parentViewController presentViewController:itemViewController animated:YES completion:^(){}];
//    
//    [itemDetailCoverView bgTap:self];
//}


@end
