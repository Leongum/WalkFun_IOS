//
//  RORMissionServices.h
//  RevolUtioN
//
//  Created by leon on 13-7-21.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RORAppDelegate.h"
#import "RORHttpResponse.h"
#import "RORMissionClientHandler.h"
#import "Mission.h"
#import "RORContextUtils.h"

@interface RORMissionServices : NSObject

//根据mission id 获取当前mission的具体信息
+(Mission *)fetchMission:(NSNumber *) missionId;

//获取所有mission 相关的信息。
+(NSArray *)fetchMissionList;

//同步服务器mission信息
+ (BOOL)syncMissions;
@end
