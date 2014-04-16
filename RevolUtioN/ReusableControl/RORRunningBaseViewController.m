//
//  RORRunningBaseViewController.m
//  RevolUtioN
//
//  Created by Bjorn on 13-9-11.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORRunningBaseViewController.h"

@interface RORRunningBaseViewController ()

@end

@implementation RORRunningBaseViewController
@synthesize locationManager, motionManager;

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
    [self initThings];
}

-(void)initThings{
    isNetworkOK = YES;
    wasFound = NO;
    offset.latitude = 0;
    offset.longitude = 0;
    
//    CGRect rx = self.view.frame;//[ UIScreen mainScreen ].applicationFrame;

    //初始化声音队列
    allInOneSound = [[RORMultiPlaySound alloc] init];
    
    //初始化路线列表
    routes = [[NSMutableArray alloc]init ];
    [self resetRoutePoints];
    
    userBase = [RORUserServices fetchUser:[RORUserUtils getUserId]];
    
    //初始化事件列表
    eventWillList = [RORSystemService fetchAllActionDefine:ActionDefineRun];
    for (int i=0; i<eventWillList.count; i++){
        Action_Define *event = (Action_Define *)[eventWillList objectAtIndex:i];
        if (event.triggerProbability.integerValue<0){
            tiredAction = event;
        }
        if ([event.actionName rangeOfString:@"金币"].location != NSNotFound){
            goldAction = event;
        }
    }
    eventHappenedList = [[NSMutableArray alloc]init];
    eventDisplayList = [[NSMutableArray alloc]init];
    eventSaveList = [[NSMutableArray alloc]init];
    
    currentStep = 0;
    eventHappenedCount = 0;
    goldCount = 0;
    itemCount = 0;
    fightCount = 0;
    stepsSinceLastFight = 0;
    
    directionMoved.east = 0;
    directionMoved.west = 0;
    directionMoved.south = 0;
    directionMoved.north = 0;
}

-(void)viewDidUnload{
    [super viewDidUnload];
    [self stopUpdates];
}

-(void)viewWillDisappear:(BOOL)animated{
//    [self stopUpdates];
}

- (void)awakeFromNib{
    [self startDeviceLocation];
}


-(void)resetRoutePoints{
    if (routePoints) {
        [routes addObject:routePoints];
    }
    routePoints = [[NSMutableArray alloc]init];
}

-(void)timerDotCommon{
}

-(void)timerSecondDot{
    
}

-(void)stopTimer{
    [repeatingTimer invalidate];
    repeatingTimer = nil;
    isStarted = NO;
    [self resetRoutePoints];
    routeLine = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startDeviceLocation{
    locationManager = [(RORAppDelegate *)[[UIApplication sharedApplication] delegate] sharedLocationManager];
}

-(CLLocation *)getNewRealLocation{
    CLLocationCoordinate2D newCoor = [RORLocationUtils transformFromWGSToGCJ:[locationManager location].coordinate];
    return [[CLLocation alloc]initWithLatitude:newCoor.latitude longitude:newCoor.longitude];
}

-(NSNumber *)calculateCalorie
{
    double weight = [RORUserUtils getUserWeight].doubleValue; //tempory value
//    double K = (9*distance)/(2*duration);
    return [NSNumber numberWithDouble:(distance * weight * 1.036 / 1000)];
}

-(NSNumber *)calculateExperience:(User_Running_History *)runningHistory{
//    if (!runningHistory.valid.boolValue)
//        return [NSNumber numberWithDouble:0.f];
    return [NSNumber numberWithDouble:(runningHistory.steps.doubleValue/1000*200)];
}

-(NSNumber *)calculateScore:(User_Running_History *)runningHistory{
    if (!runningHistory.valid.boolValue)
        return [NSNumber numberWithDouble:0.f];
    
    double scape = runningHistory.duration.doubleValue;
    double scores = 0;
    if(scape != 0){
        scores = runningHistory.avgSpeed.doubleValue * runningHistory.distance.doubleValue / 1000;
    }
    return [NSNumber numberWithDouble:scores];
}

-(NSNumber *)calculateFatness{
    if (fightCount==0){
        return [NSNumber numberWithInt:0];
    }
    userBase = [RORUserServices fetchUser:[RORUserUtils getUserId]];
//    double health = 100;
    //现在是250步减一点肥肉
    double stepsPerFat = 250;// (100.f-health)/100.f*500 + 750;
    return [NSNumber numberWithDouble:-currentStep / stepsPerFat];
}

-(NSNumber *)calculateHealth{
    double fat = userBase.userDetail.fatness.integerValue;
    double stepsPerHealth = fat/100.f*500 + 750;
    return [NSNumber numberWithDouble:-currentStep / stepsPerHealth];

}

- (void)stopUpdates
{
    if ([motionManager isDeviceMotionActive] == YES) {
        [motionManager stopDeviceMotionUpdates];
    }
}

- (void)initNavi{
    OldVn.v1 = 0;
    OldVn.v2 = 0;
    OldVn.v3 = 0;
        
    //    init kalman filter
    //    kalmanFilter = [[INKalmanFilter alloc]initWithCoordinate:[locationManager location].coordinate];
    
    stepCounting = [[INStepCounting alloc]init];
    timeFromLastLocation = 0;
    
    currentSpeed = 0.f;
}

- (void)inertiaNavi{
    timeFromLastLocation += delta_T;

    CMDeviceMotion *deviceMotion = motionManager.deviceMotion;
    INDeviceStatus *newDeviceStatus = [[INDeviceStatus alloc]initWithDeviceMotion:deviceMotion];
    //    newDeviceStatus.timeTag = timeCounter;
//    newDeviceStatus.timeTag = timerCount;

    //step counting
    [stepCounting pushNewLAcc:[INMatrix modOfVec_3:newDeviceStatus.an] GAcc:newDeviceStatus.an.v3 speed:currentSpeed];
    if (stepCounting.counter>currentStep) {
        currentStep = stepCounting.counter;
        //debug
//        if (isAWalking)
            [self isEventHappen];
    }
}

- (void)startDeviceMotion
{
    //	motionManager = [[CMMotionManager alloc] init];
	// Tell CoreMotion to show the compass calibration HUD when required to provide true north-referenced attitude
    motionManager = [(RORAppDelegate *)[[UIApplication sharedApplication] delegate] sharedMotionManager];

	motionManager.showsDeviceMovementDisplay = YES;
    
	motionManager.deviceMotionUpdateInterval = delta_T;
    motionManager.accelerometerUpdateInterval = delta_T;
	
    [motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryZVertical];
}

-(NSNumber *)isValidRun:(NSInteger)steps {
    if (!isNetworkOK)
        return [NSNumber numberWithInteger:-2];
    
    double avgStepDistance = distance / steps;
    double avgStepFrequency = steps * 60 / duration ;
//    if (distance/duration < 2)
//        return [NSNumber numberWithInteger:1];
    if (avgStepFrequency < 40 || avgStepFrequency > 240 || avgStepDistance < 0.2 || avgStepDistance > 4)
        return [NSNumber numberWithInteger:-1];
    return [NSNumber numberWithInteger:1];
}


#pragma mark - Event Methods

//如果触发了事件，返回事件，否则返回nil
-(void)isEventHappen{

}


@end
