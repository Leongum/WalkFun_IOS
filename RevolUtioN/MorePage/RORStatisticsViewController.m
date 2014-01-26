//
//  RORStatisticsViewController.m
//  RevolUtioN
//
//  Created by Bjorn on 13-8-19.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORStatisticsViewController.h"
#import "RORHistoryPageViewController.h"

@interface RORStatisticsViewController ()

@end

@implementation RORStatisticsViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    [RORUtils setFontFamily:CHN_PRINT_FONT forView:self.view andSubViews:YES];
    
//    [self.totalDistanceLabel setFont:[UIFont fontWithName:ENG_WRITTEN_FONT size:28]];
//    [self.totalSpeedLabel setFont:[UIFont fontWithName:ENG_WRITTEN_FONT size:28]];
//    [self.totalCalorieLabel setFont:[UIFont fontWithName:ENG_WRITTEN_FONT size:28]];
//    [RORUtils setFontFamily:ENG_WRITTEN_FONT forView:self.totalChallenge andSubViews:NO];
    
//    [self initChallengeTable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initTableData];
}

-(void)initTableData{
    totalCalorie = 0;
    totalDistance = 0;  
    avgSpeed = 0;
    totalChallengeNum = 0;
    for (int i=0; i<7; i++)
        challengeCounter[i] = 0;
    
    NSMutableArray *filter = ((RORHistoryPageViewController*)[self parentViewController]).filter;
    
    //NSArray *fetchObject = [RORRunHistoryServices fetchRunHistory];

//    int counter = 0;
//    for (User_Running_History *historyObj in fetchObject) {
//        NSNumber *missionType = (NSNumber *)[historyObj valueForKey:@"missionTypeId"];
//        
//        if (![filter containsObject:missionType] || historyObj.valid.integerValue<0) {
//            continue;
//        }
//        totalDistance += historyObj.distance.doubleValue;
//        totalCalorie += historyObj.spendCarlorie.doubleValue;
//        avgSpeed += historyObj.avgSpeed.doubleValue;
//        counter ++;
//        if (historyObj.missionTypeId.integerValue == Challenge){
//            totalChallengeNum++;
//            challengeCounter[historyObj.missionGrade.integerValue]++;
//        }
//    }
//    avgSpeed/=counter;
//    
//    if ([filter containsObject:[NSNumber numberWithInteger:Challenge]]) {
//        self.challengeStatisView.alpha = 1;
////        [self fillChallengeTable];
//    } else
//        self.challengeStatisView.alpha = 0;
    
//    if (counter>0 && totalDistance >0){
//        [self showContents];
//        self.totalDistanceLabel.text = [RORUtils outputDistance:totalDistance];
//        self.totalSpeedLabel.text = [RORUserUtils formatedSpeed:avgSpeed];
//        self.totalCalorieLabel.text = [NSString stringWithFormat:@"%.0f kcal", totalCalorie];
//        self.totalChallenge.text = [NSString stringWithFormat:@"%.0f", totalChallengeNum];
//        
//    } else {
//        [self hideContents];
//        self.noHistoryMsgLabel.text = NO_HISTORY;
//    }
//    
////    self.distanceCommentLabel.text = STATISTICS_DISTANCE_MESSAGE([NSNumber numberWithDouble:totalDistance/1000]);
////    self.speedCommentLabel.text = STATISTICS_SPEED_MESSAGE([NSNumber numberWithDouble:avgSpeed]);
////    self.calorieCommentLabel.text = STATISTICS_CALORIE_MESSAGE([NSNumber numberWithDouble:totalCalorie]);
//    NSArray *historyList = [RORPlanService fetchUserPlanHistoryList:[RORUserUtils getUserId]];
//    int sum = 0;
//    for (Plan_Run_History *history in historyList){
//        sum += history.totalMissions.integerValue - history.remainingMissions.integerValue;
//    }
//    self.totalTraining.text = [NSString stringWithFormat:@"%d", sum];

}

//-(void)initChallengeTable{
//    for (int i=0; i<6; i++){
//        counterView[i] = (RORFiveCounterView *)[self.challengeStatisView viewWithTag:100+i];
//    }
//}

//-(void)fillChallengeTable{
//    for (int i=0; i<6; i++)
//        [counterView[i] setNewNumber:challengeCounter[i]];
//}

-(void)showContents{
    self.containerView.alpha = 1;
    
    self.noHistoryMsgLabel.alpha = 0;
//    [RORUtils setFontFamily:ENG_WRITTEN_FONT forView:self.totalSpeedLabel andSubViews:NO];
}

-(void)hideContents{
    self.containerView.alpha = 0;
    
//    [RORUtils setFontFamily:CHN_PRINT_FONT forView:self.totalSpeedLabel andSubViews:NO];
    
    self.noHistoryMsgLabel.alpha = 1;
}

- (void)viewDidUnload {
    [self setTotalDistanceLabel:nil];
    [self setTotalSpeedLabel:nil];
    [self setTotalCalorieLabel:nil];
    [self setContainerView:nil];
    [super viewDidUnload];
}
@end
