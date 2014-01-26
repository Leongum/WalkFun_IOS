//
//  RORFirstViewController.h
//  RevolUtioN
//
//  Created by Beyond on 13-4-24.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RORLoginViewController.h"
#import "RORThirdPartyService.h"
#import "RORAppDelegate.h"
#import "RORUserUtils.h"
#import "Animations.h"
#import "User_Base.h"
#import "RORNormalButton.h"
#import <MapKit/MapKit.h>
#import "RORViewController.h"

@interface RORFirstViewController : RORViewController<CLLocationManagerDelegate>{
    BOOL wasFound;
    CLLocation *userLocation;
    NSString *cityName;
    NSString *weatherInformation;
    BOOL hasAnimated;
    User_Base *userInfo;
    
    CLLocationManager *locationManager;
}

//@property (strong,nonatomic)NSManagedObjectContext *context;
@property (copy, nonatomic) NSString *userName;
@property (nonatomic) NSNumber *userId;
@property (strong, nonatomic) IBOutlet RORNavigationButton *runButton;
@property (strong, nonatomic) IBOutlet RORNavigationButton *trainingButton;
@property (strong, nonatomic) IBOutlet RORNavigationButton *challenge;
//@property (strong, nonatomic) IBOutlet UIImageView *testView;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *levelLabel;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UIControl *userInfoView;
@property (strong, nonatomic) IBOutlet UILabel *userIdLabel;

@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIButton *weatherInfoButtonView;
@property (strong, nonatomic) IBOutlet UIImageView *chactorView;
@property (strong, nonatomic) IBOutlet UIImageView *charactorWindView;
@property (strong, nonatomic) IBOutlet RORNavigationButton *historyButton;
@property (strong, nonatomic) IBOutlet RORNavigationButton *settingButton;
@property (strong, nonatomic) IBOutlet RORNavigationButton *mallButton;
@property (strong, nonatomic) IBOutlet RORNavigationButton *friendsButton;

@property (strong, nonatomic) IBOutlet UIView *trainingCountDownView;

- (IBAction)normalRunAction:(id)sender;
- (IBAction)challengeRunAction:(id)sender;

@end
