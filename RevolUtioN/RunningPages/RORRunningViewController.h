//
//  RORGetReadyViewController.h
//  RevolUtioN
//
//  Created by Beyond on 13-5-16.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "User_Running_History.h"
#import "INTimeWindow.h"
#import "INKalmanFilter.h"
#import "INStepCounting.h"
#import "RORViewController.h"
#import "Mission.h"
#import "RORRunningBaseViewController.h"
#import "THProgressView.h"
#import "StrokeLabel.h"
#import "FightIconButton.h"

#define WALKING_FIGHT_STAGE_I 200
#define WALKING_FIGHT_STAGE_II 0
//#define WALKING_FIGHT_STAGE_II 200
#define WALKING_FIGHT_STAGE_III 600
#define WALKING_FIGHT_STAGE_IV 1000
#define WALKING_FIGHT_STAGE_V 2200

#define WALKING_FIGHT_POWERLIMIT_V 40

@interface RORRunningViewController : RORRunningBaseViewController {
    BOOL MKwasFound;
    User_Running_History *runHistory;
    int newCellHeight;
    
    BOOL collectingCoin;
    NSMutableDictionary *todayMissionDict;
    NSMutableArray *processViewList;
    
    NSInteger userPower, userPowerMax, fightPowerCost;
    double userFight;
    NSInteger walkExperience;
    
    THProgressView *powerPV;
    
    User_Base *thisWalkFriend;
    NSInteger friendAddFight;
    
    int friendFightStep;
    BOOL didFriendFight;
    NSArray *followList;
    
    InstructionCoverView *instruction;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *endButton;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *goldLabel;
@property (strong, nonatomic) IBOutlet UIImageView *goldIcon;
@property (strong, nonatomic) IBOutlet StrokeLabel *itemLabel;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet UIView *dataContainer;
@property (strong, nonatomic) IBOutlet UIView *todayMissionView;
@property (strong, nonatomic) IBOutlet StrokeLabel *powerFrame;
@property (strong, nonatomic) IBOutlet UILabel *fightLabel;
@property (strong, nonatomic) IBOutlet UILabel *friendLabel;

@property (nonatomic) vec_3 inDistance;

@property (nonatomic) NSInteger timerCount;

@property (retain, nonatomic) MKPolylineView *routeLineView;
@property (retain, nonatomic) MKPolylineView *routeLineShadowView;
@property (strong, nonatomic) MKPolyline *routeLineShadow;

@property (strong, nonatomic) NSDate *startTime;
@property (strong, nonatomic) NSDate *endTime;
@property (strong, nonatomic) User_Running_History* record;

//@property (strong, nonatomic) Mission *runMission;
@property (weak, nonatomic) IBOutlet UIControl *coverView;
@property (strong, nonatomic) IBOutlet UIView *paperView;


- (IBAction)startButtonAction:(id)sender;
- (IBAction)endButtonAction:(id)sender;

- (IBAction)btnCoverInside:(id)sender;
- (IBAction)btnSaveRun:(id)sender;
- (IBAction)btnDeleteRunHistory:(id)sender;
- (void)saveRunInfo;
-(void)creatRunningHistory;

@end
