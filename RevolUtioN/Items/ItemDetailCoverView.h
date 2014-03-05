//
//  ItemDetailCoverView.h
//  WalkFun
//
//  Created by Bjorn on 14-2-17.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "CoverView.h"
#import "User_Prop.h"
#import "RORVirtualProductService.h"

#define BIG_ITEM_SIZE 110

@interface ItemDetailCoverView : CoverView{
    Virtual_Product *item;
    User_Prop *userItem;
    
    UIImageView *itemImageView;
    UILabel *itemNameLabel;
    UILabel *itemEffectLabel;
    UILabel *itemDescriptionLabel;
    RORNavigationButton *itemUseButton;
}

@property (strong, nonatomic) id delegate;

- (id)initWithFrame:(CGRect)frame andUserItem:(User_Prop*)userItem;

@end
