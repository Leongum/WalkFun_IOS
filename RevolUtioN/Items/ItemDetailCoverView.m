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
        
        //todo:图片
        UIImage *iconImage = [RORVirtualProductService getImageOf:item];

        itemImageView = [[UIImageView alloc]initWithImage:iconImage];
        itemImageView.frame = CGRectMake(CGRectGetWidth(frame)/2-BIG_ITEM_SIZE/2, 105, BIG_ITEM_SIZE, BIG_ITEM_SIZE);
        [self addSubview:itemImageView];
        
        itemDescriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, itemImageView.center.y+BIG_ITEM_SIZE/2 + 50, CGRectGetWidth(frame) - 100, 100)];
        [itemDescriptionLabel setFont:[UIFont systemFontOfSize:14]];
        [itemDescriptionLabel setTextColor:[UIColor whiteColor]];
//        Virtual_Product *item = [RORVirtualProductService fetchVProduct:userItem.productId];
        NSMutableString *desc = [[NSMutableString alloc]initWithString:item.productDescription];
        [desc replaceOccurrencesOfString:@"\\n" withString:@"\n" options:NSLiteralSearch|NSCaseInsensitiveSearch range:NSMakeRange(0, [desc length])];
        itemDescriptionLabel.text = desc;
        [itemDescriptionLabel setLineBreakMode:NSLineBreakByWordWrapping];
        itemDescriptionLabel.numberOfLines = 0;
        //todo: 多行显示
        [self addSubview:itemDescriptionLabel];
        
        itemUseButton = [[RORNavigationButton alloc]initWithFrame:CGRectMake(0, 0, 110, 49)];
        itemUseButton.center = CGPointMake(CGRectGetWidth(frame)/2, CGRectGetHeight(frame)-75);
        [itemUseButton setTitle:@"使用" forState:UIControlStateNormal];
        [itemUseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [itemUseButton addTarget:self action:@selector(useItemAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:itemUseButton];
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
