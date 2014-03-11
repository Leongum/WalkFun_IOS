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
#import "MainPageViewController.h"
#import "CharatorViewController.h"
#import "LevelUpCongratsViewController.h"

@interface RORFirstViewController : MainPageViewController<CLLocationManagerDelegate>{
    BOOL wasFound;
    CLLocation *userLocation;
    NSString *cityName;
    NSString *weatherInformation;
    User_Base *userInfo;
    
    CLLocationManager *locationManager;
    UIViewController *charatorViewController;
}
@property (strong, nonatomic) IBOutlet UIView *selfTitleView;

//@property (strong,nonatomic)NSManagedObjectContext *context;
@property (copy, nonatomic) NSString *userName;
@property (nonatomic) NSNumber *userId;
@property (strong, nonatomic) IBOutlet UIButton *runButton;
//@property (strong, nonatomic) IBOutlet UIImageView *testView;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *levelLabel;
@property (strong, nonatomic) IBOutlet UIControl *userInfoView;
//todo
@property (strong, nonatomic) IBOutlet UILabel *fatLabel;
@property (strong, nonatomic) IBOutlet UILabel *healthLabel;
@property (strong, nonatomic) IBOutlet UIButton *weatherInfoButtonView;
@property (strong, nonatomic) IBOutlet UIView *charatorView;
@property (strong, nonatomic) IBOutlet UIButton *msgButton;


@end
