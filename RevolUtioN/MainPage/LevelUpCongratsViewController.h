//
//  LevelUpCongratsViewController.h
//  WalkFun
//
//  Created by Bjorn on 14-3-4.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RORUserServices.h"

@interface LevelUpCongratsViewController : UIViewController{
    User_Base *userBase;
}

@property (strong, nonatomic) IBOutlet UILabel *levelLabe;
@property (strong, nonatomic) IBOutlet UILabel *oldGoldLabel;
@property (strong, nonatomic) IBOutlet UILabel *nExtraGoldLabel;

-(void)inputOldGold:(double)oldGold NewGold:(double)newGold andLevel:(NSInteger)level;


@end
