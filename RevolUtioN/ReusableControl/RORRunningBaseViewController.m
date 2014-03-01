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
    
    //初始化事件列表
    eventWillList = [RORSystemService fetchAllActionDefine:ActionDefineRun];
    eventHappenedList = [[NSMutableArray alloc]init];
    eventTimeList = [[NSMutableArray alloc]init];
    
    currentStep = 0;
    eventHappenedCount = 0;
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

//initial all when view appears
- (void)viewDidAppear:(BOOL)animated{
    if (![RORNetWorkUtils getIsConnetioned]){
        isNetworkOK = NO;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"网络连接错误" message:@"定位精度将受到严重影响，本次跑步将不能获得相应奖励，请检查相关系统设置。  （小声的：启动数据网络可以大大提高定位精度与速度，同时只会产生极小的流量。）" delegate:self cancelButtonTitle:@"知道呢！" otherButtonTitles:nil];
        [alertView show];
        alertView = nil;
    }
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
    user = [RORUserServices fetchUser:[RORUserUtils getUserId]];
    double health = user.userDetail.health.integerValue;
    double stepsPerFat = (100.f-health)/100.f*500 + 750;
    return [NSNumber numberWithDouble:-currentStep / stepsPerFat];
}

-(NSNumber *)calculateHealth{
    double fat = user.userDetail.fatness.integerValue;
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
//    NSNumber *lastEventTime = [eventTimeList objectAtIndex:eventTimeList.count-1];
//    if (duration - lastEventTime.doubleValue < 5)
//        return;
    
    for (int i=0; i<eventWillList.count; i++){
        Action_Define *event = (Action_Define *)[eventWillList objectAtIndex:i];
        int x = arc4random() % 1000000;
        double roll = ((double)x)/10000.f;
        if (roll < event.triggerProbability.doubleValue){//debug
            [self eventDidHappened:event];
            return;
        }
    }
}

-(void)eventDidHappened:(Action_Define *)event{
    [eventHappenedList addObject:event];
    [eventTimeList addObject: [NSNumber numberWithInteger:duration]];
    [eventLocationList addObject:[NSString stringWithFormat:@"%f,%f", formerLocation.coordinate.latitude, formerLocation.coordinate.longitude]];
    
    [allInOneSound addFileNametoQueue:[RORVirtualProductService getSoundFileOf:event]];
    [allInOneSound play];
}


@end
