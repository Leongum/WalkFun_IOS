//
//  RORRunningBaseViewController.h
//  RevolUtioN
//
//  Created by Bjorn on 13-9-11.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RORMapPoint.h"
#import "User_Running_History.h"
#import "RORAppDelegate.h"
#import "RORMapAnnotation.h"
#import "RORUserUtils.h"
#import "RORDBCommon.h"
#import "RORMacro.h"
#import "RORMissionServices.h"
#import "RORRunHistoryServices.h"
#import "RORUserServices.h"
#import "RORNetWorkUtils.h"
#import "INTimeWindow.h"
#import "INKalmanFilter.h"
#import "INStepCounting.h"
#import "RORViewController.h"
#import "Mission.h"
#import "RORCountDownCoverView.h"
#import "RORMultiPlaySound.h"
#import "RORVirtualProductService.h"
#import "RORLocationUtils.h"

#define TIMER_INTERVAL delta_T
#define MIN_PUSHPOINT_DISTANCE 5

typedef struct {
    double east, west, south, north;
} DirectionMovement;

@interface RORRunningBaseViewController : RORViewController<CLLocationManagerDelegate>{
    BOOL wasFound;
    BOOL isNetworkOK;
    double duration; // seconds
    double distance;
    double timeFromLastLocation;
    double currentSpeed;
    CLLocationManager *locationManager;
    CMMotionManager *motionManager;
    CLLocationCoordinate2D offset;
    CLLocation *formerLocation;
    CLLocation *latestUserLocation;
    vec_3 OldVn;
    INStepCounting *stepCounting;
    NSInteger currentStep;
    DirectionMovement directionMoved;
    
    RORMultiPlaySound *allInOneSound;
    
    CLLocation *formerCenterMapLocation;
    
    NSTimeInterval updatingStartime;
    
    NSMutableArray *routes;
    NSMutableArray *routePoints;
    MKPolyline *routeLine;
    
    //事件列表
    NSArray *eventWillList;
    Action_Define *goldAction;
    Action_Define *tiredAction;
    NSMutableArray *eventHappenedList;
    NSMutableArray *eventSaveList;
    NSMutableArray *eventDisplayList;
    NSInteger eventHappenedCount;
    int goldCount, itemCount, fightCount, stepsSinceLastFight;
    NSIndexPath *bottomIndex;
    
    NSTimer *repeatingTimer;
    BOOL isStarted;
    BOOL isAWalking;
    
    User_Base *userBase;
    
    Mission *todayMission;
    int cMissionItemQuantity;
}

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (strong, nonatomic) CMMotionManager *motionManager;

@property (strong, nonatomic) INKalmanFilter *kalmanFilter;

-(CLLocation *)getNewRealLocation;
-(NSNumber *)calculateCalorie;
-(NSNumber *)calculateExperience:(User_Running_History *)runningHistory;
-(NSNumber *)calculateScore:(User_Running_History *)runningHistory;
-(NSNumber *)calculateFatness;
-(NSNumber *)calculateHealth;

- (void)stopUpdates;
- (void)inertiaNavi;
- (void)initNavi;
- (void)startDeviceMotion;
-(NSNumber *)isValidRun:(NSInteger)steps;
-(void)timerDotCommon;
-(void)timerSecondDot;

//reset route points after pause
-(void)resetRoutePoints;

-(void)stopTimer;
@end
