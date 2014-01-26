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
    countDownView = [[RORCountDownCoverView alloc]initWithFrame:self.view.frame];
    [countDownView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin];
    [self.view addSubview:countDownView];
    [countDownView hide];
    
    srand(time(NULL));
    int randomValue = rand();
    if (randomValue%100<20)
        sound = [[RORPlaySound alloc]initForPlayingSoundEffectWith:@"all_set.mp3"];
    else
        sound = [[RORPlaySound alloc]initForPlayingSoundEffectWith:@"all_set_gun.mp3"];
    
    lastKiloPlayed = NO;
    lastHundredPlayed = NO;
    
    routes = [[NSMutableArray alloc]init ];
    [self resetRoutePoints];
    
    kmCounter = 0;
    avgSpeedPerKMList = [[NSMutableArray alloc]init];
    timeOfLatest1KM = 0;
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
    timeOfLatest1KM +=TIMER_INTERVAL;
}

-(void)timerSecondDot{
    
}

-(void)pushAvgSpeedPerKM{
    if (((int)distance/1000) > avgSpeedPerKMList.count){
        [avgSpeedPerKMList addObject:[NSNumber numberWithDouble:timeOfLatest1KM]];
//        //debug
//        NSLog(@"第%d km用时:%.2f,平均速度为:%@", avgSpeedPerKMList.count, timeOfLatest1KM, [avgSpeedPerKMList objectAtIndex:avgSpeedPerKMList.count-1]);
        
        timeOfLatest1KM = 0;
    }
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
//    if (locationManager == nil)
//        locationManager = [[CLLocationManager alloc]init];
//    locationManager.delegate = self;
    
//    [locationManager setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
//    locationManager.distanceFilter = 1;
//    NSLog(@"%u %c",[CLLocationManager  authorizationStatus],[CLLocationManager  locationServicesEnabled]);
//    if (! ([CLLocationManager  locationServicesEnabled])
//        || ( [CLLocationManager  authorizationStatus] == kCLAuthorizationStatusDenied))
//    {
//        [self sendAlart:GPS_SETTING_ERROR];
//        return;
//    }
//    else{
//        // start the compass
//        [locationManager startUpdatingLocation];
//    }
//    
//	if ([CLLocationManager headingAvailable] == NO) {
//		// No compass is available. This application cannot function without a compass,
//        // so a dialog will be displayed and no magnetic data will be measured.
//        NSLog(@"Magnet is not available.");
//	} else {
//        // heading service configuration
//        locationManager.headingFilter = kCLHeadingFilterNone;
//        
//        [locationManager startUpdatingHeading];
//    }
}

- (void)initOffset:(MKUserLocation *)userLocation{
    CLLocation *cl = [locationManager location];
    offset.latitude = userLocation.coordinate.latitude - cl.coordinate.latitude;
    offset.longitude = userLocation.coordinate.longitude - cl.coordinate.longitude;
}

- (CLLocation *)transToRealLocation:(CLLocation *)orginalLocation{
    CLLocation *absoluteLocation = [[CLLocation alloc] initWithLatitude:orginalLocation.coordinate.latitude + offset.latitude longitude:orginalLocation.coordinate.longitude + offset.longitude];
    return absoluteLocation;
}

-(CLLocation *)getNewRealLocation{
    return [self transToRealLocation:[locationManager location]];
}

-(NSNumber *)calculateCalorie
{
    double weight = [RORUserUtils getUserWeight].doubleValue; //tempory value
//    double K = (9*distance)/(2*duration);
    return [NSNumber numberWithDouble:(distance * weight * 1.036 / 1000)];
}

-(NSNumber *)calculateExperience:(User_Running_History *)runningHistory{
    if (!runningHistory.valid.boolValue)
        return [NSNumber numberWithDouble:0.f];
    
    return [NSNumber numberWithDouble:(runningHistory.distance.doubleValue/1000*200)];
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

- (void)stopUpdates
{
    if ([motionManager isDeviceMotionActive] == YES) {
        [motionManager stopDeviceMotionUpdates];
    }
//    locationManager.delegate = nil;
//    [locationManager stopUpdatingLocation];
//    [locationManager stopUpdatingHeading];
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
    
//	//may cause megnet calibrating operation application
//    if (motionManager.isMagnetometerAvailable){
//        [motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXTrueNorthZVertical];
//        //        [motionManager startAccelerometerUpdates];
//        NSLog(@"start updating device motion using X true north Z vertical reference frame.");
//    } else {
//        [motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryZVertical];
//        //        [motionManager startAccelerometerUpdates];
//        NSLog(@"start updating device motion using Z vertical reference frame.");
//    }
    
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

//#pragma CLLocationManager Delegate
//
//- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
//{
//    if([newLocation.timestamp timeIntervalSinceNow] <= (60 * 2)){
//        if (!wasFound){
//            wasFound = YES;
//        }
//    }
//}
//
//- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
//{
//    
//}


@end
