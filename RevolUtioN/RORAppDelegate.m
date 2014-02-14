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

@synthesize viewDelegate = _viewDelegate;

- (id)init
{
    if(self = [super init])
    {
        _viewDelegate = [[RORShareViewDelegate alloc] init];
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

- (void)initializePlat
{
    /**
     连接新浪微博开放平台应用以使用相关功能，此应用需要引用SinaWeiboConnection.framework
     http://open.weibo.com上注册新浪微博开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectSinaWeiboWithAppKey:@"1650188941"
                               appSecret:@"1062ef996950870fc7322fc1a4d6716e"
                             redirectUri:@"http://www.cyberace.cc"];
    
    /**
     连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
     http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
     **/
    [ShareSDK connectWeChatWithAppId:@"wxfff11cf8dc68b3a8" wechatCls:[WXApi class]];
    
    
    /**
     连接腾讯微博开放平台应用以使用相关功能，此应用需要引用TencentWeiboConnection.framework
     http://dev.t.qq.com上注册腾讯微博开放平台应用，并将相关信息填写到以下字段
     
     如果需要实现SSO，需要导入libWeiboSDK.a，并引入WBApi.h，将WBApi类型传入接口
     **/
    [ShareSDK connectTencentWeiboWithAppKey:@"801401136"
                                  appSecret:@"b90baa51d8e2bd0a5ab5a7c1a9115ab8"
                                redirectUri:@"http://www.cyberace.cc"
                                   wbApiCls:[WBApi class]];
    /**
     连接QQ空间应用以使用相关功能，此应用需要引用QZoneConnection.framework
     http://connect.qq.com/intro/login/上申请加入QQ登录，并将相关信息填写到以下字段
     
     如果需要实现SSO，需要导入TencentOpenAPI.framework,并引入QQApiInterface.h和TencentOAuth.h，将QQApiInterface和TencentOAuth的类型传入接口
     **/
    [ShareSDK connectQZoneWithAppKey:@"100504316"
                           appSecret:@"41796cc32c1dec21061ab7a9d221cd34"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    /**
     连接人人网应用以使用相关功能，此应用需要引用RenRenConnection.framework
     http://dev.renren.com上注册人人网开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectRenRenWithAppId:@"239934"
                              appKey:@"b2c37b4889c9434d8e19086c1b4d6074"
                           appSecret:@"42530538fea74a9f9ccd169d3cacb88a"
                   renrenClientClass:[RennClient class]];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /**
     注册SDK应用，此应用请到http://www.sharesdk.cn中进行注册申请。
     此方法必须在启动时调用，否则会限制SDK的使用。
     **/
    [ShareSDK registerApp:@"738183f3e91"];
    [LingQianSDK didFinishLaunchingWithAppID:@"824cf793a15d5a76b92ca74ae533529f" applicationSecret:@"84aedf8fda5ab5bc2ee8881f17758642"];
    
    [self initializePlat];
    
    // Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the
    // method "reachabilityChanged" will be called.
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: walkfunReachabilityChangedNotification object: nil];
    
	hostReach = [Reachability reachabilityWithHostName: @"www.baidu.com"];
	[hostReach startNotifier];
    
    // Override point for customization after application launch.
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
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

//- (void)applicationDidBecomeActive:(UIApplication *)application
//{
//    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//}

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
