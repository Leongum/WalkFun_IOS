//
//  RORAppDelegate.m
//  RevolUtioN
//
//  Created by Beyond on 13-4-24.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORAppDelegate.h"
#import "Reachability.h"
#import "RORNetWorkUtils.h"

@implementation RORAppDelegate
@synthesize managedObjectContext =_managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize runningStatus;

- (id)init
{
    if(self = [super init])
    {
        runningStatus = NO;
    }
    return self;
}

- (void)saveContext{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext !=nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolvederror %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (CMMotionManager *)sharedMotionManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        motionmanager = [[CMMotionManager alloc] init];
    });
    return motionmanager;
}


- (CLLocationManager *)sharedLocationManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
    });
    return locationManager;
}

-(void)applicationDidBecomeActive:(UIApplication *)application{
    
    [UMSocialSnsService  applicationDidBecomeActive];
    application.applicationIconBadgeNumber = 0;

    [[self sharedLocationManager] setDesiredAccuracy:kCLLocationAccuracyBest];
    locationManager.distanceFilter = 1;
    NSLog(@"%u %c",[CLLocationManager  authorizationStatus],[CLLocationManager  locationServicesEnabled]);
    if (! ([CLLocationManager  locationServicesEnabled])
        || ( [CLLocationManager  authorizationStatus] == kCLAuthorizationStatusDenied))
    {
        //            [self sendAlart:GPS_SETTING_ERROR];
        NSLog(@"%@",GPS_SETTING_ERROR);
        return;
    }
    else{
        // start the compass
        [locationManager startUpdatingLocation];
    }
    
}

-(void)applicationWillResignActive:(UIApplication *)application{
    if (!runningStatus)
        [locationManager stopUpdatingLocation];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MobClick checkUpdate];
    //todo:: need remove
    //umeng analytics
    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) REALTIME channelId:nil];
    
    //sns share umeng
    [UMSocialData setAppKey:UMENG_APPKEY];
    //设置微信AppId
    [UMSocialConfig setWXAppId:@"wx44395fcdd8983c6b" url:@"http://www.cyberace.cc"];
    //打开Qzone的SSO开关
    [UMSocialConfig setSupportQzoneSSO:YES importClasses:@[[QQApiInterface class],[TencentOAuth class]]];
    //设置手机QQ的AppId，指定你的分享url，若传nil，将使用友盟的网址
    [UMSocialConfig setQQAppId:@"101022066" url:@"http://www.cyberace.cc" importClasses:@[[QQApiInterface class],[TencentOAuth class]]];
    //打开新浪微博的SSO开关
    [UMSocialConfig setSupportSinaSSO:YES];
    
    //[LingQianSDK didFinishLaunchingWithAppID:@"824cf793a15d5a76b92ca74ae533529f" applicationSecret:@"84aedf8fda5ab5bc2ee8881f17758642"];
    
    // Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the
    // method "reachabilityChanged" will be called.
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: walkfunReachabilityChangedNotification object: nil];
    
	hostReach = [Reachability reachabilityWithHostName: @"www.baidu.com"];
	[hostReach startNotifier];
    
    // Override point for customization after application launch.
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

//- (void)applicationWillResignActive:(UIApplication *)application
//{
//    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
//    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
//}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Core Data stack



// Returns the managed object context for the application.

// If the context doesn't already exist, it is created and bound to thepersistent store coordinator for the application.

- (NSManagedObjectContext *)managedObjectContext

{
    
    if (_managedObjectContext !=nil) {
        
        return _managedObjectContext;
        
    }
    
    
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    
    if (coordinator != nil) {
        
        _managedObjectContext = [[NSManagedObjectContext alloc]init];
        
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
        
    }
    
    return _managedObjectContext;
    
}



// Returns the managed object model for the application.

// If the model doesn't already exist, it is created from the application'smodel.

- (NSManagedObjectModel *)managedObjectModel

{
    
    if (_managedObjectModel !=nil) {
        
        return _managedObjectModel;
        
    }
    
    //这里一定要注意，这里的iWeather就是你刚才建立的数据模型的名字，一定要一致。否则会报错。
//    NSString *path = @"RORCoreData";
//    NSURL *modelURL = [NSURL fileURLWithPath:[path stringByAppendingPathExtension:@"momd"]];
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"RORCoreData" withExtension:@"mom"];
    
    _managedObjectModel = [[NSManagedObjectModel alloc]initWithContentsOfURL:modelURL];
    
    return _managedObjectModel;
    
}



// Returns the persistent store coordinator for the application.

// If the coordinator doesn't already exist, it is created and theapplication's store added to it.

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator

{
    
    if (_persistentStoreCoordinator !=nil) {
        
        return _persistentStoreCoordinator;
        
    }
    

    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    
    //这里的iWeaher.sqlite，也应该与数据模型的名字保持一致。
    
    NSURL *storeURL = [[self applicationDocumentsDirectory]URLByAppendingPathComponent:@"RORCoreData.sqlite"];
    
    
    
    NSError *error = nil;
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        
        abort();
        
    }
    
    
    
    return _persistentStoreCoordinator;
    
}

//Called by Reachability whenever status changes.
- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    [RORNetWorkUtils updateNetWorkStatus:[curReach currentReachabilityStatus]];
}

#pragma mark - Application's Documents directory



// Returns the URL to the application's Documents directory.

- (NSURL*)applicationDocumentsDirectory

{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
}

#pragma mark - core location delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
}

@end
