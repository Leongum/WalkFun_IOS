//
//  ItemDetailCoverView.m
//  WalkFun
//
//  Created by Bjorn on 14-2-17.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "ItemDetailCoverView.h"
#import "FTAnimation.h"

@implementation ItemDetailCoverView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame andUserItem:(User_Prop*)newUserItem
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        item = [RORVirtualProductService fetchVProduct:newUserItem.productId];;
        
        itemNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, frame.size.width, 30)];
        [itemNameLabel setFont:[UIFont systemFontOfSize:24]];
        [itemNameLabel setTextColor:[UIColor whiteColor]];
        itemNameLabel.text = newUserItem.productName;
        [itemNameLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:itemNameLabel];
        
        //todo:图片
        UIImage *iconImage = [RORVirtualProductService getImageOf:item];
        itemImageView = [[UIImageView alloc]initWithImage:iconImage];
        itemImageView.frame = CGRectMake(CGRectGetWidth(frame)/2-BIG_ITEM_SIZE/2, 105, BIG_ITEM_SIZE, BIG_ITEM_SIZE);
        [self addSubview:itemImageView];
        
        NSArray *itemInfoStringList = [item.productDescription componentsSeparatedByString:@"\\n\\n"];
        
        //道具的作用
        itemEffectLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, itemImageView.frame.origin.y+itemImageView.frame.size.height+20, frame.size.width, 30)];
        [itemEffectLabel setFont:[UIFont systemFontOfSize:22]];
        [itemEffectLabel setTextColor:[UIColor whiteColor]];
        itemEffectLabel.text = [itemInfoStringList objectAtIndex:1];
        [itemEffectLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [itemEffectLabel setTextAlignment:NSTextAlignmentCenter];
        itemEffectLabel.numberOfLines = 0;
        [self addSubview:itemEffectLabel];

        
        itemDescriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, itemImageView.center.y+BIG_ITEM_SIZE/2 + 60, CGRectGetWidth(frame) - 100, 100)];
        [itemDescriptionLabel setFont:[UIFont systemFontOfSize:20]];
        [itemDescriptionLabel setTextColor:[UIColor whiteColor]];
        itemDescriptionLabel.text = [itemInfoStringList objectAtIndex:0];
        [itemDescriptionLabel setLineBreakMode:NSLineBreakByWordWrapping];
        itemDescriptionLabel.numberOfLines = 0;
        //todo: 多行显示
        [self addSubview:itemDescriptionLabel];
        
        itemUseButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 110, 49)];
        itemUseButton.center = CGPointMake(CGRectGetWidth(frame)/2, CGRectGetHeight(frame)-75);
        [itemUseButton setTitle:@"使用" forState:UIControlStateNormal];
        [itemUseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [itemUseButton addTarget:self action:@selector(useItemAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:itemUseButton];
        
        [RORUtils setFontFamily:APP_FONT forView:self andSubViews:YES];
    }
    return self;
}


#pragma mark Actions

-(IBAction)useItemAction:(id)sender{
    UIViewController *parentController = [((UIViewController*)delegate) parentViewController];
    UIStoryboard *itemStoryboard = [UIStoryboard storyboardWithName:@"ItemsStoryboard" bundle:[NSBundle mainBundle]];
    UIViewController *itemViewController =  [itemStoryboard instantiateViewControllerWithIdentifier:@"ItemUseTargetViewController"];
    if ([itemViewController respondsToSelector:@selector(setSelectedItem:)]){
        [itemViewController setValue:item forKey:@"selectedItem"];
    }
    [parentController presentViewController:itemViewController animated:YES completion:^(){}];

    [self bgTap:self];
}

@end
