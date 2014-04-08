//
//  ItemIconView.h
//  WalkFun
//
//  Created by Bjorn on 14-2-17.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User_Prop.h"
#import "RORVirtualProductService.h"
#import "CoverView.h"

#define SIZE_ITEM_ICON 78

@interface ItemIconView : UIControl{
    UIImageView *itemIconImageView;
    UILabel *itemQuantityLabel;
    UIImageView * itemIconBgImageView;
    Virtual_Product *item;
    
    CoverView *itemDetailCoverView;
    UIViewController *parentViewController;
}

@property (strong, nonatomic) id delegate;
@property (strong, nonatomic) User_Prop *userItem;
@property (nonatomic) BOOL isUsable;

-(void)fillContentWith:(User_Prop *)item;
-(void)fillContentWith:(Virtual_Product *)newItem andQuantity:(NSInteger)count;
-(IBAction)didSelectItem:(id)sender;

@end
