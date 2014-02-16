//
//  RORFirstViewController.m
//  RevolUtioN
//
//  Created by Beyond on 13-4-24.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORFirstViewController.h"
#import "FTAnimation.h"

//#define CHARACTOR_FRAME_NORMAL CGRectMake(10,300,280,183)
//#define CHARACTOR_FRAME_RATINA CGRectMake(10,300,280,183)

#define WEATHER_BUTTON_INITIAL_FRAME CGRectMake(-100, 27, 100, 40)
#define LOGIN_BUTTON_INITIAL_FRAME CGRectMake(320, 14, 210, 69)

#define RUN_BUTTON_FRAME_NORMAL CGRectMake(92, 120, 136, 60)
#define RUN_BUTTON_FRAME_RATINA CGRectMake(92, 160, 136, 60)
#define CHALLENGE_BUTTON_FRAME_NORMAL CGRectMake(0, 190, 320, 94)
#define CHALLENGE_BUTTON_FRAME_RATINA CGRectMake(0, 250, 320, 94)

@interface RORFirstViewController ()

@end

@implementation RORFirstViewController
@synthesize weatherInfoButtonView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [RORUtils setFontFamily:CHN_PRINT_FONT forView:self.view andSubViews:YES];
    
    [self prepareControlsForAnimation];
    
    //初始化按钮位置
    [self initControlsLayout];
    
    [self checkLevelUp];
    
    weatherInformation = [NSString stringWithFormat:@"天气信息获取中"];
    
    UIImage *image = [UIImage imageNamed:@"main_trafficlight_none.png"];
    [weatherInfoButtonView setImage:image forState:UIControlStateNormal];
    
    [self.userInfoView addTarget:self action:@selector(userInfoViewClick:) forControlEvents:UIControlEventTouchUpInside];
    
//    //sync system data
//    NSDate * lastupdateTime = [RORUtils getDateFromString:[RORUserUtils getLastUpdateTime:@"lastSyncSystemDataTime"]];
//    if([[NSDate date] timeIntervalSinceDate:lastupdateTime] >= 86400){
//        [RORUserUtils syncSystemData];
//    }

    [LingQianSDK trackActionWithName:@"visit"];
}

-(void)viewWillDisappear:(BOOL)animated{
    [locationManager stopUpdatingLocation];
    [super viewWillDisappear:animated];
}

-(void)checkLevelUp{
    NSMutableDictionary *settinglist = [RORUserUtils getUserSettingsPList];
    NSNumber *userLevel = [settinglist valueForKey:@"userLevel"];
    User_Detail *userAttr = [RORUserServices fetchUserDetailByUserId:[RORUserUtils getUserId]];
    if (userLevel.integerValue<userAttr.level.integerValue){
        [self performLevelUp];
    }
}

-(void)performLevelUp{
    
}

-(void)prepareControlsForAnimation{
    hasAnimated = NO;
    
//    self.chactorView.alpha = 0;
//    self.charactorWindView.alpha = 0;
//    self.weatherInfoButtonView.alpha = 0;
//    self.userInfoView.alpha = 0;
//    self.runButton.alpha = 0;
//    self.challenge.alpha = 0;
//    self.historyButton.alpha = 0;
//    self.settingButton.alpha = 0;
//    self.mallButton.alpha = 0;
//    self.friendsButton.alpha = 0;
    
    self.chactorView.alpha = 1;
    self.charactorWindView.alpha = 1;
    self.weatherInfoButtonView.alpha = 1;
    self.userInfoView.alpha = 1;
    self.runButton.alpha = 1;
    self.challenge.alpha = 1;
    self.historyButton.alpha = 1;
    self.settingButton.alpha = 1;
    self.mallButton.alpha = 1;
    self.friendsButton.alpha = 1;
}

