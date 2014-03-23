//
//  RORGetReadyViewController.m
//  RevolUtioN
//
//  Created by Beyond on 13-5-16.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//
#define SCALE_SMALL CGRectMake(50,70,220,188)
#define COLOR_DEF_RED [UIColor colorWithRed:213.0/255.0 green:54.0/255.0 blue:10.0/255.0 alpha:1.0]

#import "RORRunningViewController.h"
#import "Animations.h"
#import "FTAnimation.h"

@interface RORRunningViewController ()

@end

@implementation RORRunningViewController
//@synthesize locationManager, motionManager;
@synthesize timerCount;
@synthesize timeLabel, distanceLabel, endButton;
@synthesize routeLineView;
@synthesize record;
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
    todayMission = [RORMissionServices getTodayMission];
    [self initTodayMission];
}

//initial all when view appears
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self controllerInit];
}

-(void)controllerInit{
    self.coverView.alpha = 0;
    self.backButton.alpha = 0;
    
    //进页面后直接开始记步
    [self startButtonAction:self];
    
    //初始化各个标签
    timeLabel.text = [RORUtils transSecondToStandardFormat:0];
    distanceLabel.text = [RORUtils outputDistance:0];
    self.goldLabel.text = @"0";
    
    routePoints = [[NSMutableArray alloc]init];
    
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

-(void)awakeFromNib {
    [super awakeFromNib];
    [self navigationInit];
}

- (void)viewDidUnload {
    [self setDistanceLabel:nil];
    [self setTimeLabel:nil];
//    [self setSpeedLabel:nil];
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

-(void)newProcessView:(UIView *)v{
    THProgressView *processView = [[THProgressView alloc] initWithFrame:v.frame];
    processView.borderTintColor = [UIColor blackColor];
    processView.progressTintColor = [UIColor blackColor];
    [processView setProgress:0.f];
    [self.todayMissionView addSubview:processView];
    [self.todayMissionView sendSubviewToBack:processView];
    
    [processViewList addObject:processView];
}

-(void)initTodayMission{
    todayMissionDict = [[NSMutableDictionary alloc]init];
    processViewList = [[NSMutableArray alloc]init];
    
    UILabel *titleLabel = (UILabel *)[self.todayMissionView viewWithTag:1];
    
    for (int i=100; i<103; i++) {
        UILabel *l = (UILabel *)[self.todayMissionView viewWithTag:i];
        l.alpha = 0;
    }
    
    if (todayMission != nil){
        
        titleLabel.text = @"今日任务";
        switch (todayMission.missionTypeId.integerValue) {
            case MissionTypeStep:{
                if (todayMission.triggerDistances){
                    [todayMissionDict setObject:todayMission.triggerDistances forKey:@"distance"];
                }
                if (todayMission.triggerSteps){
                    [todayMissionDict setObject:todayMission.triggerSteps forKey:@"currentStep"];
                }
                if (todayMission.triggerTimes){
                    [todayMissionDict setObject:todayMission.triggerTimes forKey:@"duration"];
                }
                break;
            }
            case MissionTypePickItem:{
                [todayMissionDict setObject:todayMission.triggerNumbers forKey:todayMission.triggerActionId];
                break;
            }
            default:
                break;
        }
        int i=100;
        for (id keys in [todayMissionDict allKeys]){
            if (i>102)
                break;
            if ([keys isKindOfClass:[NSString class]]){
                NSString *keyString = (NSString *)keys;
                UILabel *l = (UILabel *)[self.todayMissionView viewWithTag:i];
                l.alpha = 1;
                [self newProcessView:l];
                if ([keyString isEqualToString:@"distance"]){
                    l.text = [NSString stringWithFormat:@"%gkm",((NSNumber *)[todayMissionDict objectForKey:keys]).doubleValue/1000];
                    continue;
                }
                if ([keyString isEqualToString:@"currentStep"]){
                    l.text = [NSString stringWithFormat:@"%d步",((NSNumber *)[todayMissionDict objectForKey:keys]).intValue];
                    i++;
                }
                if ([keyString isEqualToString:@"duration"]){
                    l.text = [NSString stringWithFormat:@"%d分钟",((NSNumber *)[todayMissionDict objectForKey:keys]).intValue/60];
                }
                i++;
            } else {
                UILabel *l = (UILabel *)[self.todayMissionView viewWithTag:i];
                l.text = todayMission.missionRule;
                l.alpha = 1;
                [self newProcessView:l];
                i++;
            }
        }
    } else {
        titleLabel.text = @"随便走走";
    }
    
    cMissionItemQuantity = 0;
}

-(void)checkTodayMission{
    //debug
    if (todayMission != nil){// && isAWalking){
        int i=0;
        for (id keys in [todayMissionDict allKeys]){
            THProgressView *pv = [processViewList objectAtIndex:i];
            double p;

            if ([keys isKindOfClass:[NSString class]]){
                NSString *keyString = (NSString *)keys;
                if ([keyString isEqualToString:@"distance"]){
                    p = distance / ((NSNumber *)[todayMissionDict objectForKey:keys]).doubleValue;
                }
                if ([keyString isEqualToString:@"currentStep"]){
                    p = currentStep / ((NSNumber *)[todayMissionDict objectForKey:keys]).doubleValue;
                }
                if ([keyString isEqualToString:@"duration"]){
                    p = duration / ((NSNumber *)[todayMissionDict objectForKey:keys]).doubleValue;
                }
                
            } else {
                p = cMissionItemQuantity / ((NSNumber *)[todayMissionDict objectForKey:keys]).doubleValue;
            }
            
            if (p>1)
                p=1;
            [pv setProgress:p];
            if (p==1){
                UILabel *l = (UILabel *)[self.todayMissionView viewWithTag:100+i];
                l.text = @"完成";
            }
            i++;
        }

    }
}



- (IBAction)startButtonAction:(id)sender {
    if (!isStarted){
        isStarted = YES;
        if (self.startTime == nil){
            self.startTime = [NSDate date];
            
            [(RORAppDelegate *)[[UIApplication sharedApplication] delegate] setRunningStatus:YES];

            UIImage* image = [UIImage imageNamed:@"redbutton_bg.png"];
            [endButton setBackgroundImage:image forState:UIControlStateNormal];
            [endButton setTitle:@"放弃" forState:UIControlStateNormal];
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
//    speedLabel.text = [RORUserUtils formatedSpeed:(double)(currentSpeed*3.6)];
    
    if (eventDisplayList.count > eventHappenedCount){
        eventHappenedCount = eventDisplayList.count;
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:bottomIndex atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        if (self.paperView.frame.origin.y>-308){
            [Animations moveUp:self.paperView andAnimationDuration:0.3 andWait:NO andLength:newCellHeight<self.paperView.frame.origin.y+308?newCellHeight:self.paperView.frame.origin.y+308];
        }
    }
    if (!isAWalking && currentStep > 70 && distance>50) {
        isAWalking = YES;
        UIImage* image = [UIImage imageNamed:@"green_btn_bg.png"];
        [endButton setBackgroundImage:image forState:UIControlStateNormal];
        [endButton setTitle:@"完成" forState:UIControlStateNormal];
    }
    
    [self checkTodayMission];
    
    //触发疲劳事件
    if (duration>3600 && ((int)duration)%120==0){
        [self eventDidHappened:tiredAction];
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
    UIImageView *iv = (UIImageView*)[coverView viewWithTag:100];
    iv.image = [UIUtils grayscale:[RORUtils captureScreen] type:1];
    
//    [Animations fadeIn:coverView andAnimationDuration:0.3 toAlpha:1 andWait:NO];
    [coverView fadeIn:0.3 delegate:self startSelector:nil stopSelector:@selector(addBgAction:)];
    coverView.alpha = 1;

}

-(IBAction)addBgAction:(id)sender{
    [coverView addTarget:self action:@selector(btnCoverInside:) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)btnCoverInside:(id)sender {
    [Animations fadeOut:coverView andAnimationDuration:0.3 fromAlpha:1 andWait:NO];
    [coverView removeTarget:self action:@selector(addBgAction:) forControlEvents:UIControlEventTouchUpInside];
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


#pragma mark - Save Data

-(NSNumber *)calculateGrade{
    return [self calculateCalorie];
}

- (void)saveRunInfo{
    [self creatRunningHistory];
    [self startIndicator:self];
    if([RORUserUtils getUserId].integerValue > 0){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [RORRunHistoryServices saveRunInfoToDB:runHistory];
            BOOL updated = [RORRunHistoryServices uploadRunningHistories];
            dispatch_async(dispatch_get_main_queue(), ^{
                if(updated){
                    [self sendSuccess:@"保存成功"];
                }
                else{
                    [self sendAlart:@"上传失败，请手动同步记录"];
                }
                [self performSegue];
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
    //保存actionList(actionIds)
    runHistory.actionIds = [RORUtils toJsonFormObject:eventHappenedList];//[RORSystemService getStringFromEventList:eventHappenedList timeList:eventTimeList andLocationList:eventLocationList];
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
    runHistory.extraExperience =[NSNumber  numberWithDouble:0];
    
    [self isMissionDone];
    
    NSLog(@"%@", runHistory);
    record = runHistory;
}

-(void)isMissionDone{
    BOOL isDone = YES;
    for (THProgressView *pv in processViewList){
        if (pv.progress<1)
            isDone = NO;
    }
    if (isDone){
        runHistory.missionId = todayMission.missionId;
        runHistory.missionGrade = [NSNumber numberWithInteger:1];
        runHistory.extraGoldCoin = todayMission.goldCoin;
        runHistory.extraExperience = todayMission.experience;
        
        NSMutableDictionary *userInfoList = [RORUserUtils getUserInfoPList];
        NSInteger missionProcess = ((NSNumber *)[userInfoList valueForKey:@"missionProcess"]).integerValue;
        //todo
        if (++missionProcess >3)
            missionProcess = 3;
        [userInfoList setObject:[NSNumber numberWithInteger:missionProcess] forKey:@"missionProcess"];
        [userInfoList setObject:[NSDate date] forKey:@"lastDailyMissionFinishedDate"];
        [RORUserUtils writeToUserInfoPList:userInfoList];
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

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = eventDisplayList.count + (isStarted?1:0);
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
        Walk_Event *event = [eventDisplayList objectAtIndex:indexPath.row-1];
        identifier = @"eventCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if ([event.eType isEqualToString:RULE_Type_Action]){
            Action_Define *actionEvent = [RORSystemService fetchActionDefine:event.eId];

            UILabel *eventTimeLabel = (UILabel *)[cell viewWithTag:100];
            UILabel *eventLabel = (UILabel *)[cell viewWithTag:101];
            UILabel *effectLabel = (UILabel *)[cell viewWithTag:102];
            eventLabel.text = actionEvent.actionName;
            effectLabel.text = [NSString stringWithFormat:@"获得：%@",actionEvent.actionAttribute];
            
            int timeInt = event.times.intValue;
            eventTimeLabel.text = [NSString stringWithFormat:@"%@的时候",[RORUtils transSecondToStandardFormat:timeInt]];
        } else {
            
        }
    }
    bottomIndex = indexPath;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    newCellHeight = 62;
    return 62;
}

#pragma mark - Event Methods

//如果触发了事件，返回事件，否则返回nil
-(void)isEventHappen{
    if(eventTimeList.count > 0){
        NSNumber *lastEventTime = [eventTimeList objectAtIndex:eventTimeList.count-1];
        if (duration - lastEventTime.doubleValue < 5)
            return;
    }
    
    //10步随机一次战斗事件
    if (((int)currentStep)%10 == 0){
        int x = arc4random() % 1000000;
        double roll = ((double)x)/10000.f;
        double rate5 = 0, rate4 = 0, rate3 = 0, rate2 = 0;
        if (currentStep>WALKING_FIGHT_STAGE_IV){
            rate5 = 0.1;
            rate4 = (currentStep - WALKING_FIGHT_STAGE_IV)*2/(WALKING_FIGHT_STAGE_V - WALKING_FIGHT_STAGE_IV) + 1;
            rate3 = 1;
            rate2 = 0.5;
        }
        if (currentStep>WALKING_FIGHT_STAGE_III){
            rate3 = (currentStep - WALKING_FIGHT_STAGE_III)*2/(WALKING_FIGHT_STAGE_IV - WALKING_FIGHT_STAGE_III) + 1;
            rate2 = 0.5;
        }
        if (currentStep>WALKING_FIGHT_STAGE_II){
            rate2 = (currentStep - WALKING_FIGHT_STAGE_II)*2/(WALKING_FIGHT_STAGE_III - WALKING_FIGHT_STAGE_II) + 1;
        }
        int fightStage = 0;
        if (roll<rate5){//稀有级怪物
            fightStage = FightStageLegend;
        } else if (roll<rate4){//高级怪
            fightStage = FightStageHard;
        } else if (roll<rate3){//中级怪
            fightStage = FightStageNormal;
        } else if (roll<rate2){//低级怪
            fightStage = FightStageEasy;
        }
        if (fightStage>0){
            NSArray *fightList = [RORSystemService fetchFightDefineByLevel:userBase.userDetail.level andStage:[NSNumber numberWithInteger:fightStage]];
            if (fightList){
                Fight_Define *fightEvent = (Fight_Define *)[fightList objectAtIndex:arc4random() % fightList.count];
                [self eventDidHappened:[self makeWalkEvent:fightEvent]];
            }
        }
    }
    
    for (int i=0; i<eventWillList.count; i++){
        Action_Define *event = (Action_Define *)[eventWillList objectAtIndex:i];
        int x = arc4random() % 1000000;
        double roll = ((double)x)/10000.f;
        double delta = 1;
//        if ([event.actionName rangeOfString:@"金币"].location != NSNotFound) {
//            delta = (user.userDetail.goldCoinSpeed.doubleValue + 1);
//        }
        //debug
        if (roll < event.triggerProbability.doubleValue *delta){
            [self eventDidHappened:[self makeWalkEvent:event]];
            return;
        }
    }
}

-(Walk_Event *)makeWalkEvent:(id)event{
    Walk_Event *walkEvent = [[Walk_Event alloc]init];
    if ([event isKindOfClass:[Action_Define class]]){
        Action_Define *e = (Action_Define *)event;
        walkEvent.eId = e.actionId;
        walkEvent.eType = RULE_Type_Action;
    } else if ([event isKindOfClass:[Fight_Define class]]){
        Fight_Define *e = (Fight_Define *)event;
        walkEvent.eId = e.fightId;
        walkEvent.eType = RULE_Type_Fight;
        walkEvent.eWin = [self checkWin:e];
        walkEvent.power = [self calculatePowerForFight:e];
    }
    walkEvent.times = [NSNumber numberWithInteger:duration];
    walkEvent.lati = [NSNumber numberWithDouble:formerLocation.coordinate.latitude];
    walkEvent.longi = [NSNumber numberWithDouble:formerLocation.coordinate.longitude];
    return walkEvent;
}

-(NSNumber *)calculatePowerForFight:(Fight_Define *)fight{
    userPower -= 10;
    
    return [NSNumber numberWithInteger:10];
}

-(NSNumber *)checkWin:(Fight_Define *)fight{
    double userFight = userBase.userDetail.fight.doubleValue + userBase.userDetail.fightPlus.doubleValue;
    if (userFight > fight.monsterMaxFight.doubleValue){
        return [NSNumber numberWithInteger:1];
    }
    if (userFight > fight.monsterMinFight.doubleValue){
        double deltaMFight = fight.monsterMaxFight.doubleValue - fight.monsterMinFight.doubleValue;
        double rate = (userFight - fight.monsterMinFight.doubleValue)*25/deltaMFight + 75;
        int x = arc4random() % 1000000;
        double roll = ((double)x)/10000.f;
        if (roll<rate)
            return [NSNumber numberWithInteger:1];
        else
            return [NSNumber numberWithInteger:0];
    }
    return [NSNumber numberWithInteger:0];
}

-(void)eventDidHappened:(Walk_Event *)event{
    if (event.eId.integerValue == todayMission.triggerActionId.integerValue){
        cMissionItemQuantity++;
    }
    
    if ([event.eType isEqualToString:RULE_Type_Action]){
        Action_Define *actionEvent = [RORSystemService fetchActionDefine:event.eId];
        if ([actionEvent.actionName rangeOfString:@"金币"].location != NSNotFound) {
            goldCount++;
            self.goldLabel.text= [NSString stringWithFormat:@"%d", goldCount];
            [self.goldLabel fallIn:0.5 delegate:self];
        } else {
            [eventDisplayList addObject:event];
//            [eventDisplayTimeList addObject:[NSNumber numberWithInteger:duration]];
        }
        [allInOneSound addFileNametoQueue:[RORVirtualProductService getSoundFileOf:actionEvent]];
        [allInOneSound play];

    } else {
        [eventDisplayList addObject:event];
    }
    
    [eventHappenedList addObject:event];
    
//    [eventTimeList addObject: [NSNumber numberWithInteger:duration]];
//    [eventLocationList addObject:[NSString stringWithFormat:@"%f,%f", formerLocation.coordinate.latitude, formerLocation.coordinate.longitude]];
    
}


@end
