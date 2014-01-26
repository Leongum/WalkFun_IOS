//
//  RORNetWorkUtils.m
//  RevolUtioN
//
//  Created by leon on 13-8-29.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORNetWorkUtils.h"
#import "RORRunHistoryServices.h"

static NetworkStatus networkStatus = NotReachable;

static BOOL doUploadable = NO;

static BOOL isConnectioned = NO;

@implementation RORNetWorkUtils

+ (BOOL) getDoUploadable{
    return doUploadable;
}

+ (BOOL) getIsConnetioned{
    return isConnectioned;
}

+ (void) initCheckNetWork{
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    [self updateNetWorkStatus:[reach currentReachabilityStatus]];
}

+ (void) updateNetWorkStatus:(NetworkStatus) newNetWorkStatus{
    doUploadable = NO;
    BOOL isExistenceNetwork = YES;
    switch (newNetWorkStatus) {
        case NotReachable:
            isExistenceNetwork = NO;
            break;
        case ReachableViaWiFi:
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [RORRunHistoryServices uploadRunningHistories];
                dispatch_async(dispatch_get_main_queue(), ^{
                });
            });
            isExistenceNetwork = YES;
            doUploadable = YES;
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            NSMutableDictionary *settingDict = [RORUserUtils getUserSettingsPList];
            NSString *updatemode = [settingDict valueForKey:@"uploadMode"];
            if([DEFAULT_NET_WORK_MODE isEqualToString: updatemode]){
                doUploadable = YES;
            }
            break;
    }
    isConnectioned = isExistenceNetwork;
    networkStatus = newNetWorkStatus;
}

@end