- (void)initLocationServcie{
    userLocation = nil;
    wasFound = NO;
    
//    locationManager = [(RORAppDelegate *)[[UIApplication sharedApplication] delegate] sharedLocationManager];
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    
    [locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    if (! ([CLLocationManager  locationServicesEnabled])
        || ( [CLLocationManager  authorizationStatus] == kCLAuthorizationStatusDenied))
    {
        [self sendAlart:GPS_SETTING_ERROR];
        return;
    }
    else{
        // start the compass
        [locationManager startUpdatingLocation];
    }
}

#pragma mark - core location delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if([newLocation.timestamp timeIntervalSinceNow] <= (60 * 2)){
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

- (void)initControlsLayout{
    [self.backButton setAlpha:0];
    
//    CGRect rx = [ UIScreen mainScreen ].applicationFrame;
//    if (rx.size.height == 460){
//        self.runButton.frame = RUN_BUTTON_FRAME_NORMAL;
//        self.challenge.frame = CHALLENGE_BUTTON_FRAME_NORMAL;
//    } else {
//        self.runButton.frame = RUN_BUTTON_FRAME_RATINA;
//        self.challenge.frame = CHALLENGE_BUTTON_FRAME_RATINA;
//    }
}

- (void)initPageData{
    //    [self.loginButton.titleLabel setFont: [UIFont fontWithName:@"FZKaTong-M19S" size:20]];
    //    [self.levelLabel setFont:[UIFont fontWithName:@"FZKaTong-M19S" size:15]];
    //    [self.scoreLabel setFont:[UIFont fontWithName:@"FZKaTong-M19S" size:15]];
    //    [self.usernameLabel setFont:[UIFont fontWithName:@"FZKaTong-M19S" size:20]];
    
    //初始化用户名
    NSNumber *thisUserId = [RORUserUtils getUserId];
    if (thisUserId.integerValue>=0){
        self.loginButton.alpha = 0;
        
        userInfo = [RORUserServices fetchUser:[RORUserUtils getUserId]];
        self.usernameLabel.text = userInfo.nickName;
        int l = [RORUtils convertToInt:self.usernameLabel.text];
        if (l<=3)
            [self.usernameLabel setFont:[UIFont boldSystemFontOfSize:22]];
        if (l>=8)
            [self.usernameLabel setFont:[UIFont boldSystemFontOfSize:16]];
        self.levelLabel.text = [NSString stringWithFormat:@"Lv. %d", userInfo.userDetail.level.integerValue];
//        self.scoreLabel.text = [NSString stringWithFormat:@"%d", userInfo.attributes.scores.integerValue];
        self.userIdLabel.text = [NSString stringWithFormat:@"%@号选手",[RORUtils addEggache:thisUserId]];
    } else {
        self.loginButton.alpha = 1;
    }
    
//    planNext = [RORPlanService fetchUserRunningPlanHistory];
//    if (planNext){
//        NSInteger ld = [RORPlanService fillCountDownIconForView:self.trainingCountDownView withPlanNext:planNext];
//        self.trainingCountDownView.alpha = ld<0?0:1;
//    } else
//        self.trainingCountDownView.alpha = 0;
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self initPageData];
    if (!hasAnimated){
        hasAnimated = YES;
//        [self charactorAnimation];
        
//        [self controlsInAction];
    }
    //    [Animations zoomIn:self.chactorView andAnimationDuration:2 andWait:YES];
    [self initLocationServcie];
    
}

