//
//  ItemMallViewController.h
//  WalkFun
//
//  Created by Bjorn on 14-2-15.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "RORViewController.h"
#import "ItemQuantityPicker.h"

@interface ItemMallViewController : RORViewController{
    NSMutableArray *contentList;
}

@property (strong, nonatomic) IBOutlet ItemQuantityPicker *itemQuantityCoverView;
@property (strong, nonatomic) IBOutlet UILabel *totalCost;
@property (strong, nonatomic) IBOutlet RORNormalButton *buyButton;

@end
