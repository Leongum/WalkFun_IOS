//
//  FriendInfoViewController.h
//  WalkFun
//
//  Created by Bjorn on 14-2-21.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "RORViewController.h"
#import "RORUserServices.h"
#import "RORRunHistoryServices.h"
#import "KSLabel.h"
#import "CUSFlashLabel.h"

@interface FriendInfoViewController : RORViewController{
    UIViewController *charatorViewController;
    
    Simple_User_Run_History *latestWorkout;
    Action *latestFriendAction;
}

@property (strong, nonatomic) IBOutlet UIView *charatorView;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *levelLabel;
@property (strong, nonatomic) IBOutlet KSLabel *latestWorkoutDateLabel;
@property (strong, nonatomic) IBOutlet KSLabel * latestFriendActionDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *latestFriendActionDescriptionLabel;
@property (strong, nonatomic) IBOutlet BadgeView *badgeView;

@property (strong, nonatomic) IBOutlet CUSFlashLabel *loadingLabel;

@property (strong, nonatomic) User_Base *userBase;
@end
