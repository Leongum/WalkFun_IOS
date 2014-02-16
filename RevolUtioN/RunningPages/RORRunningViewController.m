//
//  RORGetReadyViewController.m
//  RevolUtioN
//
//  Created by Beyond on 13-5-16.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORRunningViewController.h"

#define SCALE_SMALL CGRectMake(50,70,220,188)


@interface RORRunningViewController ()

@end

@implementation RORRunningViewController
//@synthesize locationManager, motionManager;
@synthesize timerCount;
@synthesize timeLabel, speedLabel, distanceLabel, startButton, endButton;
@synthesize routeLineView;
@synthesize record;
@synthesize doCollect;
@synthesize kalmanFilter, inDistance;
@synthesize mapView, coverView;

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
//    [RORUtils setFontFamily:ENG_PRINT_FONT forView:self.dataContainer andSubViews:YES];
}

//initial all when view appears
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self controllerInit];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
//        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)controllerInit{
    self.coverView.alpha = 0;
    self.backButton.alpha = 0;
    
    self.mapView.delegate = self;
    
    [self.startButton setEnabled:NO];
    [startButton setTitle:SEARCHING_LOCATION forState:UIControlStateNormal];
    UIImage *image = [UIImage imageNamed:@"green_btn_bg.png"];
    [startButton setBackgroundImage:image forState:UIControlStateNormal];
    
    image = [UIImage imageNamed:@"redbutton_bg.png"];
    [endButton setBackgroundImage:image forState:UIControlStateNormal];
    [endButton setTitle:CANCEL_RUNNING_BUTTON forState:UIControlStateNormal];
    [endButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
//    collapseButton.alpha = 0;
    
    timeLabel.text = [RORUtils transSecondToStandardFormat:0];
    speedLabel.text = [RORUserUtils formatedSpeed:0];
    distanceLabel.text = [RORUtils outputDistance:0];
//    self.stepLabel.text = @"0";
//    mapView.frame = SCALE_SMALL;
    
    doCollect = NO;
    
    routePoints = [[NSMutableArray alloc]init];
    
//    self.saveButton.delegate = self;
}

-(void)navigationInit{
    //    [mapView setUserTrackingMode:MKUserTrackingModeFollow];
    [mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    [mapView removeOverlays:[mapView overlays]];

    MKwasFound = NO;
    timerCount = 0;
    distance = 0;
    isStarted = NO;
}

-(void)LogDeviceStatus{
    // 加速度器的检测
    if ([motionManager isAccelerometerAvailable]){
        NSLog(@"Accelerometer is available.");
    } else{
        NSLog(@"Accelerometer is not available.");
    }
    if ([motionManager isAccelerometerActive]){
        NSLog(@"Accelerometer is active.");
    } else {
        NSLog(@"Accelerometer is not active.");
    }
    
    // 陀螺仪的检测
    if([motionManager isGyroAvailable]){
        NSLog(@"Gryro is available.");
    } else {
        NSLog(@"Gyro is not available.");
    }
    if ([motionManager isGyroActive]){
        NSLog(@"Gryo is active.");
        
    } else {
        NSLog(@"Gryo is not active.");
    }
    
    // deviceMotion的检测
    if([motionManager isDeviceMotionAvailable]){
        NSLog(@"DeviceMotion is available.");
    } else {
        NSLog(@"DeviceMotion is not available.");
    }
    if ([motionManager isDeviceMotionActive]){
        NSLog(@"DeviceMotion is active.");
        
    } else {
        NSLog(@"DeviceMotion is not active.");
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)awakeFromNib {
    [super awakeFromNib];
    [self navigationInit];
}

////center the map to userLocation of MKMapView
- (IBAction)center_map:(id)sender{
    CLLocation *loc = [mapView userLocation].location;
    float zoomLevel = 0.005;
    MKCoordinateRegion region = MKCoordinateRegionMake(loc.coordinate, MKCoordinateSpanMake(zoomLevel, zoomLevel));
    [mapView setRegion:[mapView regionThatFits:region] animated:NO];

}

-(void)createAnnotationWithCoords:(CLLocationCoordinate2D) coords withTitle:(NSString *)title andSubTitle:(NSString *) subTitle {
    RORMapAnnotation *annotation = [[RORMapAnnotation alloc] initWithCoordinate:
                                    coords];
    annotation.title = title;
    annotation.subtitle = subTitle;
    [mapView addAnnotation:annotation];
}

- (void)viewDidUnload {
    [self setMapView:nil];
    [self setDistanceLabel:nil];
    [self setTimeLabel:nil];
    [self setSpeedLabel:nil];
    [self setStartButton:nil];
    [self setEndButton:nil];
    [self setRouteLineView:nil];
    [self setStartTime:nil];
    [self setEndTime:nil];
    [self setRecord:nil];
    
    [self setCoverView:nil];
    [self setSaveButton:nil];
    [self setDataContainer:nil];
    [super viewDidUnload];
}

//- (IBAction)expandAction:(id)sender {
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
//    [UIView setAnimationDuration:0.6];
//    
//    expandButton.alpha = 0;
//    collapseButton.alpha = 0.7;
//    mapView.frame = [ UIScreen mainScreen ].bounds;
//    
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDidStopSelector:@selector(animationFinished)];
//    [UIView commitAnimations];
//    
//}
//
//- (IBAction)collapseAction:(id)sender {
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
//    [UIView setAnimationDuration:0.3];
//    
//    collapseButton.alpha = 0;
//    expandButton.alpha = 0.7;
//    mapView.frame = SCALE_SMALL;
//    
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDidStopSelector:@selector(animationFinished)];
//    [UIView commitAnimations];
//    
//}


