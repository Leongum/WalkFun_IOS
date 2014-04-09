//
//  MissionStoneCongratsViewController.h
//  WalkFun
//
//  Created by Bjorn on 14-4-9.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "RORViewController.h"
#import "PooViewController.h"

@interface MissionStoneCongratsViewController : PooViewController{
    UIView *titleView;
}

@property (strong, nonatomic) IBOutlet UIImageView *itemIconImageView;
@property (strong, nonatomic) IBOutlet StrokeLabel *itemNameLabel;
@property (strong, nonatomic) IBOutlet StrokeLabel *goldLabel;

@property (strong, nonatomic) IBOutlet UIView *goldSubView;
@property (strong, nonatomic) IBOutlet UIView *itemSubView;


-(void)showItem:(Virtual_Product *)item;
-(void)showGold:(NSNumber *)number;

@end
