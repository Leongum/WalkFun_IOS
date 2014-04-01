//
//  LevelUpCongratsViewController.h
//  WalkFun
//
//  Created by Bjorn on 14-3-4.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RORUserServices.h"
#import "PooViewController.h"
#import "StrokeLabel.h"

@interface LevelUpCongratsViewController : PooViewController{
    User_Base *userBase;
}

@property (strong, nonatomic) IBOutlet UILabel *levelLabe;
@property (strong, nonatomic) IBOutlet UILabel *fightLabel;
@property (strong, nonatomic) IBOutlet StrokeLabel *titleLabel;

@property (strong, nonatomic) IBOutlet UIImageView *congratsBg;

-(void)inputOldFight:(int)oldfight NewFight:(int)newFight andLevel:(int)level;


@end
