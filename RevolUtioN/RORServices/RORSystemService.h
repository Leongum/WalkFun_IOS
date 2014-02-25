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
#import "System_Message.h"
#import "Action_Define.h"
#import "RORContextUtils.h"
#import "Recommend_App.h"
#import "RORUtils.h"

@interface RORSystemService : NSObject

//同步服务器版本信息。
+(Version_Control *)syncVersion:(NSString *)platform;

//同步提示信息
+(BOOL)syncSystemMessage;

//根据message id 获取当前应该提示的提示语句
+(NSString *)getSystemMessage:(NSNumber *)messageId;

//根据message id 和region id获取当前应该提示的提示语句
+(NSString *)getSystemMessage:(NSNumber *)messageId withRegion:(NSNumber *)region;

//同步推荐app信息
+(BOOL)syncRecommendApp;

//获取本地所有推荐的app信息
+(NSArray *)fetchAllRecommedInfo;

//同步action定义信息
+ (BOOL)syncActionDefine;

//根据action的type获取action的所有信息，(ActionDefineRun 跑步可触发action）（ActionDefineUse 用户可以使用action）
+ (NSArray *)fetchAllActionDefine:(ActionDefineEnum) actionType;

//根据prop id 获取action define
+(Action_Define *)fetchActionDefineByPropId:(NSNumber *)propId;

//解析字符串为事件列表
+ (NSArray *)getEventListFromString:(NSString *)eventString;

//压缩事件列表为字符串
+ (NSString *)getStringFromEventList:(NSArray *)eventList andTimeList:(NSArray *)timeList;
@end
