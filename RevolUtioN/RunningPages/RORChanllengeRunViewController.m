//
//  RORChanllengeRunViewController.m
//  RevolUtioN
//
//  Created by Bjorn on 13-9-11.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORChanllengeRunViewController.h"
#import "FTAnimation.h"

@interface RORChanllengeRunViewController ()

@end

@implementation RORChanllengeRunViewController
@synthesize timerCount;
@synthesize timeLabel, speedLabel, distanceLabel, startButton, endButton;
@synthesize routeLineView;
@synthesize record;
@synthesize doCollect;
@synthesize kalmanFilter;
@synthesize runMission;
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
    
    srand(time(NULL));
    int randomValue = rand();
    if (randomValue%100<20)
        finishSound = [[RORPlaySound alloc]initForPlayingSoundEffectWith:@"running_end2.mp3"];
    else
        finishSound = [[RORPlaySound alloc]initForPlayingSoundEffectWith:@"running_end1.mp3"];
}

//initial all when view appears
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self controllerInit];
    [self navigationInit];
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 0) {
//        //        [self.navigationController popViewControllerAnimated:YES];
//    }
//}

-(void)controllerInit{
    if (mission == nil)
        mission = [RORMissionServices fetchMission:runMission.missionId];
    
    self.coverView.alpha = 0;
    self.backButton.alpha = 0;

    self.mapView.delegate = self;
    
    [startButton setTitle:SEARCHING_LOCATION forState:UIControlStateNormal];
    [self.startButton setEnabled:NO];
    UIImage *image = [UIImage imageNamed:@"green_btn_bg.png"];
    [startButton setBackgroundImage:image forState:UIControlStateNormal];
    
    image = [UIImage imageNamed:@"redbutton_bg.png"];
    [endButton setBackgroundImage:image forState:UIControlStateNormal];
    
    [endButton setTitle:CANCEL_RUNNING_BUTTON forState:UIControlStateNormal];
    [endButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
//    collapseButton.alpha = 0;
    
    timeLabel.text = [RORUtils transSecondToStandardFormat:0];
    speedLabel.text = [RORUserUtils formatedSpeed:0];
    //distanceLabel.text = [RORUtils outputDistance:mission.missionDistanceLimited.doubleValue-distance];
//    mapView.frame = SCALE_SMALL;
    
    doCollect = NO;
    
    routePoints = [[NSMutableArray alloc]init];
    
//    if (runMission.missionDistanceLimited.integerValue >= 1000)
//        lastKilo = [[RORPlaySound alloc]initForPlayingSoundEffectWith:@"last_kilo.mp3"];
//    if (runMission.missionDistanceLimited.integerValue >= 100)
//        lastHundred = [[RORPlaySound alloc]initForPlayingSoundEffectWith:@"last_hundred.mp3"];
    
    self.titleLabel.text = runMission.missionName;
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
//    [self setExpandButton:nil];
    [self setStartButton:nil];
    [self setEndButton:nil];
//    [self setCollapseButton:nil];
    [self setRouteLineView:nil];
    [self setStartTime:nil];
    [self setEndTime:nil];
    [self setRecord:nil];
    
    [self setCoverView:nil];
    [self setSpringImage:nil];
    [self setDataContainer:nil];
    [self setSaveButton:nil];
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

-(void)startButtonAnimation{
    [Animations rotate:startButton andAnimationDuration:0.3 andWait:NO andAngle:45];
    [startButton flyOut:0.3 delegate:self];
    [startButton backOutTo:kFTAnimationBottom withFade:NO duration:0.3 delegate:self];
    
    self.springImage.alpha = 1;
    [self.springImage popIn:0.5 delegate:self];
}

- (IBAction)startButtonAction:(id)sender {
    [self startButtonAnimation];

    if (!isStarted){
        isStarted = YES;
        if (self.startTime == nil){
            self.startTime = [NSDate date];
            [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
            
            [(RORAppDelegate *)[[UIApplication sharedApplication] delegate] setRunningStatus:YES];

            
            [endButton setTitle:@"放弃" forState:UIControlStateNormal];
            [endButton removeTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
            [endButton addTarget:self action:@selector(endButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            //init inertia navigation
            [self initNavi];
            
            [self startDeviceMotion];
            
            //the first point after started
            [self initOffset:[mapView userLocation]];
            latestUserLocation = [self getNewRealLocation];
            formerLocation = latestUserLocation;
            [routePoints addObject:formerLocation];
            [self drawLineWithLocationArray:routePoints];
            
            [sound play];
            [countDownView show];
        }
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(timerDot) userInfo:nil repeats:YES];
        repeatingTimer = timer;
        
        [endButton setEnabled:YES];
    } else {
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
}

- (void)timerDot{
    [self timerDotCommon];

    doCollect = YES;
    
    timerCount++;
    duration = timerCount * TIMER_INTERVAL;
    // currently, only do running status judgement here.
    [self inertiaNavi];
    
    NSInteger intTime = (NSInteger)duration;
    if (duration - intTime < 0.001){ //1 second
        //    if (time % 3 == 0){
        [self pushPoint];
//        if (mission.missionDistanceLimited.doubleValue-distance < 1000 && !lastKiloPlayed){
//            lastKiloPlayed = YES;
//            [lastKilo play];
//        }
//        if (mission.missionDistanceLimited.doubleValue-distance < 100 && !lastHundredPlayed){
//            lastHundredPlayed = YES;
//            [lastHundred play];
//        }
//        double leftDistance = mission.missionDistanceLimited.doubleValue-distance;
//        distanceLabel.text = [RORUtils outputDistance:leftDistance<0?0:leftDistance];
//        speedLabel.text = [RORUserUtils formatedSpeed:currentSpeed*3.6];
        
//        if (leftDistance<=0){
//            [finishSound play];
//            [endButton setTitle:FINISH_RUNNING_BUTTON forState:UIControlStateNormal];
//            [self endButtonAction:self];
//        }
        //    }
    }
    
    timeLabel.text = [RORUtils transSecondToStandardFormat:duration];
}

- (void)pushPoint{
    CLLocation *currentLocation = [self getNewRealLocation];
    double deltaDistance = [formerLocation distanceFromLocation:currentLocation];

    if (formerLocation != currentLocation  && deltaDistance>MIN_PUSHPOINT_DISTANCE){
        //calculate real-time speed
        currentSpeed = deltaDistance / timeFromLastLocation;//[INDeviceStatus getSpeedVectorBetweenLocation1:formerLocation andLocation2:currentLocation deltaTime:timeFromLastLocation];
        timeFromLastLocation = 0;
        
        distance += [formerLocation distanceFromLocation:currentLocation];
        formerLocation = currentLocation;
        [routePoints addObject:currentLocation];
        [self drawLineWithLocationArray:routePoints];
        
        //记录每KM平均速度
        [self pushAvgSpeedPerKM];
    }
}

-(void)abortConfirm{
    UIAlertView *confirmView = [[UIAlertView alloc] initWithTitle:@"放弃" message:@"确定放弃么？" delegate:self cancelButtonTitle:CANCEL_BUTTON_CANCEL otherButtonTitles:OK_BUTTON_OK, nil];
    [confirmView show];
    confirmView = nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
//        if (self.startTime != nil) {
//            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(timerDot) userInfo:nil repeats:YES];
//            self.repeatingTimer = timer;
//        }
        return;
    }else if(buttonIndex == 1){
        [self prepareForQuit];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)endButtonAction:(id)sender {
//    [startButton setTitle:CONTINUE_RUNNING_BUTTON forState:UIControlStateNormal];
//    if (runMission.missionDistanceLimited.doubleValue - distance <= 0){
//        [self stopTimer];
//        [self.saveButton setEnabled:YES];
//        [self.saveButton setTitle:@"保存" forState:UIControlStateNormal];
//        coverView.alpha = 1;
////        [Animations fadeIn:coverView andAnimationDuration:0.3 toAlpha:1 andWait:NO];
////        NSLog(@"%d", stepCounting.counter);
//    } else {
//        [self abortConfirm];
//    }
}

- (IBAction)btnCoverInside:(id)sender {
    [Animations fadeOut:coverView andAnimationDuration:0.3 fromAlpha:1 andWait:NO];
}

- (IBAction)btnSaveRun:(id)sender {
    if (self.endTime == nil)
        self.endTime = [NSDate date];
    
    [self startIndicator:self];

    [self saveRunInfo];

//    [[UIApplication sharedApplication] setIdleTimerDisabled: NO];
//    
//    [repeatingTimer invalidate];
//    [startButton setEnabled:NO];
//    self.repeatingTimer = nil;
    [self endIndicator:self];

    [self prepareForQuit];
    
    [self performSegueWithIdentifier:@"ChallengeRunResultSegue" sender:self];
    
}

-(void)prepareForQuit{
    [self stopUpdates];
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

-(NSNumber *)calculateMissionGrade{
    if (mission == nil)
        mission = [RORMissionServices fetchMission:runMission.missionId];
//    NSArray *gradeList = mission.challengeList;
//    for (int i=0; i<gradeList.count; i++){
//        NSInteger thisGrade = ((NSNumber *)[[gradeList objectAtIndex:i] valueForKey:@"time"]).integerValue;
//        if (duration<thisGrade)
//            return [NSNumber numberWithInt:i];//MissionGradeEnum_toString[i]
//    }
//    return [NSNumber numberWithInt:GRADE_F];//MissionGradeEnum_toString[GRADE_F];
}

-(NSNumber *)calculateAward:(NSNumber *)missionGrade baseValue:(double) base{
//    if (missionGrade.integerValue == GRADE_S){
//        return [NSNumber numberWithDouble:3*base];
//    }
//    if (missionGrade.integerValue == GRADE_A){
//        return [NSNumber numberWithDouble:(1.8)*base];
//    }
//    if (missionGrade.integerValue == GRADE_B){
//        return [NSNumber numberWithDouble:(1.6)*base];
//    }
//    if (missionGrade.integerValue == GRADE_C){
//        return [NSNumber numberWithDouble:(1.4)*base];
//    }
//    if (missionGrade.integerValue == GRADE_D){
//        return [NSNumber numberWithDouble:(1.2)*base];
//    }
//    if (missionGrade.integerValue == GRADE_E){
//        return [NSNumber numberWithDouble:base];
//    }
//    return [NSNumber numberWithDouble:0];
}

//-(NSNumber *)isValidRun:(NSInteger)steps {
//    double avgStepDistance = distance / steps;
//    double avgStepFrequency = steps * 60 / duration ;
//    if (avgStepFrequency < 70 || avgStepFrequency > 240 || avgStepDistance < 0.5 || avgStepDistance > 2.5)
//        return [NSNumber numberWithInteger:-1];
//    return [NSNumber numberWithInteger:1];
//}

- (void)saveRunInfo{
    User_Running_History *runHistory = [User_Running_History intiUnassociateEntity];
    //runHistory.distance = runMission.missionDistanceLimited;
    runHistory.duration = [NSNumber numberWithDouble:duration];
    runHistory.avgSpeed = [NSNumber numberWithDouble:(double)(distance/duration*3.6)];
    runHistory.missionRoute = [RORDBCommon getStringFromRoutes:routes];
//    runHistory.speedList = [RORDBCommon getStringFromSpeedList:avgSpeedPerKMList];
    runHistory.missionDate = [NSDate date];
    runHistory.missionEndTime = self.endTime;
    runHistory.missionStartTime = self.startTime;
    runHistory.userId = [RORUserUtils getUserId];
    runHistory.valid = [self isValidRun:stepCounting.counter / 0.8];
    if (runMission!=nil){
        runHistory.missionTypeId = runMission.missionTypeId;
        switch (runMission.missionTypeId.integerValue) {
//            case Challenge:
//                runHistory.missionId = runMission.missionId;
//                runHistory.missionGrade = [self calculateMissionGrade];
//                runHistory.extraExperience = [self calculateAward:runHistory.missionGrade baseValue:runMission.experience.doubleValue];
//                runHistory.experience =[NSNumber numberWithDouble:[self calculateExperience:runHistory].doubleValue + runHistory.extraExperience.doubleValue];
//                runHistory.scores =[NSNumber  numberWithDouble:[self calculateScore:runHistory].doubleValue + [self calculateAward:runHistory.missionGrade baseValue:runMission.scores.doubleValue].doubleValue];
//                break;
//            default:
//                break;
        }
    } else {
        //runHistory.missionTypeId = [NSNumber numberWithInteger:NormalRun];
        //runHistory.grade = [self calculateGrade];
        runHistory.experience =[self calculateExperience:runHistory];
        runHistory.goldCoin =[self calculateScore:runHistory];
    }
    
    runHistory.spendCarlorie = [self calculateCalorie];
    runHistory.runUuid = [RORUtils uuidString];
    runHistory.steps = [NSNumber numberWithInteger:stepCounting.counter / 0.8];
    
    if(runHistory.valid.integerValue != 1 || runHistory.userId.integerValue < 0){
        runHistory.experience =[NSNumber numberWithDouble:0];
        runHistory.goldCoin =[NSNumber  numberWithDouble:0];
        runHistory.extraExperience =[NSNumber  numberWithDouble:0];
    }
    
    NSLog(@"%@", runHistory);
    record = runHistory;
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
    
    if (routeLine != nil){
        [mapView removeOverlay:routeLine];
        routeLine = nil;
    }
    int pointCount = [locationArray count];
    CLLocationCoordinate2D *coordinateArray = (CLLocationCoordinate2D *)malloc(pointCount * sizeof(CLLocationCoordinate2D));
    
    for (int i = 0; i < pointCount; ++i) {
        CLLocation *location = [locationArray objectAtIndex:i];
        coordinateArray[i] = [location coordinate];
    }
    
    routeLine = [MKPolyline polylineWithCoordinates:coordinateArray count:pointCount];
    self.routeLineShadow = [MKPolyline polylineWithCoordinates:coordinateArray count:pointCount];
    
    //    [mapView setVisibleMapRect:[routeLine boundingMapRect]];
    [mapView addOverlay:self.routeLineShadow];
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
        
    } else if (overlay == self.routeLineShadow){
        self.routeLineShadowView = [[MKPolylineView alloc] initWithPolyline:routeLine];
        //        self.routeLineView.fillColor = [UIColor colorWithRed:223 green:8 blue:50 alpha:1];
        self.routeLineShadowView.strokeColor = [UIColor colorWithRed:107.0/255.0 green:96.0/255.0 blue:97.0/255.0 alpha:1];
        self.routeLineShadowView.lineWidth = 12;
        //        }
        
        overlayView = self.routeLineShadowView;
    }
    
    
    return overlayView;
    
}

//#pragma mark Map View Delegate Methods
//- (MKAnnotationView *) mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>) annotation {
//
////    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"PIN_ANNOTATION"];
////    if(annotationView == nil) {
////        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
////                                                          reuseIdentifier:@"PIN_ANNOTATION"];
////    }
////    annotationView.canShowCallout = YES;
////    annotationView.pinColor = MKPinAnnotationColorRed;
////    annotationView.animatesDrop = YES;
////    annotationView.highlighted = YES;
////    annotationView.draggable = YES;
////    return annotationView;
//    if ([annotation isKindOfClass:[MKUserLocation class]])
//        return nil;
//    // 处理我们自定义的Annotation
//    if ([annotation isKindOfClass:[RORMapAnnotation class]]) {
//        RORMapAnnotation *travellerAnnotation = (RORMapAnnotation *)annotation;
////        static NSString* travellerAnnotationIdentifier = @"TravellerAnnotationIdentifier";
//        static NSString *identifier = @"currentLocation";
////        SVPulsingAnnotationView *pulsingView = (SVPulsingAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
//
//        MKPinAnnotationView* pulsingView = (MKPinAnnotationView *)
//        [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
//        if (!pulsingView)
//        {
//            // if an existing pin view was not available, create one
//            pulsingView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
////            MKAnnotationView* customPinView = [[MKAnnotationView alloc]
////                                                initWithAnnotation:annotation reuseIdentifier:identifier];
//            //加展开按钮
////            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
////            [rightButton addTarget:self
////                            action:@selector(showDetails:)
////                  forControlEvents:UIControlEventTouchUpInside];
////            pulsingView.rightCalloutAccessoryView = rightButton;
////
//            UIImage *image = [UIImage imageNamed:@"smail_annotation.png"];
//            pulsingView.image = image;  //将图钉变成笑脸。
//            pulsingView.canShowCallout = YES;
////
////            UIImageView *headImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:travellerAnnotation.headImage]];
////            pulsingView.leftCalloutAccessoryView = headImage; //设置最左边的头像
//
//            return pulsingView;
//        }
//        else
//        {
//            pulsingView.annotation = annotation;
//        }
//        return pulsingView;
//    }
//    return nil;
//}

@end