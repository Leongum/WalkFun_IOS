//
//  CharatorViewController.h
//  WalkFun
//
//  Created by Bjorn on 14-2-28.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#define ITEM_SIZE_MAX 30
#define ITEM_SIZE_MIN 20
#define GROUND_SIZE_WIDTH 160
#define GROUND_SIZE_HEIGHT 90
#define BEHIND_HEIGHT 36
#define FRONT_HEIGHT 30

#define VASE_SIZE_WIDTH 30
#define VASE_SIZE_HEIGHT 10

#import "RORViewController.h"
#import "RORVirtualProductService.h"
#import "THProgressView.h"
#import "UIUtils.h"

@interface CharatorViewController : UIViewController{
    UIView *behindCharatorView, *frontCharatorView, *flowContainerView;
    UIImageView *charatorImageView, *charatorBumpImageView;
    UILabel *fatPVFrameView, *fightPVFrameView;
    THProgressView *fatPV, *fightPV;

    NSDictionary *itemForDisplayDict;
    BOOL haveBump;
}

@property (strong, nonatomic)    User_Base *userBase;

@end
