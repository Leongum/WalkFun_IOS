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
#import "RORContextUtils.h"
#import "Recommend_App.h"

@interface RORSystemService : NSObject

//同步服务器版本信息。
+(Version_Control *)syncVersion:(NSString *)platform;

//同步提示信息
+(BOOL)syncSystemMessage;

//根据message id 获取当前应该提示的提示语句
+(NSString *)getSystemMessage:(NSNumber *)messageId;

//根据message id 和region id获取当前应该提示的提示语句
+(NSString *)getSystemMessage:(NSNumber *)messageId withRegion:(NSNumber *)region;

//提交反馈信息
+(BOOL)submitFeedback:(NSDictionary *)feedbackDic;

//提交下载信息
+(BOOL)submitDownloaded:(NSDictionary *)downLoadDic;

//同步推荐app信息
+(BOOL)syncRecommendApp;

//获取本地所有推荐的app信息
+(NSArray *)fetchAllRecommedInfo;
@end
