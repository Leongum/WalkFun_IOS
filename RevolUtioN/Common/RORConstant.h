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
#define ACTION_GET_ACTION_BY_USER_ID_URL [SERVICE_HOST stringByAppendingString:@"/account/action/others/get/%@"]

// --- prop api ---
#define PROP_GET_URL [SERVICE_HOST stringByAppendingString:@"/account/props/get/%@?lastUpdateTime=%@"]
#define PROP_CREATE_URL [SERVICE_HOST stringByAppendingString:@"/account/props/create/%@"]

// --- reward api ---
#define REWARD_GET_RANDOM_URL [SERVICE_HOST stringByAppendingString:@"/account/reward/get/%@"]

// --- system api ---
#define SYSTEM_VERSION_URL [SERVICE_HOST stringByAppendingString:@"/system/version/get/%@"]
#define SYSTEM_RECOMMEND_APP_URL [SERVICE_HOST stringByAppendingString:@"/system/recommend/get/%@"]
#define SYSTEM_ACTION_DEFINE_URL [SERVICE_HOST stringByAppendingString:@"/system/actionDefine/get/%@"]
#define SYSTEM_FIGHT_DEFINE_URL [SERVICE_HOST stringByAppendingString:@"/system/fightDefine/get/%@"]

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

#define PICTURE_HOST_URL @"http://cyberace.qiniudn.com/"

#define DEFAULT_NET_WORK_MODE @"All_Mode"
#define NET_WORK_MODE_WIFI @"Only_Wifi"
#define DEFAULT_SEX @"男"
#define DEFAULT_WEIGHT [NSNumber numberWithDouble:60]
#define DEFAULT_HEIGHT [NSNumber numberWithDouble:175]
#define DEFAULT_SPEEDTYPE 0
#define DEFAULT_ANIMATION [NSNumber numberWithBool:YES]

#define ENG_GAME_FONT @"EnterSansmanBoldItalic"

#define PLAN_PAGE_SIZE 10
#define FRIENDS_PAGE_SIZE 10


#define APP_FONT @"DFPWaWaW5"

#define SENTENCE_START_WALKING_ALONE @"独自一人从村里出发了|从村里出发了|毫无悬念的一个人从村里出发了"
#define SENTENCE_START_WALKING_WITH @"与小伙伴%@一起从村里出发了"
#define SENTENCE_FRIEND_FIGHT_WIN @"遇到%@并主动与之切磋武艺，几招过后轻松取胜，被围观群众投来崇拜的目光。|巧遇%@与之切磋，大战250回合后终于艰难取胜。"
#define SENTENCE_FRIEND_FIGHT_LOSE @"遇到%@并主动与之切磋武艺，结果连对方三招都没接住。|巧遇%@与之切磋，大战250回合后遗憾落败。"

#endif

//是否可以掉落在地上
#define RULE_Drop_Down @"D"
//掉落在的花盆上
#define RULE_Drop_Pot @"DP"
//是否可以显示在脸上
#define RULE_On_Face @"OF"
//是否需要改变脸的颜色
#define RULE_Face_Color @"FC"
//标注肥肉的改变值
#define RULE_Fatness @"F"
//标注肥肉的直接增加值
#define RULE_Fight_Add @"FA"
//标注肥肉的百分比真价值
#define RULE_Fight_Percent @"FPE"
//标注体力的临时上限增加
#define RULE_Physical_Power_Add @"PPA"
//标注体力的临时上限的增加的百分比
#define RULE_Physical_Power_Percent @"PPP"
//标注为道具。
#define RULE_Prop_Yes @"PY"
//标注不是道具
#define RULE_Prop_No @"PN"
//标注是否是钱
#define RULE_Money @"M"
//标注触发是一个action事件
#define RULE_Type_Action @"TA"
//标注触发是一个战斗事件
#define RULE_Type_Fight @"TF"
//标注触发是一个好友战斗事件
#define RULE_Type_Fight_Friend @"TFF"
//标注出发事件。
#define RULE_Type_Start @"TS"

typedef enum {MissionTypeStep = 0, MissionTypePickItem = 1, MissionTypeUseItem = 2} MissionTypeEnum;
typedef enum {MissionStatusDone = 0, MissionStatusUndone = 1} MissionStatusEnum;
typedef enum {FightStageFunny = 1, FightStageEasy = 2, FightStageNormal = 3, FightStageHard = 4, FightStageLegend = 5} FightStageEnum;

typedef enum {FollowStatusFollowed = 0, FollowStatusNotFollowed = 1} FollowStatusEnum;
typedef enum {FriendStatusOnlyFollowed = 0, FriendStatusFollowEachother = 1} FriendStatusEnum;
typedef enum {HistoryStatusExecute = 0, HistoryStatusFinished = 1, HistoryStatusCancled = 2} HistoryStatusEnum;
typedef enum {OperateUpdate = 0, OperateInsert = 1, OperateDelete = 2} OperateEnum;
typedef enum {PlanFlagNew = 0, PlanFlagHot = 1, PlanFlagRecommend = 2} PlanFlagEnun;
typedef enum {ActionDefineRun = 0, ActionDefineUse = 1, ActionDefineReward = 2} ActionDefineEnum;
typedef enum {ItemTypeNormal = 1, ItemTypeFight = 2} ItemTypeEnum;
typedef enum {MissionDirectionNone = 0, MissionDirectionEast = 1, MissionDirectionSouth = 2,MissionDirectionWest = 3, MissionDirectionNorth = 4} MissionDirectionEnum;

typedef struct {
    int mainVersion;
    int subVersion;
} Version;

NSString *const CounterNumberImageInteger_toString[6];

@interface RORConstant : NSObject

@end
