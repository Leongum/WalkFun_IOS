//
//  RORSystemService.h
//  RevolUtioN
//
//  Created by leon on 13-8-10.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RORAppDelegate.h"
#import "RORHttpResponse.h"
#import "RORSystemClientHandler.h"
#import "Version_Control.h"
#import "Action_Define.h"
#import "Fight_Define.h"
#import "RORContextUtils.h"
#import "Recommend_App.h"
#import "RORUtils.h"
#import "RORVirtualProductService.h"

@interface RORSystemService : NSObject

//同步服务器版本信息。
+(Version_Control *)syncVersion:(NSString *)platform;

//同步战斗信息
+(BOOL)syncFightDefine;

//根据fight id 获取fight define
+(Fight_Define *)fetchFightDefineInfo:(NSNumber *) fightId;

//获取fight 战斗 根据用户的等级
+(NSArray *)fetchFightDefineByLevel:(NSNumber *) level;

//同步推荐app信息
+(BOOL)syncRecommendApp;

//获取本地所有推荐的app信息
+(NSArray *)fetchAllRecommedInfo;

//同步action定义信息
+ (BOOL)syncActionDefine;

//根据action的type获取action的所有信息，(ActionDefineRun 跑步可触发action）（ActionDefineUse 用户可以使用action）
+ (NSArray *)fetchAllActionDefine:(ActionDefineEnum) actionType;

//根据actionId获得action define
+ (Action_Define *)fetchActionDefine:(NSNumber *) actionId;

//根据prop id 获取action define
+(Action_Define *)fetchActionDefineByPropId:(NSNumber *)propId;

//解析字符串为事件列表
+ (NSArray *)getEventListFromString:(NSString *)eventString;

//压缩事件列表为字符串
+ (NSString *)getStringFromEventList:(NSArray *)eventList timeList:(NSArray *)timeList andLocationList:(NSArray *)locationList;

//根据事件列表计算出用于本地存储‘一次走路总获得的属性和道具’的字符串
//attrkey,attrvalue attrkey,attrvalue|itemkey,itemvalue
+ (NSString *)getPropgetStringFromList:(NSArray *)eventList;

//把存于本地的propget中的字符串转成对属性和道具影响的dict
//返回的array[0]为attrDict，array[1]为itemDict
+ (NSArray *)getPropgetListFromString:(NSString *)propgetString;
@end