- (IBAction)startButtonAction:(id)sender {
    if (!isStarted){
        isStarted = YES;
        if (self.startTime == nil){
            self.startTime = [NSDate date];
            
            [(RORAppDelegate *)[[UIApplication sharedApplication] delegate] setRunningStatus:YES];
            
//            [[UIApplication sharedApplication] setIdleTimerDisabled: YES];

            [endButton setTitle:FINISH_RUNNING_BUTTON forState:UIControlStateNormal];
            [endButton removeTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
            [endButton addTarget:self action:@selector(endButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            //init inertia navigation
            [self initNavi];
            
            [self startDeviceMotion];
            
            //the first point after started
            [self initOffset:[mapView userLocation]];
                        //            [self pushPoint];
            [sound play];
            [countDownView show];
        }
        //init former location
        latestUserLocation = [self getNewRealLocation];
        formerLocation = latestUserLocation;
        [routePoints addObject:formerLocation];
        [self drawLineWithLocationArray:routePoints];
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(timerDot) userInfo:nil repeats:YES];
        repeatingTimer = timer;
        
        UIImage *image = [UIImage imageNamed:@"redbutton_bg.png"];
        [startButton setBackgroundImage:image forState:UIControlStateNormal];
        [startButton setTitle:PAUSSE_RUNNING_BUTTON forState:UIControlStateNormal];
        [endButton setEnabled:YES];
    } else {
        [self stopTimer];
        UIImage *image = [UIImage imageNamed:@"green_btn_bg.png"];
        [startButton setBackgroundImage:image forState:UIControlStateNormal];
        [startButton setTitle:CONTINUE_RUNNING_BUTTON forState:UIControlStateNormal];
    }
    //    [[NSRunLoop  currentRunLoop] addTimer:myTimer forMode:NSDefaultRunLoopMode];
}

- (void)initNavi{
    [super initNavi];
    [mapView removeOverlays:[mapView overlays]];
}

- (void)inertiaNavi{
    [super inertiaNavi];
    
//    self.stepLabel.text = [NSString stringWithFormat:@"%d", stepCounting.counter];
//    self.avgTimePerStep.text = [NSString stringWithFormat:@"%.2f s", duration/((double)stepCounting.counter)];
//    self.avgDisPerStep.text = [NSString stringWithFormat:@"%.2f m", distance/((double)stepCounting.counter)];
}

- (void)timerDot{
    [self timerDotCommon];
    doCollect = YES;
    
    timerCount++;
    duration = timerCount * TIMER_INTERVAL;
    // currently, only do running status judgement here.
    [self inertiaNavi];
    
    NSInteger intTime = (NSInteger)duration;
    if (duration - intTime < 0.00001){ //1 second
        [self timerSecondDot];
    }

    timeLabel.text = [RORUtils transSecondToStandardFormat:duration];
}

-(void)timerSecondDot{
    [super timerSecondDot];
    [self pushPoint];
    distanceLabel.text = [RORUtils outputDistance:distance];
    speedLabel.text = [RORUserUtils formatedSpeed:(double)(currentSpeed*3.6)];
}

- (void)pushPoint{
    CLLocation *currentLocation = [self getNewRealLocation];
    double deltaDistance = [formerLocation distanceFromLocation:currentLocation];
//    NSLog(@"[%@, %@], delta_d = %f", formerLocation, currentLocation, deltaDistance);
    if (formerLocation != currentLocation && deltaDistance>MIN_PUSHPOINT_DISTANCE){
        //calculate real-time speed
        currentSpeed = deltaDistance / timeFromLastLocation;//[INDeviceStatus getSpeedVectorBetweenLocation1:formerLocation andLocation2:currentLocation deltaTime:timeFromLastLocation];
        timeFromLastLocation = 0;
        
        NSLog(@"%f",deltaDistance);
        distance += [formerLocation distanceFromLocation:currentLocation];
        formerLocation = currentLocation;
        
        [routePoints addObject:currentLocation];
        [self drawLineWithLocationArray:routePoints];
        
        //记录每KM平均速度
        [self pushAvgSpeedPerKM];
    }
}

- (IBAction)endButtonAction:(id)sender {
    [self stopTimer];

    [startButton setTitle:CONTINUE_RUNNING_BUTTON forState:UIControlStateNormal];
    
    if (distance > 30){
        [self.saveButton setEnabled:YES];
        [self.saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [self.saveButton setBackgroundImage:[UIImage imageNamed:@"running_end_bg.png"] forState:UIControlStateNormal];
    } else {
        [self.saveButton setEnabled:NO];
        [self.saveButton setTitle:@"你确定你跑了么？" forState:UIControlStateNormal];
        [self.saveButton setBackgroundImage:nil forState:UIControlStateNormal];
    }
    [Animations fadeIn:coverView andAnimationDuration:0.3 toAlpha:1 andWait:NO];
}

- (IBAction)btnCoverInside:(id)sender {
    [Animations fadeOut:coverView andAnimationDuration:0.3 fromAlpha:1 andWait:NO];
}

- (IBAction)btnSaveRunTouched:(id)sender {
    [self startIndicator:self];
}
- (IBAction)btnSaveRunTouchCanceled:(id)sender {
    [self endIndicator:self];
}

- (IBAction)btnSaveRun:(id)sender {

    [self stopUpdates];
    
    if (self.endTime == nil)
        self.endTime = [NSDate date];
//    [[UIApplication sharedApplication] setIdleTimerDisabled: NO];
//    [startButton setEnabled:NO];
    
    
    [self prepareForQuit];
    [self saveRunInfo];
//    [self endIndicator:self];
    [self performSegue];
    [self endIndicator:self];
}

-(void)performSegue{
    [self performSegueWithIdentifier:@"NormalRunResultSegue" sender:self];
}

-(void)prepareForQuit{
    [(RORAppDelegate *)[[UIApplication sharedApplication] delegate] setRunningStatus:NO];
    
    [repeatingTimer invalidate];
    repeatingTimer = nil;
}

- (IBAction)btnDeleteRunHistory:(id)sender {
    [self prepareForQuit];

    [self.navigationController popViewControllerAnimated:YES];
}

-(NSNumber *)calculateGrade{
    return [self calculateCalorie];
}

- (void)saveRunInfo{
    [self creatRunningHistory];
    
    [RORRunHistoryServices saveRunInfoToDB:runHistory];
    if([RORUserUtils getUserId].integerValue > 0){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            BOOL updated = [RORRunHistoryServices uploadRunningHistories];
            [RORUserServices syncUserInfoById:[RORUserUtils getUserId]];
            dispatch_async(dispatch_get_main_queue(), ^{
                if(updated){
                    [self sendSuccess:SYNC_DATA_SUCCESS];
                }
                else{
                    [self sendAlart:SYNC_DATA_FAIL];
                }
            });
        });
    }
}

-(void)creatRunningHistory{
    runHistory = [User_Running_History intiUnassociateEntity];
    runHistory.distance = [NSNumber numberWithDouble:distance];
    runHistory.duration = [NSNumber numberWithDouble:duration];
    runHistory.avgSpeed = [NSNumber numberWithDouble:(double)(distance/duration*3.6)];
    runHistory.valid = [self isValidRun:stepCounting.counter / 0.8];
    runHistory.missionRoute = [RORDBCommon getStringFromRoutes:routes];
//    NSLog(@"%@", [RORDBCommon getStringFromSpeedList:avgSpeedPerKMList]);
    
    runHistory.missionDate = [NSDate date];
    runHistory.missionEndTime = self.endTime;
    runHistory.missionStartTime = self.startTime;
    runHistory.userId = [RORUserUtils getUserId];
    runHistory.spendCarlorie = [self calculateCalorie];
    runHistory.runUuid = [RORUtils uuidString];
    runHistory.steps = [NSNumber numberWithInteger:stepCounting.counter / 0.8];
    runHistory.experience =[self calculateExperience:runHistory];
    runHistory.goldCoin =[self calculateScore:runHistory];
    runHistory.extraExperience =[NSNumber  numberWithDouble:0];
    runHistory.speedList = [RORDBCommon getStringFromSpeedList:avgSpeedPerKMList];
    
    if(runHistory.valid.integerValue != 1 || runHistory.userId.integerValue < 0){
        runHistory.experience =[NSNumber numberWithDouble:0];
        runHistory.goldCoin =[NSNumber  numberWithDouble:0];
    }
    
    NSLog(@"%@", runHistory);
    record = runHistory;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *destination = segue.destinationViewController;
    if ([destination respondsToSelector:@selector(setDelegate:)]){
        [destination setValue:self forKey:@"delegate"];
    }
    if ([destination respondsToSelector:@selector(setRecord:)]){
        [destination setValue:record forKey:@"record"];
    }
}

- (void)drawLineWithLocationArray:(NSArray *)locationArray
{
    //    [self updateLocation];
    if (routeLine!=nil){
        [mapView removeOverlay:routeLine];
    }
    
    int pointCount = [locationArray count];
    //debug
//    NSLog(@"%d", pointCount);
    CLLocationCoordinate2D *coordinateArray = (CLLocationCoordinate2D *)malloc(pointCount * sizeof(CLLocationCoordinate2D));
    
    for (int i = 0; i < pointCount; ++i) {
        CLLocation *location = [locationArray objectAtIndex:i];
        coordinateArray[i] = [location coordinate];
    }
    
    routeLine = [MKPolyline polylineWithCoordinates:coordinateArray count:pointCount];
//    self.routeLineShadow = [MKPolyline polylineWithCoordinates:coordinateArray count:pointCount];
    
    //    [mapView setVisibleMapRect:[routeLine boundingMapRect]];
//    [mapView addOverlay:self.routeLineShadow];
    [mapView addOverlay:routeLine];
    free(coordinateArray);
    coordinateArray = NULL;
}


#pragma mark - MKMapViewDelegate


-(void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (!MKwasFound){
        MKwasFound = YES;
        [self center_map:self];
        formerCenterMapLocation = [self getNewRealLocation];
        [startButton setTitle:START_RUNNING_BUTTON forState:UIControlStateNormal];
        [self.startButton setEnabled:YES];
    }
    if ([formerCenterMapLocation distanceFromLocation:[self getNewRealLocation]]>20){
        [self center_map:self];
        formerCenterMapLocation = [self getNewRealLocation];
        //to-do
    }
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    MKOverlayView* overlayView = nil;
    
    if(overlay == routeLine)
    {
        //if we have not yet created an overlay view for this overlay, create it now.
        //        if(nil == self.routeLineView)
        //        {
        self.routeLineView = [[MKPolylineView alloc] initWithPolyline:routeLine];
        //        self.routeLineView.fillColor = [UIColor colorWithRed:223 green:8 blue:50 alpha:1];
        self.routeLineView.strokeColor = [UIColor colorWithRed:(46.0/255.0) green:(170.0/255.0) blue:(218.0/255.0) alpha:1];
        self.routeLineView.lineWidth = 10;
        //        }
        overlayView = self.routeLineView;
    }

    return overlayView;
    
}


@end
