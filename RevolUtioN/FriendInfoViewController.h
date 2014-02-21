//
//  FriendInfoViewController.h
//  WalkFun
//
//  Created by Bjorn on 14-2-21.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "RORViewController.h"
#import "RORUserServices.h"

@interface FriendInfoViewController : RORViewController{

}

@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *levelLabel;
@property (strong, nonatomic) IBOutlet UILabel *fatLabel;
@property (strong, nonatomic) IBOutlet UILabel *healthLabel;
@property (strong, nonatomic) IBOutlet UILabel *durationLabel;
@property (strong, nonatomic) IBOutlet UILabel *stepsLabel;
@property (strong, nonatomic) IBOutlet UILabel *latestWorkoutDateLabel;

@property (strong, nonatomic) User_Base *userBase;
@end
