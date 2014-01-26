//
//  RORStatisticsViewController.h
//  RevolUtioN
//
//  Created by Bjorn on 13-8-19.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RORRunHistoryServices.h"
#import "RORPageViewController.h"
#import "RORFiveCounterView.h"

@interface RORStatisticsViewController : RORPageViewController{
    double totalDistance, avgSpeed, totalCalorie, totalChallengeNum;
    int challengeCounter[7];
    RORFiveCounterView *counterView[6];
}

@property (strong, nonatomic) IBOutlet UILabel *noHistoryMsgLabel;

@property (strong, nonatomic) NSMutableArray *filter;
@property (strong, nonatomic) IBOutlet UILabel *totalDistanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalSpeedLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalCalorieLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *containerView;
@property (strong, nonatomic) IBOutlet UILabel *totalChallenge;
@property (strong, nonatomic) IBOutlet UIView *challengeStatisView;
@property (strong, nonatomic) IBOutlet UILabel *totalTraining;


@end
