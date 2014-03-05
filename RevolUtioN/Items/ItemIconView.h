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

@interface ItemIconView : UIControl{
    UIImageView *itemIconImageView;
    UILabel *itemQuantityLabel;
    UIImageView * itemIconBgImageView;
    Virtual_Product *item;
}
@property (strong, nonatomic) User_Prop *userItem;


-(void)fillContentWith:(User_Prop *)item;
@end
