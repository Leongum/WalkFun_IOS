//
//  RORGetReadyViewController.m
//  RevolUtioN
//
//  Created by Beyond on 13-5-16.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//
#define SCALE_SMALL CGRectMake(50,70,220,188)

#import "RORRunningViewController.h"
#import "Animations.h"

@interface RORRunningViewController ()

@end

@implementation RORRunningViewController
//@synthesize locationManager, motionManager;
@synthesize timerCount;
@synthesize timeLabel, speedLabel, distanceLabel, endButton;
@synthesize routeLineView;
@synthesize record;
@synthesize doCollect;
@synthesize kalmanFilter, inDistance;
@synthesize coverView;

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
    
//    UIImage *image = [UIImage imageNamed:@"redbutton_bg.png"];
//    [endButton setBackgroundImage:image forState:UIControlStateNormal];

    [self startButtonAction:self];
    
//    collapseButton.alpha = 0;
    
    timeLabel.text = [RORUtils transSecondToStandardFormat:0];
    speedLabel.text = [RORUserUtils formatedSpeed:0];
    distanceLabel.text = [RORUtils outputDistance:0];
//    self.stepLabel.text = @"0";
//    mapView.frame = SCALE_SMALL;
    
    doCollect = NO;
    
    routePoints = [[NSMutableArray alloc]init];
    
//    self.saveButton.delegate = self;
    
    isAWalking = NO;
}

