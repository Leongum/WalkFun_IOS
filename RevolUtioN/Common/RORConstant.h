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
//#define SERVICE_HOST @"http://121.199.56.231:8080/walkfun/service/api"

//define service host
#define SERVICE_HOST @"http://www.cyberace.cc:9090/service/api"

#define CURRENT_VERSION_MAIN 1
#define CURRENT_VERSION_SUB 2
#define CURRENT_VERSION_DESC 1

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

#define PICTURE_HOST_URL @"http://walkfun.qiniudn.com/"

#define APP_URL @"https://itunes.apple.com/us/app/bao-gao-cun-zhang-ji-bu-yang/id869432635?ls=1&mt=8"

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

#define SENTENCE_START_WALKING_ALONE @"独自一人从村里出发了|从村里出发了|毫无悬念的一个人走出村庄"
#define SENTENCE_START_WALKING_WITH @"与小伙伴%@一起从村里出发了"
#define SENTENCE_FRIEND_FIGHT_WIN @"遇到%@并主动与之切磋武艺，几招过后轻松取胜，被围观群众投来崇拜的目光。|巧遇%@与之切磋，大战250回合后终于艰难取胜。|与%@于小树林中比武，结果不费吹灰之力便战胜对方。|与%@于小河边比试，赢得比想像中要轻松许多。|与%@于一座教堂前切磋，费尽九牛二虎之力才侥幸取胜。"
#define SENTENCE_FRIEND_FIGHT_LOSE @"遇到%@并主动与之切磋武艺，结果连对方三招都没接住。|巧遇%@与之切磋，大战250回合后遗憾落败。|与%@于小树林中比武，结果对方好像没费吹灰之力。|与%@于小河边比试，虽然输了但也打出了水平。|与%@于一座教堂前切磋，输得比想像中要快许多。"

#define GAME_RULE @"报告村长的基本功能是基于计步器，需要玩家在开始走路之前手动开启。“出发”后程序可以在后台运行。走路结束后手动结束记录。\n\n玩家需要通过在真实世界的走路活动，去在游戏中碰到怪物、战斗和事件，积累经验值、金币和道具。战斗类道具可以提升角色能力；互动类道具可以对好友使用，整蛊？表白？你说的算！\n\n下面的小提示可能让你的游戏过程更顺利：\n\n* 出发之后进入走路记录的页面，此时你的角色正在游戏世界进行探险，你可以关闭手机屏幕，并携带着手机正常的进行走路活动。\n\n* 你走的时间越久，步数越多，距离越远，你的角色在游戏中的探险距离也越远。距离越远，碰到的怪物等级越高，掉落的道具也越优质，越稀有。\n\n* 走路是在游戏中获得金币的唯一方式。\n\n* 主页面可以左右滑动进入道具和好友页面。\n\n* 走路开始前的准备页面，玩家可以通过“使用道具”和“好友结伴”来提高本次探险中的能力（战斗力、体力）。\n\n* 战斗类的道具除了给自己使用以外也可以给好友使用，与获得属性加成的好友结伴，玩家在单次探险中获得更高的战斗力加成。\n\n* 多数增加战斗属性的道具是当日有效的，第二天增益效果会消失。\n\n* “对好友使用”的道具会作用在好友的角色形象上，至于是整蛊还是示爱……你看着办。\n\n* 有些道具有特殊能力，比如你的花盆里种有“豌豆射手”，它会对向你整蛊的玩家进行反击。\n\n* 探险过程中的战斗会消耗体力，有体力的剩余是战斗胜利的必要条件。\n\n* 出发时的体力越多，可能获得的战斗胜利越多。\n\n* 走路越频繁体力越好，当然你角色的体力上限也会越高。\n\n* 完成三次“每日任务”可以抽取一次奖励。\n\n* 怪物会根据强力和稀有程度分为不同等级，有些怪要走得远一点才能碰到。"

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

typedef enum {MissionTypeStep = 0, MissionTypePickItem = 1, MissionTypeUseItem = 2, MissionTypeFight = 3} MissionTypeEnum;
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
NSString *const FightStage_toString[6];
NSString *const InstructionOrder_toString[11];
NSString *const WalkingNote_toString[5];

@interface RORConstant : NSObject

@end
