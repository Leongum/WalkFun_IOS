//
//  RORUserPropsService.h
//  WalkFun
//
//  Created by leon on 14-2-16.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User_Prop.h"
#import "RORAppDelegate.h"
#import "RORContextUtils.h"
#import "RORHttpResponse.h"
#import "RORUserClientHandler.h"

@interface RORUserPropsService : NSObject

//根据用户的id获取该用户的道具
+(NSArray*)fetchUserProps:(NSNumber*)userId;

//根据用户的id和道具id获取该道具的情况
+(User_Prop *)fetchUserPropByPropId:(NSNumber *) userId withPropId:(NSNumber *) propId;

//服务器同步用户的道具具体情况
+ (BOOL)syncUserProps:(NSNumber *)userId;

//将更新的后的道具情况保存到数据库。不上传服务器
+ (BOOL) saveUserPropInfoToDB:(User_Prop *)userProp;

//上传本地未上传过的道具数据
+ (BOOL)uploadUserProps;

@end
