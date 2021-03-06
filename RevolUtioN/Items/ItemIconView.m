//
//  ItemIconView.m
//  WalkFun
//
//  Created by Bjorn on 14-2-17.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "ItemIconView.h"
#import "RORMainViewController.h"

@implementation ItemIconView
@synthesize userItem, delegate, isUsable;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        isUsable = YES;
        
        itemIconBgImageView = [[UIImageView alloc]initWithFrame:frame];
        itemIconBgImageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        itemIconBgImageView.image = [UIImage imageNamed:@"item_icon_cell.png"];
        [self addSubview:itemIconBgImageView];

        double frameWidth = CGRectGetWidth(self.frame);
        double frameHeight = CGRectGetHeight(self.frame);
        
        itemIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5*frameWidth/26, 12*frameHeight/SIZE_ITEM_ICON, 47*frameWidth/SIZE_ITEM_ICON, 47*frameHeight/SIZE_ITEM_ICON)];
//        itemIconImageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self addSubview:itemIconImageView];
        
        itemQuantityLabel = [[UILabel alloc]initWithFrame:CGRectMake(20*frameWidth/SIZE_ITEM_ICON, self.frame.size.height-21*frameWidth/SIZE_ITEM_ICON, frameWidth-40*frameWidth/SIZE_ITEM_ICON, 20*frameWidth/SIZE_ITEM_ICON)];
        [itemQuantityLabel setFont:[UIFont boldSystemFontOfSize:13*frameWidth/SIZE_ITEM_ICON]];
        [itemQuantityLabel setBackgroundColor:[UIColor clearColor]];
        [itemQuantityLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:itemQuantityLabel];
        
        [RORUtils setFontFamily:APP_FONT forView:self andSubViews:YES];
        
        //添加单击事件
        [self addTarget:self action:@selector(didSelectItem:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)fillContentWith:(User_Prop *)newUserItem{
    userItem = newUserItem;
    item = [RORVirtualProductService fetchVProduct:userItem.productId];
    UIImage *iconImage = [RORVirtualProductService getImageOf:item];
    [itemIconImageView setImage:iconImage];
    itemQuantityLabel.text = [NSString stringWithFormat:@"x %@",userItem.ownNumber];
}

-(void)fillContentWith:(Virtual_Product *)newItem andQuantity:(NSInteger)count{
    item = newItem;
    UIImage *iconImage = [RORVirtualProductService getImageOf:item];
    [itemIconImageView setImage:iconImage];
    itemQuantityLabel.text = [NSString stringWithFormat:@"x %d",count];
}


-(IBAction)didSelectItem:(id)sender{
    
    //获得mainViewController
    parentViewController = (UIViewController *)self.delegate;
    while (![parentViewController isKindOfClass:[RORMainViewController class]] && [parentViewController parentViewController]) {
        parentViewController = [parentViewController parentViewController];
    }
    
//    ItemIconView *itemIcon = (ItemIconView *)sender;
    
    UIStoryboard *itemStoryboard = [UIStoryboard storyboardWithName:@"ItemsStoryboard" bundle:[NSBundle mainBundle]];
    UIViewController *itemViewController =  [itemStoryboard instantiateViewControllerWithIdentifier:@"itemDetailCoverViewController"];
    itemDetailCoverView = (CoverView *)itemViewController.view;
    
    UILabel *itemNameLabel = (UILabel *)[itemDetailCoverView viewWithTag:100];
    UIImageView *itemIconView = (UIImageView *)[itemDetailCoverView viewWithTag:101];
    UILabel *itemEffectLabel = (UILabel *)[itemDetailCoverView viewWithTag:102];
    UILabel *itemDescLabel = (UILabel *)[itemDetailCoverView viewWithTag:103];
    UIButton *useButton = (UIButton *)[itemDetailCoverView viewWithTag:104];
    //是否可以使用
    useButton.alpha = isUsable;
    
    [itemDescLabel setLineBreakMode:NSLineBreakByWordWrapping];
    itemDescLabel.numberOfLines = 0;
    [itemEffectLabel setLineBreakMode:NSLineBreakByWordWrapping];
    itemEffectLabel.numberOfLines = 0;
    
    itemNameLabel.text = item.productName;
    itemIconView.image = [RORVirtualProductService getImageOf:item];
    NSArray *itemInfoStringList = [item.productDescription componentsSeparatedByString:@"|"];
    if (itemInfoStringList.count>1)
        itemEffectLabel.text = [RORUtils explainItemEffectString:[itemInfoStringList objectAtIndex:1]];
    itemDescLabel.text = [itemInfoStringList objectAtIndex:0];
    
    [useButton addTarget:self action:@selector(useItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [itemDetailCoverView addCoverBgImage:[RORUtils captureScreen] grayed:YES];
    [parentViewController.view addSubview:itemDetailCoverView];
    
    [RORUtils setFontFamily:APP_FONT forView:itemDetailCoverView andSubViews:YES];
    
    [itemDetailCoverView appear:self];
}

-(IBAction)useItemAction:(id)sender{
    UIStoryboard *itemStoryboard = [UIStoryboard storyboardWithName:@"ItemsStoryboard" bundle:[NSBundle mainBundle]];
    UIViewController *itemViewController =  [itemStoryboard instantiateViewControllerWithIdentifier:@"ItemUseTargetViewController"];
    if ([itemViewController respondsToSelector:@selector(setSelectedItem:)]){
        [itemViewController setValue:item forKey:@"selectedItem"];
    }
    if ([itemViewController respondsToSelector:@selector(setDelegate:)]){
        [itemViewController setValue:parentViewController forKey:@"delegate"];
    }
    [parentViewController presentViewController:itemViewController animated:YES completion:^(){}];
    
    [itemDetailCoverView bgTap:self];
}


@end