-(void)navigationInit{
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

- (void)viewDidUnload {
    [self setDistanceLabel:nil];
    [self setTimeLabel:nil];
    [self setSpeedLabel:nil];
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

- (IBAction)startButtonAction:(id)sender {
    if (!isStarted){
        isStarted = YES;
        if (self.startTime == nil){
            self.startTime = [NSDate date];
            
            [(RORAppDelegate *)[[UIApplication sharedApplication] delegate] setRunningStatus:YES];

            UIImage* image = [UIImage imageNamed:@"redbutton_bg.png"];
            [endButton setBackgroundImage:image forState:UIControlStateNormal];
            [endButton setTitle:CANCEL_RUNNING_BUTTON forState:UIControlStateNormal];
            [endButton addTarget:self action:@selector(endButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            //init inertia navigation
            [self initNavi];
            
            [self startDeviceMotion];
            
            [self.tableView reloadData];
        }
        //init former location
        latestUserLocation = [self getNewRealLocation];
        formerLocation = latestUserLocation;
        [routePoints addObject:formerLocation];
        
        [NSThread detachNewThreadSelector:@selector(startTimer) toTarget:self withObject:nil];
    }
}

-(void)startTimer{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(timerDot) userInfo:nil repeats:YES];
    repeatingTimer = timer;
    [[NSRunLoop currentRunLoop] run];
}

- (void)initNavi{
    [super initNavi];
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
    if (duration - intTime < 0.00001){ //1 second
        [self timerSecondDot];
    }

    [self performSelectorOnMainThread:@selector(displayTimerInfo) withObject:nil waitUntilDone:YES];
}

-(void)displayTimerInfo{
    timeLabel.text = [RORUtils transSecondToStandardFormat:duration];
    distanceLabel.text = [RORUtils formattedSteps:stepCounting.counter/0.8];
}

-(void)timerSecondDot{
    [super timerSecondDot];
    [self pushPoint];
    distanceLabel.text = [RORUtils outputDistance:distance];
    speedLabel.text = [RORUserUtils formatedSpeed:(double)(currentSpeed*3.6)];
    
    if (eventHappenedList.count > eventHappenedCount){
        eventHappenedCount = eventHappenedList.count;
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:bottomIndex atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        if (self.paperView.frame.origin.y>-308){
            [Animations moveUp:self.paperView andAnimationDuration:0.3 andWait:NO andLength:newCellHeight<self.paperView.frame.origin.y+308?newCellHeight:self.paperView.frame.origin.y+308];
        }
    }
    if (!isAWalking && currentStep > 50 && distance>50) {
        isAWalking = YES;
        UIImage* image = [UIImage imageNamed:@"green_btn_bg.png"];
        [endButton setBackgroundImage:image forState:UIControlStateNormal];
        [endButton setTitle:FINISH_RUNNING_BUTTON forState:UIControlStateNormal];
    }
}

- (void)pushPoint{
    CLLocation *currentLocation = [self getNewRealLocation];
    double deltaDistance = [formerLocation distanceFromLocation:currentLocation];
    if (formerLocation != currentLocation && deltaDistance>MIN_PUSHPOINT_DISTANCE){
        //calculate real-time speed
        currentSpeed = deltaDistance / timeFromLastLocation;
        timeFromLastLocation = 0;
        
        NSLog(@"%f",deltaDistance);
        distance += [formerLocation distanceFromLocation:currentLocation];
        formerLocation = currentLocation;
        [routePoints addObject:currentLocation];
    }
}

- (IBAction)endButtonAction:(id)sender {
//    [self stopTimer];
    
    if (isAWalking){
        [self.saveButton setEnabled:YES];
        [self.saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [self.saveButton setBackgroundImage:[UIImage imageNamed:@"running_end_bg.png"] forState:UIControlStateNormal];
    } else {
        [self.saveButton setEnabled:NO];
        [self.saveButton setTitle:@"你走的也太少了吧" forState:UIControlStateNormal];
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
    
    [self prepareForQuit];
    [self saveRunInfo];

    [self performSegue];
    [self endIndicator:self];
}

-(void)performSegue{
    [self performSegueWithIdentifier:@"NormalRunResultSegue" sender:self];
}

-(void)prepareForQuit{
    [self stopTimer];

    //stop globle location manager
    [(RORAppDelegate *)[[UIApplication sharedApplication] delegate] setRunningStatus:NO];
    
    //stop timer
    [repeatingTimer invalidate];
    repeatingTimer = nil;
}

- (IBAction)btnDeleteRunHistory:(id)sender {
    [self prepareForQuit];
    [self dismissViewControllerAnimated:YES completion:^(){}];
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
    runHistory.valid = [NSNumber numberWithInt:1]; //[self isValidRun:stepCounting.counter / 0.8];
    runHistory.missionRoute = [RORDBCommon getStringFromRoutes:routes];
//    NSLog(@"%@", [RORDBCommon getStringFromSpeedList:avgSpeedPerKMList]);
    
    //保存actionList(actionIds)
    runHistory.actionIds = [RORSystemService getStringFromEventList:eventHappenedList timeList:eventTimeList andLocationList:eventLocationList];
    //保存propget
    runHistory.propGet = [RORSystemService getPropgetStringFromList:eventHappenedList];
    runHistory.fatness = [self calculateFatness];
    runHistory.health = [self calculateHealth];
    runHistory.missionDate = [NSDate date];
    runHistory.missionEndTime = self.endTime;
    runHistory.missionStartTime = self.startTime;
    runHistory.userId = [RORUserUtils getUserId];
    runHistory.spendCarlorie = [self calculateCalorie];
    runHistory.runUuid = [RORUtils uuidString];
    runHistory.steps = [NSNumber numberWithInteger:stepCounting.counter / 0.8];
    runHistory.experience =[self calculateExperience:runHistory];
    //todo 走路本身是否有金币奖励
//    runHistory.goldCoin =[self calculateScore:runHistory];
    runHistory.extraExperience =[NSNumber  numberWithDouble:0];
//    runHistory.speedList = [RORDBCommon getStringFromSpeedList:avgSpeedPerKMList];
    
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

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int rows = eventHappenedList.count + (isStarted?1:0);
    return rows;
}

- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = nil;
    UITableViewCell *cell = nil;
    
    
    if (indexPath.row == 0) {
        identifier = @"eventCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        UILabel *eventTimeLabel = (UILabel *)[cell viewWithTag:100];
        UILabel *eventLabel = (UILabel *)[cell viewWithTag:101];
        UILabel *effectLabel = (UILabel *)[cell viewWithTag:102];
        eventTimeLabel.text = @"";
        eventLabel.text = @"开始散步";
        effectLabel.text = @"一切看起来都那么美好～";
    } else {
        Action_Define *event = [eventHappenedList objectAtIndex:indexPath.row-1];
        if ([event.actionDescription rangeOfString:@"金币"].location != NSNotFound ){
            identifier = @"coinCell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        } else {
            identifier = @"eventCell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            UILabel *eventTimeLabel = (UILabel *)[cell viewWithTag:100];
            UILabel *eventLabel = (UILabel *)[cell viewWithTag:101];
            UILabel *effectLabel = (UILabel *)[cell viewWithTag:102];
            eventLabel.text = event.actionName;
            effectLabel.text = [NSString stringWithFormat:@"获得：%@",event.actionAttribute];
            
            int timeInt = ((NSNumber *)[eventTimeList objectAtIndex:indexPath.row-1]).integerValue;
            eventTimeLabel.text = [NSString stringWithFormat:@"%@的时候",[RORUtils transSecondToStandardFormat:timeInt]];
        }
    }
    bottomIndex = indexPath;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0){
        newCellHeight = 62;
        return 62;
    }
    Action_Define *event = [eventHappenedList objectAtIndex:indexPath.row-1];
    if ([event.actionDescription rangeOfString:@"金币"].location != NSNotFound ){
        newCellHeight = 30;
        return 30;
    }
    newCellHeight = 62;
    return 62;
}


@end
