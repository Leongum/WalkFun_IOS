//
//  RORUserPropsService.h
//  WalkFun
//
//  Created by leon on 14-2-16.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User_Prop.h"
#import "Virtual_Product_Buy.h"
#import "RORAppDelegate.h"
#import "RORContextUtils.h"
#import "RORHttpResponse.h"
#import "RORUserClientHandler.h"
#import "RORVirtualProductClientHandler.h"
#import "RORUserServices.h"

@interface RORUserPropsService : NSObject

//根据用户的id获取该用户的道具
+(NSArray*)fetchUserProps:(NSNumber*)userId;

//根据用户的id和道具id获取该道具的情况
+(User_Prop *)fetchUserPropByPropId:(NSNumber *) userId withPropId:(NSNumber *) propId;

//服务器同步用户的道具具体情况
+ (BOOL)syncUserProps:(NSNumber *)userId;

//购买道具
+ (BOOL)buyUserProps:(NSNumber *)propId withBuyNumbers:(NSNumber *) numbers;

@end