- (IBAction)segueToLogin:(id)sender{
    [self performSegueWithIdentifier:@"loginSegue" sender:self];
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
                    weatherInformation = [NSString stringWithFormat:@"%@\n AQI: %d%@  ", weatherInformation,  pm25,[pm25info objectForKey:@"quality"]];
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
    if ([destination respondsToSelector:@selector(setSelection:)]){
        [destination setValue:self.userName forKey:@"userName"];
        [destination setValue:self.userId forKey:@"userId"];
    }
    if ([destination respondsToSelector:@selector(setMissionType:)]){
        [destination setValue:[NSNumber numberWithInteger:MissionTypeEasy] forKey:@"missionType"];
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
    
    [self setRunButton:nil];
    [self setChallenge:nil];
    [self setUsernameLabel:nil];
    [self setLevelLabel:nil];
    [self setScoreLabel:nil];
    [self setUserInfoView:nil];
    [self setLoginButton:nil];
    [self setChactorView:nil];
    [self setHistoryButton:nil];
    [self setSettingButton:nil];
    [self setCharactorWindView:nil];
    [super viewDidUnload];
}

-(void)charactorAnimation{
    self.chactorView.alpha = 1;
    [self.chactorView popIn:2 delegate:self startSelector:nil stopSelector:@selector(controlsInAction)];

    [Animations moveUp:self.chactorView andAnimationDuration:1 andWait:NO andLength:20];

    self.charactorWindView.alpha = 1;
    [self.charactorWindView fadeIn:4 delegate:self];
}

-(void)controlsInAction{
    //    self.weatherInfoButtonView
    
    [self.runButton fallIn:0.5 delegate:self];
    [self.challenge fallIn:0.5 delegate:self];
    self.runButton.alpha = 1;
    self.challenge.alpha = 1;
    //    [Animations fadeIn:self.runButton andAnimationDuration:1 toAlpha:1 andWait:NO];
    //    [Animations fadeIn:self.challenge andAnimationDuration:1 toAlpha:1 andWait:YES];
    self.historyButton.alpha =1;
    self.settingButton.alpha = 1;
    self.mallButton.alpha = 1;
    self.friendsButton.alpha = 1;
    [self.historyButton slideInFrom:kFTAnimationRight duration:0.5 delegate:self];
    [self.settingButton slideInFrom:kFTAnimationLeft duration:0.5 delegate:self];
    [self.mallButton fadeIn:0.5 delegate:self];
    [self.friendsButton fadeIn:0.5 delegate:self];
    //    [Animations fadeIn:self.settingButton andAnimationDuration:1.5 toAlpha:1 andWait:YES];
    self.weatherInfoButtonView.alpha = 1;
    self.userInfoView.alpha = 1;
    [self.weatherInfoButtonView slideInFrom:kFTAnimationLeft duration:0.5 delegate:self];
    [self.userInfoView slideInFrom:kFTAnimationRight duration:0.5 delegate:self];
//    [Animations moveRight:self.weatherInfoButtonView andAnimationDuration:0.4 andWait:NO andLength:110];
//    [Animations moveLeft:self.userInfoView andAnimationDuration:0.4 andWait:NO andLength:220];
    
//    [Animations moveLeft:self.weatherInfoButtonView andAnimationDuration:0.1 andWait:NO andLength:10];
//    [Animations moveRight:self.userInfoView andAnimationDuration:0.1 andWait:NO andLength:10];
}

- (IBAction)weatherPopAction:(id)sender{
    if ([weatherInformation rangeOfString:@"失败"].location == NSNotFound){
        [self sendNotification:weatherInformation];
    } else
        [self sendAlart:weatherInformation];
//    [SVProgressHUD dismiss];
    //    [self charactorAnimation];
}

-(IBAction)userInfoViewClick:(id)sender{
    //[self sendNotification:[NSString stringWithFormat:@"选手编号: %@\n金币: %d\n",[RORUtils addEggache:[RORUserUtils getUserId]], userInfo.attributes.scores.intValue]];
}

- (IBAction)normalRunAction:(id)sender {
}

- (IBAction)challengeRunAction:(id)sender{
}

- (IBAction)mallUnderDeveloping:(id)sender {
    [LingQianSDK openRewardStore];
    //[self sendNotification:@"【装备商城】\n\n正在哼哧哼哧开发中"];
}
- (IBAction)friendsUnderDeveloping:(id)sender {
//    [self sendNotification:@"【我的跑友】\n\n正在窟嚓窟嚓开发中"];
}

- (IBAction)trainingAction:(id)sender {
    UIStoryboard *secondStoryboard = [UIStoryboard storyboardWithName:@"TrainingStoryboard" bundle:nil];
    UIViewController *trainingViewController = [secondStoryboard instantiateViewControllerWithIdentifier:@"TrainingMainViewController"];

    [self.navigationController pushViewController:trainingViewController animated:YES];
}

- (IBAction)friendsAction:(id)sender {
    
    UIStoryboard *secondStoryboard = [UIStoryboard storyboardWithName:@"FriendsStoryboard" bundle:nil];
    UIViewController *trainingViewController = [secondStoryboard instantiateViewControllerWithIdentifier:@"FriendsMainViewController"];
    
    [self.navigationController pushViewController:trainingViewController animated:YES];
}

@end
