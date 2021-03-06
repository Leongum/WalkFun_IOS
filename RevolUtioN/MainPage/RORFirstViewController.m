//
//  RORFirstViewController.m
//  RevolUtioN
//
//  Created by Beyond on 13-4-24.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORFirstViewController.h"
#import "FTAnimation.h"

#define WEATHER_BUTTON_INITIAL_FRAME CGRectMake(-100, 27, 100, 40)
#define LOGIN_BUTTON_INITIAL_FRAME CGRectMake(320, 14, 210, 69)
#define CUSTOM_COLOR_RED [UIColor colorWithRed:128.f/255.f green:64.f/255.f blue:0 alpha:1]
@interface RORFirstViewController ()

@end

@implementation RORFirstViewController
@synthesize weatherInfoButtonView;

- (void)viewDidLoad
{
    titleView = self.selfTitleView;
    
    [super viewDidLoad];
    [self prepareControlsForAnimation];
    
    //初始化按钮位置
    [self initControlsLayout];
    
    weatherInformation = [NSString stringWithFormat:@"天气信息获取中"];
    
    UIImage *image = [UIImage imageNamed:@"main_trafficlight_none.png"];
    [weatherInfoButtonView setImage:image forState:UIControlStateNormal];
    
    //载入人物视图
    mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:[NSBundle mainBundle]];
    charatorViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"CharatorViewController"];
    UIView *charview = charatorViewController.view;
    CGRect charframe = self.charatorView.frame;
    if (charframe.size.height<568){
        double nw = charframe.size.height * 320 / 568;
        charframe = CGRectMake(0, 0, nw, charframe.size.height);
    }
    charview.frame = charframe;
    charview.center = self.charatorView.center;
    
    [self addChildViewController:charatorViewController];
    [self.view addSubview:charview];
    [self.view sendSubviewToBack:charview];
    [charatorViewController didMoveToParentViewController:self];
    
    lastWeatherUpdateTime = nil;
    
    [self.badgeView addTarget:self action:@selector(badgeViewAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //启动个人页面中，体力数值的刷新timer
    [NSThread detachNewThreadSelector:@selector(startTimer) toTarget:self withObject:nil];
}

- (void)initControlsLayout{
    [self.backButton setAlpha:0];
}

- (void)initPageData{
    //初始化用户名
    NSNumber *thisUserId = [RORUserUtils getUserId];
    if (thisUserId.integerValue>=0){
        userInfo = [RORUserServices fetchUser:[RORUserUtils getUserId]];
        self.usernameLabel.text = userInfo.nickName;
        int l = [RORUtils convertToInt:self.usernameLabel.text];
        if (l<=3)
            [self.usernameLabel setFont:[UIFont boldSystemFontOfSize:24]];
        if (l>=8)
            [self.usernameLabel setFont:[UIFont boldSystemFontOfSize:18]];
        self.levelLabel.text = [NSString stringWithFormat:@"Lv. %ld", (long)userInfo.userDetail.level.integerValue];
        
        [self.badgeView setFriendFightWin:userInfo.userDetail.friendFightWin];
        
        [RORUtils setFontFamily:APP_FONT forView:self.usernameLabel andSubViews:YES];
    }
    if ([charatorViewController respondsToSelector:@selector(setUserBase:)]){
        [charatorViewController setValue:[RORUserServices fetchUser:[RORUserUtils getUserId]] forKey:@"userBase"];
    }
    [charatorViewController viewWillAppear:NO];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initPageData];
    if (!lastWeatherUpdateTime || [lastWeatherUpdateTime timeIntervalSinceNow]>1800){
        [self initLocationServcie];
        lastWeatherUpdateTime = [NSDate date];
    }
    [self checkMissionProcess];
    [MobClick beginLogPageView:@"RORFirstViewController"];
    [MTA trackPageViewBegin:@"RORFirstViewController"];
}

-(void)viewWillDisappear:(BOOL)animated{
    [locationManager stopUpdatingLocation];
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"RORFirstViewController"];
}

-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [MTA trackPageViewEnd:@"RORFirstViewController"];
}

