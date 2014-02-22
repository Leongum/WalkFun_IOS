//
//  RORConstant.h
//  RevolUtioN
//
//  Created by Beyond on 13-6-14.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef URLS
//define test service host
#define SERVICE_HOST @"http://121.199.56.231:8080/walkfun/service/api"

#define CURRENT_VERSION_MAIN 1
#define CURRENT_VERSION_SUB 0

// --- user api ---
#define USER_LOGIN_URL [SERVICE_HOST stringByAppendingString:@"/account/login/%@/%@"]
#define USER_GETINFO_BY_ID_URL [SERVICE_HOST stringByAppendingString:@"/account/get/%@?lastUpdateTime=%@"]
#define USER_REGISTER_URL [SERVICE_HOST stringByAppendingString:@"/account/create"]
#define USER_BASE_UPDATE_URL [SERVICE_HOST stringByAppendingString:@"/account/update/base/%@"]
#define USER_DETAIL_UPDATE_URL [SERVICE_HOST stringByAppendingString:@"/account/update/detail/%@"]

// --- firend api ---
#define FRIEND_CREATE_OR_UPDATE_URL [SERVICE_HOST stringByAppendingString:@"/account/friends/create/%@"]
#define FRIEND_GET_URL [SERVICE_HOST stringByAppendingString:@"/account/friends/get/%@?lastUpdateTime=%@"]
#define FRIEND_SEARCH_URL [SERVICE_HOST stringByAppendingString:@"/account/search/get/%@"]
#define FRIEND_SORT_UPDATE_URL [SERVICE_HOST stringByAppendingString:@"/account/friendsort/get/%@?lastUpdateTime=%@"]
#define FRIEND_RECOMMEND_URL [SERVICE_HOST stringByAppendingString:@"/account/friends/recommend/%@"]//page no form 0

// --- action api ---
#define ACTION_CREATE_ACTION_URL [SERVICE_HOST stringByAppendingString:@"/account/action/create/%@"]
#define ACTION_GET_ACTION_URL [SERVICE_HOST stringByAppendingString:@"/account/action/get/%@"]

// --- prop api ---
#define PROP_GET_URL [SERVICE_HOST stringByAppendingString:@"/account/props/get/%@?lastUpdateTime=%@"]
#define PROP_CREATE_URL [SERVICE_HOST stringByAppendingString:@"/account/props/create/%@"]

// --- system api ---
#define SYSTEM_VERSION_URL [SERVICE_HOST stringByAppendingString:@"/system/version/get/%@"]
#define SYSTEM_SYSTEM_MESSAGE_URL [SERVICE_HOST stringByAppendingString:@"/system/message/get/%@"]
#define SYSTEM_RECOMMEND_APP_URL [SERVICE_HOST stringByAppendingString:@"/system/recommend/get/%@"]
#define SYSTEM_ACTION_DEFINE_URL [SERVICE_HOST stringByAppendingString:@"/system/actionDefine/get/%@"]

// --- mission api ---
#define MISSION_GET_URL [SERVICE_HOST stringByAppendingString:@"/missions/mission/get?lastUpdateTime=%@"]
#define MISSION_DAILY_GET_URL [SERVICE_HOST stringByAppendingString:@"/missions/dailymission/get/%@"]

// --- history api ---
#define HISTORY_GET_RUNNING_HISTORY_URL [SERVICE_HOST stringByAppendingString:@"/running/history/get/%@?lastUpdateTime=%@"]
#define HISTORY_GET_SIMPLE_RUNNING_HISTORY_URL [SERVICE_HOST stringByAppendingString:@"/running/history/simple/get/%@"]
#define HISTORY_POST_RUNNING_HISTORY_URL [SERVICE_HOST stringByAppendingString:@"/running/history/post/%@"]
#define HISTORY_GET_MISSION_HISTORY_URL [SERVICE_HOST stringByAppendingString:@"/running/history/mission/get/%@?lastUpdateTime=%@"]
#define HISTORY_POST_MISSION_HISTORY_URL [SERVICE_HOST stringByAppendingString:@"/running/history/mission/put/%@"]

// --- virtual prop api ---
#define VIRTUAL_PRODUCT_GET_URL [SERVICE_HOST stringByAppendingString:@"/vproduct/product/get?lastUpdateTime=%@"]
#define VIRTUAL_PRODUCT_BUY_URL [SERVICE_HOST stringByAppendingString:@"/vproduct/history/create/%@"]

// --- third party api ---
#define THIRD_PARTY_PM25_URL @"http://www.cyberace.cc/service/api/weather/pm25?cityName=%@&provinceName=%@"
#define THIRD_PARTY_WEATHER_URL @"http://www.weather.com.cn/data/sk/%@.html"

#define UMENG_APPKEY @"5300735056240b04531ca01a"

#define DEFAULT_NET_WORK_MODE @"All_Mode"
#define NET_WORK_MODE_WIFI @"Only_Wifi"
#define DEFAULT_SEX @"男"
#define DEFAULT_WEIGHT [NSNumber numberWithDouble:60]
#define DEFAULT_HEIGHT [NSNumber numberWithDouble:175]
#define DEFAULT_SPEEDTYPE 0
#define DEFAULT_ANIMATION [NSNumber numberWithBool:YES]

#define CHN_PRINT_FONT @""
#define CHN_WRITTEN_FONT @""
#define ENG_WRITTEN_FONT @""
#define ENG_PRINT_FONT @""
#define ENG_GAME_FONT @"EnterSansmanBoldItalic"

#define PLAN_PAGE_SIZE 10
#define FRIENDS_PAGE_SIZE 10

#define COLOR_MOSS [UIColor colorWithRed:0 green:128.f/255.f blue:64.f/255.f alpha:1]
#endif

typedef enum {MissionTypeEasy = 0} MissionTypeEnum;
typedef enum {FollowStatusFollowed = 0, FollowStatusNotFollowed = 1} FollowStatusEnum;
typedef enum {FriendStatusOnlyFollowed = 0, FriendStatusFollowEachother = 1} FriendStatusEnum;
typedef enum {HistoryStatusExecute = 0, HistoryStatusFinished = 1, HistoryStatusCancled = 2} HistoryStatusEnum;
typedef enum {OperateUpdate = 0, OperateInsert = 1, OperateDelete = 2} OperateEnum;
typedef enum {PlanFlagNew = 0, PlanFlagHot = 1, PlanFlagRecommend = 2} PlanFlagEnun;
typedef enum {ActionDefineRun = 0, ActionDefineUse = 1} ActionDefineEnum;

typedef struct {
    int mainVersion;
    int subVersion;
} Version;

NSString *const CounterNumberImageInteger_toString[6];

@interface RORConstant : NSObject

@end
