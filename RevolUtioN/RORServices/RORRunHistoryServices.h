//
//  RORRunHistoryServices.h
//  RevolUtioN
//
//  Created by leon on 13-7-22.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RORAppDelegate.h"
#import "RORHttpResponse.h"
#import "User_Running_History.h"
#import "Simple_User_Run_History.h"
#import "RORRunHistoryClientHandler.h"
#import "RORContextUtils.h"

@interface RORRunHistoryServices : NSObject

//根据 run uuid 获取某一条跑步的具体信息
+ (User_Running_History *)fetchRunHistoryByRunId:(NSString *) runUuid;

//根据开始时间取记录
+(User_Running_History *)fetchRunHistoryByMissionStartTime:(NSDate *) missionStartTime withContext:(NSManagedObjectContext *) context;
    
//上传本地还未上传的跑步历史记录
+ (BOOL)uploadRunningHistories;

//同步userid的跑步记录。并且存到本地
+ (BOOL)syncRunningHistories:(NSNumber *)userId;

//根据用户userid从本地数据库拿去该用户的跑步历史数据
+ (NSArray*)fetchRunHistoryByUserId:(NSNumber*)userId;

//根据用户userid获取服务器用户最新的3条跑步的记录
+ (NSMutableArray *)getSimpleRunningHistories:(NSNumber *)userId;

//保存一条新的历史记录到本地数据库，并且更新用户的基础数据。
+ (BOOL)saveRunInfoToDB:(User_Running_History*)runHistory;

//根据missionUuid获取该mission所有的历史记录
+ (NSArray *)fetchRunHistoryByMissionUuid:(NSString *) missionUuid;


@end