-(void)checkMissionProcess{
    NSMutableDictionary *userInfoList = [RORUserUtils getUserInfoPList];
    
    //如果已经集满了三次日常任务，但没有兑换奖励，则接不到新的任务
    NSNumber *missionProcess = (NSNumber *)[userInfoList objectForKey:@"missionProcess"];
    missionDone = missionProcess.intValue;
    
    switch (missionDone) {
        case 0:{
            [self.missionStoneButton setBackgroundImage:[UIImage imageNamed:@"missionStone_0.png"] forState:UIControlStateNormal];
            break;
        }
        case 1:{
            [self.missionStoneButton setBackgroundImage:[UIImage imageNamed:@"missionStone_1.png"] forState:UIControlStateNormal];
            break;
        }
        case 2:{
            [self.missionStoneButton setBackgroundImage:[UIImage imageNamed:@"missionStone_2.png"] forState:UIControlStateNormal];
            break;
        }
        case 3:{
            [self.missionStoneButton setBackgroundImage:[UIImage imageNamed:@"missionStone_3.png"] forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }
    [self.missionStoneButton setEnabled:YES];
}

//3次任务换随机奖励
- (IBAction)missionStoneAction:(id)sender {

    if (missionDone<3){
        NSDictionary *dict = @{@"currentTimes" : [NSNumber numberWithInt:missionDone]};
        [MobClick event:@"rewardClick" attributes:dict];
        [MTA trackCustomKeyValueEvent:@"rewardClick" props:dict];
        [self sendNotification:[NSString stringWithFormat:@"再完成%d次日常任务领取奖励", 3-missionDone]];
        return;
    }
    NSDictionary *dict = @{@"currentTimes" : [NSNumber numberWithInt:3]};
    [MobClick event:@"rewardClick" attributes:dict];
    [MTA trackCustomKeyValueEvent:@"rewardClick" props:dict];
    [self startIndicator:self];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        Reward_Details *thisReward = [RORUserServices getRandomReward:userInfo.userId];
        if (!thisReward) {
            thisReward = [RORUserServices getRandomReward:userInfo.userId];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
        if (thisReward) {
            MissionStoneCongratsViewController *missionStoneCongratsViewController =  [mainStoryboard instantiateViewControllerWithIdentifier:@"MissionStoneCongratsViewController"];
            CoverView *congratsCoverView = (CoverView *)missionStoneCongratsViewController.view;
            [congratsCoverView addCoverBgImage:[RORUtils captureScreen] grayed:YES];
            [[self parentViewController].view addSubview:congratsCoverView];
            [congratsCoverView appear:self];
            
            if (thisReward.rewardMoney){
                [missionStoneCongratsViewController showGold:thisReward.rewardMoney];
            } else {
                [missionStoneCongratsViewController showItem:[RORVirtualProductService fetchVProduct:thisReward.rewardPropId]];
            }
            
            //重置
            NSMutableDictionary *userInfoList = [RORUserUtils getUserInfoPList];
            [userInfoList setObject:[NSNumber numberWithInteger:0] forKey:@"missionProcess"];
            [RORUserUtils writeToUserInfoPList:userInfoList];
            
            [self checkMissionProcess];
            
            [self endIndicator:self];
        } else {
            [self sendAlart:@"网络错误！"];
        }
        });
    });
}

-(void)prepareControlsForAnimation{
    self.weatherInfoButtonView.alpha = 1;
    self.userInfoView.alpha = 1;
}

- (void)initLocationServcie{
    userLocation = nil;
    wasFound = NO;
    
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    
    [locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    if (! ([CLLocationManager  locationServicesEnabled])
        || ( [CLLocationManager  authorizationStatus] == kCLAuthorizationStatusDenied))
    {
        [self sendAlart:@"定位失败，请打开GPS定位功能"];
        return;
    }
    else{
        // start the compass
        [locationManager startUpdatingLocation];
    }
}

-(IBAction)badgeViewAction:(id)sender{
    [MobClick event:@"honorClick"];
    [MTA trackCustomKeyValueEvent:@"honorClick" props:nil];
    [self sendNotification:@"通过探险过程中的“好友战斗”胜利获得。"];
}

#pragma mark - core location delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if([newLocation.timestamp timeIntervalSinceNow] < (60 * 2)){
        userLocation = newLocation;
        if (!wasFound){
            wasFound = YES;
            
            NSString *userAddressString = [NSString stringWithFormat:@"%f,%f",newLocation.coordinate.latitude, newLocation.coordinate.longitude];
            NSDictionary *saveDict = [NSDictionary dictionaryWithObjectsAndKeys:userAddressString, @"UserLocationCoordinate", nil];
            [RORUserUtils writeToUserInfoPList:saveDict];
            
            [self getCitynameByLocation];
            [locationManager stopUpdatingLocation];
        }
    }
}

