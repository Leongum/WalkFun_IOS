//
//  RORMissionHistoyService.h
//  WalkFun
//
//  Created by leon on 14-1-26.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RORAppDelegate.h"
#import "RORHttpResponse.h"
#import "User_Mission_History.h"
#import "RORRunHistoryClientHandler.h"
#import "RORContextUtils.h"

@interface RORMissionHistoyService : NSObject

//根据mission uuid获取本地改mission uuid下的具体信息（不包含running history，需单独获取）
+(User_Mission_History *)fetchMissionHistoryByMissionUuid:(NSString *) missionUuid;

//根据用户userid获取该用户已经完成的mission 记录。（仅能获取自己的数据）
+(NSArray*)fetchFinishedMissionHistoryByUserId:(NSNumber*)userId;

//根据用户userid获取该用户正在执行的的mission记录。（可以获取除自己以外的别的用户）
+(NSArray*)fetchUsingMissionHistoryByUserId:(NSNumber*)userId;

//上传本地更新过未上传的数据
+(BOOL)uploadMissionHistories;

//同步userid相关的已更新过的数据到本地
+(BOOL)syncMissionHistories:(NSNumber *)userId;

//新建或者更新mission history到本地数据库，并更新用户信息。未上传，需单独调用上传接口
+(BOOL)saveMissionHistoryInfoToDB:(User_Mission_History *)missionHistory;

//获取当前时间段最时候的跑步的任务。
+(User_Mission_History *)fetchMatchedMissionHistorySinceNow;
@end
