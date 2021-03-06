//
//  RORAppDelegate.h
//  RevolUtioN
//
//  Created by Beyond on 13-4-24.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>  
#import "MobClick.h"
#import "UMSocial.h"
#import "MTA.h"
#import "MTAConfig.h"
#import "UMSocialWechatHandler.h"
#import "RORFriendService.h"
#import "RORUserServices.h"

@interface RORAppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>
{
    Reachability* hostReach;
    CMMotionManager *motionmanager;
    CLLocationManager *locationManager;
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly,strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly,strong,nonatomic) NSManagedObjectContext *rootObjectContext;
@property (readonly,strong,nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly,strong,nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSDictionary *userInfo;
@property (readonly) NetworkStatus networkStatus;
@property (strong, nonatomic, readonly) CMMotionManager *sharedMotionManager;
@property (strong, nonatomic, readonly) CLLocationManager *sharedLocationManager;

@property (nonatomic) BOOL runningStatus;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
