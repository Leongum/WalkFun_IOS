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
    [RORUtils setFontFamily:APP_FONT forView:self.view andSubViews:YES];
}

//initial all when view appears
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self controllerInit];
}

-(void)controllerInit{
    NSMutableDictionary *userInfoList = [RORUserUtils getUserInfoPList];
    NSNumber *thisWalkFriendId = [userInfoList objectForKey:@"thisWalkFriendId"];
    if (thisWalkFriendId.intValue<0) {
        thisWalkFriend = nil;
        friendAddFight = 0;
    } else {
        thisWalkFriend = [RORUserServices fetchUser:thisWalkFriendId];
        friendAddFight = (thisWalkFriend.userDetail.fight.intValue + thisWalkFriend.userDetail.fightPlus.intValue)/5;
    }
    
    self.coverView.alpha = 0;
    self.backButton.alpha = 0;
    
    //初始化战斗力
    userFight = userBase.userDetail.fight.doubleValue + userBase.userDetail.fightPlus.doubleValue + friendAddFight;
//    self.fightLabel.text = @"";
    self.fightLabel.text = [NSString stringWithFormat:@"%.0f", userFight];
    
    //初始化各个标签
    timeLabel.text = [RORUtils transSecondToStandardFormat:0];
    distanceLabel.text = [RORUtils outputDistance:0];
    self.goldLabel.text = @"0";
    self.itemLabel.text = @"0";
    self.friendLabel.text = thisWalkFriend.nickName;
    
    //初始化体力
    powerPV = [[THProgressView alloc] initWithFrame:self.powerFrame.frame];
    powerPV.borderTintColor = [UIColor blackColor];
    powerPV.progressTintColor = [UIColor blackColor];
    [powerPV setProgress:1.f];
    [self.view addSubview:powerPV];
    [self.view bringSubviewToFront:self.powerFrame];
    
    userPowerMax = [RORUserUtils getUserPowerLeft];
    userPower = userPowerMax;
    self.powerFrame.text = [NSString stringWithFormat:@"%ld",(long)userPower];
    walkExperience = 0;
    
    //进页面后直接开始记步
    [self startButtonAction:self];
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
        titleLabel.text = @"随便走走";

        switch (todayMission.missionTypeId.integerValue) {
            case MissionTypeStep:{
                if (todayMission.triggerDistances){
                    if (todayMission.triggerDirection.intValue == MissionDirectionNone){
                        //纯距离类任务
                        [todayMissionDict setObject:todayMission.triggerDistances forKey:@"distance"];
                    } else {
                        //方向类任务
                        switch (todayMission.triggerDirection.intValue) {
                            case MissionDirectionEast:
                                [todayMissionDict setObject:todayMission.triggerDistances forKey:@"east"];
                                break;
                            case MissionDirectionSouth:
                                [todayMissionDict setObject:todayMission.triggerDistances forKey:@"south"];
                                break;
                            case MissionDirectionWest:
                                [todayMissionDict setObject:todayMission.triggerDistances forKey:@"west"];
                                break;
                            case MissionDirectionNorth:
                                [todayMissionDict setObject:todayMission.triggerDistances forKey:@"north"];
                                break;
                            default:
                                break;
                        }
                    }
                }
                if (todayMission.triggerSteps){
                    [todayMissionDict setObject:todayMission.triggerSteps forKey:@"currentStep"];
                }
                if (todayMission.triggerTimes){
                    [todayMissionDict setObject:todayMission.triggerTimes forKey:@"duration"];
                }
                titleLabel.text = @"今日任务";
                break;
            }
            case MissionTypePickItem:{
                [todayMissionDict setObject:todayMission.triggerNumbers forKey:todayMission.triggerActionId];
                titleLabel.text = @"今日任务";
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
                //方向
                if ([keyString isEqualToString:@"north"]){
                    l.text = [NSString stringWithFormat:@"向北%d米",((NSNumber *)[todayMissionDict objectForKey:keys]).intValue];
                }
                if ([keyString isEqualToString:@"south"]){
                    l.text = [NSString stringWithFormat:@"向南%d米",((NSNumber *)[todayMissionDict objectForKey:keys]).intValue];
                }
                if ([keyString isEqualToString:@"west"]){
                    l.text = [NSString stringWithFormat:@"向西%d米",((NSNumber *)[todayMissionDict objectForKey:keys]).intValue];
                }
                if ([keyString isEqualToString:@"east"]){
                    l.text = [NSString stringWithFormat:@"向东%d米",((NSNumber *)[todayMissionDict objectForKey:keys]).intValue];
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
                //方向
                if ([keyString isEqualToString:@"north"]){
                    p = directionMoved.north / ((NSNumber *)[todayMissionDict objectForKey:keys]).doubleValue;
                }
                if ([keyString isEqualToString:@"south"]){
                    p = directionMoved.south / ((NSNumber *)[todayMissionDict objectForKey:keys]).doubleValue;
                }
                if ([keyString isEqualToString:@"west"]){
                    p = directionMoved.west / ((NSNumber *)[todayMissionDict objectForKey:keys]).doubleValue;
                }
                if ([keyString isEqualToString:@"east"]){
                    p = directionMoved.east / ((NSNumber *)[todayMissionDict objectForKey:keys]).doubleValue;
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
//    distanceLabel.text = [NSString stringWithFormat:@"%.0f",directionMoved.north];//[RORUtils outputDistance:distance];
//    speedLabel.text = [RORUserUtils formatedSpeed:(double)(currentSpeed*3.6)];
    
    if (eventDisplayList.count > eventHappenedCount){
        eventHappenedCount = eventDisplayList.count;
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:bottomIndex atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        if (self.paperView.frame.origin.y>-218){
            [Animations moveUp:self.paperView andAnimationDuration:0.3 andWait:NO andLength:newCellHeight<self.paperView.frame.origin.y+218?newCellHeight:self.paperView.frame.origin.y+218];
        }
    }
    if (!isAWalking){// && currentStep > 70 && distance>50) {//debug
        isAWalking = YES;
        UIImage* image = [UIImage imageNamed:@"green_btn_bg.png"];
        [endButton setBackgroundImage:image forState:UIControlStateNormal];
        [endButton setTitle:@"完成" forState:UIControlStateNormal];
    }
    
    [self checkTodayMission];
    
    //触发疲劳事件
    if (duration>3600 && ((int)duration)%120==0){
//        [self eventDidHappened:tiredAction];
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
        
        //找到与formerlocation经度相同，纬度不同的点，计算出的距离为南北方向位移
        CLLocation *tmpLocation =[[CLLocation alloc]initWithLatitude:currentLocation.coordinate.latitude longitude:formerLocation.coordinate.longitude];
        if (tmpLocation.coordinate.latitude > formerLocation.coordinate.latitude){
            directionMoved.north += [formerLocation distanceFromLocation:tmpLocation];
        } else {
            directionMoved.south += [formerLocation distanceFromLocation:tmpLocation];
        }
        //找到与formerlocation纬度相同，经度不同的点，计算出的距离为东西方向位移
        tmpLocation = [[CLLocation alloc]initWithLatitude:formerLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude];
        if (tmpLocation.coordinate.longitude > formerLocation.coordinate.longitude){
            directionMoved.west += [formerLocation distanceFromLocation:tmpLocation];
        } else {
            directionMoved.east += [formerLocation distanceFromLocation:tmpLocation];
        }
        
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
    [self.view bringSubviewToFront:coverView];
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
    //判断是不是走的距离太短还未触发事件
    if (distance<WALKING_FIGHT_STAGE_II){
        NSArray *fightList = [RORSystemService fetchFightDefineByLevel:userBase.userDetail.level andStage:[NSNumber numberWithInteger:FightStageFunny]];
        if (fightList){
            Fight_Define *fightEvent = (Fight_Define *)[fightList objectAtIndex:arc4random() % fightList.count];
            [self eventDidHappened:[self makeWalkEvent:fightEvent]];
        }
    }
    
    [self creatRunningHistory];
    [self startIndicator:self];
    if([RORUserUtils getUserId].integerValue > 0){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [RORRunHistoryServices saveRunInfoToDB:runHistory];
            BOOL updated = [RORRunHistoryServices uploadRunningHistories];
            if (updated)
                [RORFriendService syncFriends:[RORUserUtils getUserId]];
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
    runHistory.actionIds = [RORUtils toJsonFormObject:eventSaveList];//[RORSystemService getStringFromEventList:eventHappenedList timeList:eventTimeList andLocationList:eventLocationList];
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
    runHistory.experience = [NSNumber numberWithInteger:walkExperience];//[self calculateExperience:runHistory];
    runHistory.goldCoin = [NSNumber numberWithInt:goldCount];
    
    runHistory.extraExperience =[NSNumber  numberWithDouble:0];
    
    if (thisWalkFriend) {
        runHistory.friendId = thisWalkFriend.userId;
        runHistory.friendName = thisWalkFriend.nickName;
    }
    
    //检查任务是否完成
    [self isMissionDone];
    
    //保存用户体力
    [RORUserUtils saveUserPowerLeft:userPower];
    
    NSLog(@"%@", runHistory);
    record = runHistory;
}

-(void)isMissionDone{
    BOOL isDone = (processViewList.count>0);
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
    } else {
        runHistory.missionId = nil;
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
        if (thisWalkFriend!=nil)
            eventLabel.text = [NSString stringWithFormat:@"与小伙伴%@一起从村里出发了",thisWalkFriend.nickName];
        else
            eventLabel.text = @"从村里出发了";
        effectLabel.text = @"一切看起来都那么美好～";
    } else {
        Walk_Event *event = [eventDisplayList objectAtIndex:indexPath.row-1];
        
        if ([event.eType isEqualToString:RULE_Type_Action]){
            identifier = @"eventCell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            UILabel *eventTimeLabel = (UILabel *)[cell viewWithTag:100];
            UILabel *eventLabel = (UILabel *)[cell viewWithTag:101];
            UILabel *effectLabel = (UILabel *)[cell viewWithTag:102];
            
            Action_Define *actionEvent = [RORSystemService fetchActionDefine:event.eId];
            eventLabel.text = actionEvent.actionName;
            if (actionEvent.actionAttribute)
                effectLabel.text = [NSString stringWithFormat:@"获得：%@",actionEvent.actionAttribute];
            else
                effectLabel.text = @"";
            int timeInt = event.times.intValue;
            eventTimeLabel.text = [NSString stringWithFormat:@"%@的时候",[RORUtils transSecondToStandardFormat:timeInt]];
        } else {
            identifier = @"fightCell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            UILabel *eventTimeLabel = (UILabel *)[cell viewWithTag:100];
            UILabel *eventLabel = (UILabel *)[cell viewWithTag:101];
            UILabel *effectLabel = (UILabel *)[cell viewWithTag:102];
            [eventLabel setLineBreakMode:NSLineBreakByWordWrapping];
            eventLabel.numberOfLines = 0;
            
            Fight_Define *fightEvent = [RORSystemService fetchFightDefineInfo:event.eId];
            NSArray *meetText = [fightEvent.fightName componentsSeparatedByString:@"。"];
            NSMutableString *fightText = [[NSMutableString alloc]initWithString:[meetText objectAtIndex:0]];
            if (event.eWin.integerValue>0){
                NSArray *winTextList = [fightEvent.fightWin componentsSeparatedByString:@"|"];
                [fightText appendString:[NSString stringWithFormat:@"，%@",(NSString *)[winTextList objectAtIndex:event.eWin.intValue/10]]];
                
                if (event.eWin.integerValue%10>1 && fightEvent.winGot)
                    effectLabel.text = [NSString stringWithFormat:@"获得：%@",fightEvent.winGot];
                else
                    effectLabel.text = [NSString stringWithFormat:@""];
            } else {
                NSArray *winTextList = [fightEvent.fightLoose componentsSeparatedByString:@"|"];
                [fightText appendString:[NSString stringWithFormat:@"，%@",(NSString *)[winTextList objectAtIndex:abs(event.eWin.intValue/10)]]];
                effectLabel.text = [NSString stringWithFormat:@""];
            }
            [fightText appendString:[meetText objectAtIndex:1]];
            eventLabel.text = fightText;
            eventTimeLabel.text = [NSString stringWithFormat:@"%@的时候",[RORUtils transSecondToStandardFormat:event.times.integerValue]];
        }
    }
    bottomIndex = indexPath;
    
    [RORUtils setFontFamily:APP_FONT forView:cell andSubViews:YES];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    newCellHeight = 75;
    if (indexPath.row>0){
        Walk_Event *event = [eventDisplayList objectAtIndex:indexPath.row-1];
        if ([event.eType isEqualToString:RULE_Type_Fight]){
            newCellHeight = 110;
        }
    }
    return newCellHeight;
}

#pragma mark - Event Methods

//如果触发了事件，返回事件，否则返回nil
-(void)isEventHappen{
    if (userPower == 0) {//没体力了，不会再遇到战斗
        return;
    }
    
    //10步随机一次战斗事件
    if (((int)currentStep)%10 == 0){
        int x = arc4random() % 1000000;
        double roll = ((double)x)/10000.f;
        double rate5 = 0, rate4 = 0, rate3 = 0, rate2 = 0, rateEvent = 5;
        if (currentStep>WALKING_FIGHT_STAGE_II){
            stepsSinceLastFight++;
            
            if (fightCount==0){//没有战斗发生，则先判断是否遇到稀有怪
                double k = stepsSinceLastFight/(WALKING_FIGHT_STAGE_V - WALKING_FIGHT_STAGE_II);
                rate5 = k*k*10+0.1;
                if (roll<rate5){//发生稀有战斗
                    NSArray *fightList = [RORSystemService fetchFightDefineByLevel:userBase.userDetail.level andStage:[NSNumber numberWithInteger:FightStageLegend]];
                    if (fightList){
                        Fight_Define *fightEvent = (Fight_Define *)[fightList objectAtIndex:arc4random() % fightList.count];
                        [self eventDidHappened:[self makeWalkEvent:fightEvent]];
                    }
                    return;
                }
            }
            rate2 = stepsSinceLastFight*10/(WALKING_FIGHT_STAGE_III - WALKING_FIGHT_STAGE_II) + 2;
        }
        if (currentStep>WALKING_FIGHT_STAGE_III){
            rate3 = 2 + stepsSinceLastFight*3/(WALKING_FIGHT_STAGE_IV - WALKING_FIGHT_STAGE_III);
            rate2 = 1;//0.5;
        }
        if (currentStep>WALKING_FIGHT_STAGE_IV){
            rate4 = 0.6;//(currentStep - WALKING_FIGHT_STAGE_IV)*5/(WALKING_FIGHT_STAGE_V - WALKING_FIGHT_STAGE_IV) + 2;
            rate3 = 1;//1;
            rate2 = 0.4;//0.5;
        }
        
//        if (currentStep>0){
//            rate2 = 50;
//            //debug
//        }
        int fightStage = 0;
        if (roll<rate4){//高级怪
            fightStage = FightStageHard;
        } else if (roll<rate3+rate4){//中级怪
            fightStage = FightStageNormal;
        } else if (roll<rate2+rate3+rate4){//低级怪
            fightStage = FightStageEasy;
        } else if (roll<rate2+rate3+rate4 + rateEvent){//事件
            fightStage = -1;
        }
        if (fightStage>0){
            NSArray *fightList = [RORSystemService fetchFightDefineByLevel:userBase.userDetail.level andStage:[NSNumber numberWithInteger:fightStage]];
            if (fightList){
                Fight_Define *fightEvent = (Fight_Define *)[fightList objectAtIndex:arc4random() % fightList.count];
                [self eventDidHappened:[self makeWalkEvent:fightEvent]];
            }
        } else if (fightStage<0) {
            if (eventWillList){
                Action_Define *actionEvent = (Action_Define *)[eventWillList objectAtIndex:arc4random() % eventWillList.count];
                while (actionEvent==goldAction) {
                    actionEvent = (Action_Define *)[eventWillList objectAtIndex:arc4random() % eventWillList.count];
                }
                [self eventDidHappened:[self makeWalkEvent:actionEvent]];
            }
        }
    }
    
    //捡金币
    int x = arc4random() % 1000000;
    double roll = ((double)x)/10000.f;
    double delta = 1;
    if (roll < goldAction.triggerProbability.doubleValue * delta){
        [self eventDidHappened:[self makeWalkEvent:goldAction]];
        return;
    }

//    for (int i=0; i<eventWillList.count; i++){
//        Action_Define *event = (Action_Define *)[eventWillList objectAtIndex:i];
//        int x = arc4random() % 1000000;
//        double roll = ((double)x)/10000.f;
//        double delta = 1;
//
//        if (roll < event.triggerProbability.doubleValue *delta){
//            [self eventDidHappened:[self makeWalkEvent:event]];
//            return;
//        }
//    }
}

-(Walk_Event *)makeWalkEvent:(id)event{
    Walk_Event *walkEvent = [[Walk_Event alloc]init];
    if ([event isKindOfClass:[Action_Define class]]){
        Action_Define *e = (Action_Define *)event;
        walkEvent.eId = [RORDBCommon getNumberFromId:e.actionId];
        walkEvent.eType = RULE_Type_Action;
    } else if ([event isKindOfClass:[Fight_Define class]]){
        Fight_Define *e = (Fight_Define *)event;
        walkEvent.eId = e.fightId;
        walkEvent.eType = RULE_Type_Fight;
        [self calculatePowerForFight:e];
        walkEvent.eWin = [self checkWin:e];
        
        walkEvent.power = [NSNumber numberWithInteger:fightPowerCost];
        if (walkEvent.eWin.intValue>1) {//战斗胜利且得到战利品
            [self refreshItemCount:e.winGotRule];
        }
        if (walkEvent.eWin.intValue>0) {
            walkExperience += e.baseExperience.intValue;
            goldCount += e.baseGold.intValue;
        }
        userPower -= fightPowerCost;
        if (userPower<0)
            userPower = 0;
        [powerPV setProgress:((double)userPower/(double)userPowerMax) animated:YES];
        self.powerFrame.text = [NSString stringWithFormat:@"%d", userPower];
        
        fightCount++;
        stepsSinceLastFight = 0;
    }
    walkEvent.times = [NSNumber numberWithInteger:duration];
    walkEvent.lati = [NSNumber numberWithDouble:formerLocation.coordinate.latitude];
    walkEvent.longi = [NSNumber numberWithDouble:formerLocation.coordinate.longitude];
    return walkEvent;
}

-(void)refreshItemCount:(NSString *)rule{
    NSDictionary *ruleDict = [RORUtils explainActionRule:rule];
    int tmpCount=0;
    for (NSString *key in [ruleDict allKeys]) {
        if ([RORDBCommon getNumberFromId:key]){
            tmpCount += [RORDBCommon getNumberFromId:[ruleDict valueForKey:key]].intValue;
        }
    }
    itemCount += tmpCount;
    
    self.itemLabel.text = [NSString stringWithFormat:@"%d", itemCount];
    [self.itemLabel fallIn:0.5 delegate:self];
}

-(void)calculatePowerForFight:(Fight_Define *)fight{
    if (fight.monsterLevel.intValue == 5){//传说级直接减完？
        fightPowerCost = 80;
        return;
    }
    
//    userFight = userBase.userDetail.fight.doubleValue + userBase.userDetail.fightPlus.doubleValue + friendAddFight.doubleValue;
    
    if (userFight > fight.monsterMaxFight.doubleValue * 1.2){
        fightPowerCost = fight.monsterLevel.intValue * 3;
    }
    
    fightPowerCost = (userFight - fight.monsterMinFight.doubleValue) * (fight.monsterLevel.intValue * 3) /
                (fight.monsterMaxFight.doubleValue * 1.2 - fight.monsterMinFight.doubleValue) +
                fight.monsterLevel.intValue * 3;
}

-(NSNumber *)checkWin:(Fight_Define *)fight{

    //非传说级，只要用户战斗力>怪物战斗力上限则直接胜利
    if (fight.monsterLevel.intValue<5){
        if (userFight > fight.monsterMaxFight.doubleValue)
            return [NSNumber numberWithInteger:2];
    }
    
    //在耗尽体力时的奋力一战必胜，并记录奋力一击
    if (fightPowerCost>=userPower)
        return [NSNumber numberWithInteger:([fight.fightWin componentsSeparatedByString:@"|"].count-1)*10+2];
    
    if (userFight >= fight.monsterMinFight.doubleValue){
        double deltaMFight = fight.monsterMaxFight.doubleValue - fight.monsterMinFight.doubleValue;
        //传说级胜率50%-75%，普通级胜率75%-100%
        double rate = (userFight - fight.monsterMinFight.doubleValue)*25/deltaMFight + fight.monsterLevel.intValue==5?50:75;
        int x = arc4random() % 1000000;
        double roll = ((double)x)/10000.f;
        if (roll<rate){
            //胜利&战利品
            return [NSNumber numberWithInteger:2 + (arc4random() % ([fight.fightWin componentsSeparatedByString:@"|"].count-1))*10];
        } else {
            //只胜利
            return [NSNumber numberWithInteger:1 + (arc4random() % ([fight.fightWin componentsSeparatedByString:@"|"].count-1))*10];
        }
    }
    
    //战斗未发生
    fightPowerCost = 0;
    return [NSNumber numberWithInteger:-(arc4random() % ([fight.fightWin componentsSeparatedByString:@"|"].count-1))*10];
}

-(void)eventDidHappened:(Walk_Event *)event{
    if ([event.eType isEqualToString:RULE_Type_Action]){
        if (event.eId.integerValue == todayMission.triggerActionId.integerValue){
            cMissionItemQuantity++;
        }
        
        Action_Define *actionEvent = [RORSystemService fetchActionDefine:event.eId];
        if (goldAction.actionId.intValue == event.eId.intValue) {
            goldCount++;
            self.goldLabel.text= [NSString stringWithFormat:@"%d", goldCount];
            [self.goldLabel fallIn:0.5 delegate:self];
        } else {
            [self refreshItemCount:actionEvent.actionRule];
            [eventDisplayList addObject:event];
        }
        [allInOneSound addFileNametoQueue:[RORVirtualProductService getSoundFileOf:actionEvent]];
        [allInOneSound play];
    } else {
        [eventDisplayList addObject:event];
    }
    
    [eventHappenedList addObject:event];
    [eventSaveList addObject:event.transToDictionary];
}


@end
