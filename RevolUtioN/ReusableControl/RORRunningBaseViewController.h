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


#define TIMER_INTERVAL delta_T
#define MIN_PUSHPOINT_DISTANCE 5

@interface RORRunningBaseViewController : RORViewController{
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
    
    RORCountDownCoverView *countDownView;
    RORPlaySound *sound;
    RORPlaySound *lastHundred;
    RORPlaySound *lastKilo;
    
    BOOL lastHundredPlayed;
    BOOL lastKiloPlayed;
    BOOL last5MinPlayed;
    
    CLLocation *formerCenterMapLocation;
    
    NSTimeInterval updatingStartime;
    
    NSMutableArray *routes;
    NSMutableArray *routePoints;
    MKPolyline *routeLine;
    
    NSMutableArray *avgSpeedPerKMList;
    double timeOfLatest1KM;
    int kmCounter;
    
    NSTimer *repeatingTimer;
    BOOL isStarted;
}

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (strong, nonatomic) CMMotionManager *motionManager;

@property (strong, nonatomic) INKalmanFilter *kalmanFilter;

- (void)initOffset:(MKUserLocation *)userLocation;
-(CLLocation *)getNewRealLocation;
-(NSNumber *)calculateCalorie;
-(NSNumber *)calculateExperience:(User_Running_History *)runningHistory;
-(NSNumber *)calculateScore:(User_Running_History *)runningHistory;
- (void)stopUpdates;
- (void)inertiaNavi;
- (void)initNavi;
- (void)startDeviceMotion;
-(NSNumber *)isValidRun:(NSInteger)steps;
-(void)timerDotCommon;
-(void)timerSecondDot;
-(void)pushAvgSpeedPerKM;

//reset route points after pause
-(void)resetRoutePoints;

-(void)stopTimer;
@end
