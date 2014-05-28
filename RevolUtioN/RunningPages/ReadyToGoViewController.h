//
//  ReadyToGoViewController.h
//  WalkFun
//
//  Created by Bjorn on 14-3-25.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "RORViewController.h"
#import "CoverView.h"
#import "RORMissionServices.h"

@interface ReadyToGoViewController : RORViewController{
    UIStoryboard *mainStoryboard;
    BOOL isSucceeded;
    Virtual_Product *todayItem;
    User_Base *userBase;
    
    int fightAdded, powerAdded;
    
    InstructionCoverView *startInstruction;
}

@property (strong, nonatomic)Virtual_Product *selectedItem;
@property (strong, nonatomic)User_Base *selectedFriend;


@property (strong, nonatomic) IBOutlet UILabel *baseFightLabel;
@property (strong, nonatomic) IBOutlet UILabel *basePowerLabel;
@property (strong, nonatomic) IBOutlet UILabel *extraFightLabel;
@property (strong, nonatomic) IBOutlet UILabel *extraPowerLabel;

@property (strong, nonatomic) IBOutlet UIButton *cancelBuffButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelFriendButton;
@property (strong, nonatomic) IBOutlet UIImageView *itemImage;

@property (strong, nonatomic) IBOutlet UILabel *itemLabel;
@property (strong, nonatomic) IBOutlet UILabel *friendLabel;

@property (strong, nonatomic) IBOutlet UIView *itemView;
@property (strong, nonatomic) IBOutlet UIView *friendView;

@property (strong, nonatomic) IBOutlet RORNormalButton *startButton;
@end
