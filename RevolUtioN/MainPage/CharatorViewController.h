//
//  CharatorViewController.h
//  WalkFun
//
//  Created by Bjorn on 14-2-28.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#define ITEM_SIZE_MAX 30
#define ITEM_SIZE_MIN 20
#define ONFACE_SIZE 20

#import "RORViewController.h"
#import "RORVirtualProductService.h"
#import "THProgressView.h"
#import "UIUtils.h"

@interface CharatorViewController : UIViewController{
    UIView *onFaceView, *frontCharatorView, *flowContainerView;
    UIImageView *charatorImageView, *charatorBumpImageView, *maleGrassImageView;
    UILabel *fatPVFrameView, *fightPVFrameView;
    THProgressView *fatPV, *fightPV;

    NSDictionary *itemForDisplayDict;
    BOOL haveBump;
    int faceColorIndex;
    
    int GROUND_SIZE_WIDTH, FACE_HEIGHT,FACE_WIDTH, FRONT_HEIGHT, VASE_SIZE_WIDTH, VASE_SIZE_HEIGHT;
}

@property (strong, nonatomic)    User_Base *userBase;

@end
