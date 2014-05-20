//
//  ItemMallViewController.h
//  WalkFun
//
//  Created by Bjorn on 14-2-15.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "RORViewController.h"
#import "ItemQuantityPicker.h"
#import "RORVirtualProductService.h"
#import "RORUserPropsService.h"
#import "RORUserServices.h"

@interface ItemMallViewController : RORViewController{
    NSMutableArray *contentList;
    Virtual_Product *selectedItem;
    int selectedQuantity;
    int userMoney;
    BOOL isServiceSuccess;
}

@property (strong, nonatomic) IBOutlet ItemQuantityPicker *itemQuantityCoverView;
@property (strong, nonatomic) IBOutlet UILabel *selectedItemNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *selectedItemIcon;
@property (strong, nonatomic) IBOutlet UILabel *selectedItemEffectLabel;
@property (strong, nonatomic) IBOutlet UILabel *selectedItemDescription;

@property (strong, nonatomic) IBOutlet RORNormalButton *buyButton;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIPickerView *pickView;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;

@property (strong, nonatomic)     User_Base * userBase;


@end