-(void)getCitynameByLocation {
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:userLocation completionHandler:^(NSArray *placemarks, NSError *error){
        CLPlacemark *placemark = (CLPlacemark *)[placemarks objectAtIndex:0];
        NSString *userAddressString = [NSString stringWithFormat:@"%@, %@, %@, %@, %@, %@", placemark.country, placemark.administrativeArea, placemark.subLocality, placemark.thoroughfare, placemark.subThoroughfare, placemark.name];
        NSLog(@"%@", userAddressString);
        cityName = placemark.subLocality;
        NSString * provinceName = placemark.administrativeArea;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *weatherInfo = [RORThirdPartyService syncWeatherInfo:[RORUtils getCitycodeByCityname:cityName withProvince:provinceName]];
            NSDictionary *pm25info =[RORThirdPartyService syncPM25Info:cityName withProvince:provinceName];
            dispatch_async(dispatch_get_main_queue(), ^{
                weatherInformation = @"";
                int temp = INT16_MAX;
                int pm25 = INT16_MAX;
                if (weatherInfo != nil){
                    temp = [[weatherInfo objectForKey:@"temp"] integerValue];
                    weatherInformation = [NSString stringWithFormat:@"%@%@  %d℃  %@%@  ", weatherInformation, cityName, temp, [weatherInfo objectForKey:@"WD"],[weatherInfo objectForKey:@"WS"]
                                          ];
                }
                if(pm25info != nil){
                    pm25 = [[pm25info objectForKey:@"aqi"] integerValue];
                    weatherInformation = [NSString stringWithFormat:@"%@\n PM2.5: %@  ", weatherInformation, [pm25info objectForKey:@"pm2_5"]];
                }
                int index = -1;
                if(temp < 38 && pm25 < 300){
                    index = (100-pm25/3)*0.75 +(100-fabs(temp - 22)*5)*0.25;
                }
                if (index>=0) {
                    weatherInformation = [NSString stringWithFormat:@"%@总分: %d", weatherInformation, index];
                }
                if (index <0) {
                    UIImage *image = [UIImage imageNamed:@"main_trafficlight_none.png"];
                    [weatherInfoButtonView setImage:image forState:UIControlStateNormal];
                    if (temp == INT16_MAX) {
                        weatherInformation = [NSString stringWithFormat:@"天气信息获取失败"];
                    } else if (pm25==INT16_MAX){
                        weatherInformation = [NSString stringWithFormat:@"%@\n空气质量信息获取失败", weatherInformation];
                    } else {
                        weatherInformation = [NSString stringWithFormat:@"%@\n空气质量信息获取失败", weatherInformation];
                    }
                }
                else if (temp < 0 || temp > 38 || pm25>250 || index<50){
                    UIImage *image = [UIImage imageNamed:@"main_trafficlight_red.png"];
                    [weatherInfoButtonView setImage:image forState:UIControlStateNormal];
                }
                else if (index > 75){
                    UIImage *image = [UIImage imageNamed:@"main_trafficlight_green.png"];
                    [weatherInfoButtonView setImage:image forState:UIControlStateNormal];
                }
                else{
                    UIImage *image = [UIImage imageNamed:@"main_trafficlight_yellow.png"];
                    [weatherInfoButtonView setImage:image forState:UIControlStateNormal];
                }
            });
        });
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *destination = segue.destinationViewController;
    if ([destination respondsToSelector:@selector(setDelegate:)]){
        [destination setValue:self forKey:@"delegate"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setWeatherInfoButtonView:nil];
    [self setUserName:nil];
    [self setUserId:nil];
    [self setUsernameLabel:nil];
    [self setLevelLabel:nil];
    [self setUserInfoView:nil];
    [super viewDidUnload];
}

- (IBAction)weatherPopAction:(id)sender{
    [MobClick event:@"weatherClick"];
     [MTA trackCustomKeyValueEvent:@"weatherClick" props:nil];
    if ([weatherInformation rangeOfString:@"失败"].location == NSNotFound){
        [self sendNotification:weatherInformation];
    } else
        [self sendAlart:weatherInformation];
}


-(void)startTimer{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:120 target:self selector:@selector(timerDot) userInfo:nil repeats:YES];
    repeatingTimer = timer;
    [[NSRunLoop currentRunLoop] run];
}

- (void)timerDot{
    [self performSelectorOnMainThread:@selector(displayTimerInfo) withObject:nil waitUntilDone:YES];
}

-(void)displayTimerInfo{
    [charatorViewController refreshUserData];
}


@end