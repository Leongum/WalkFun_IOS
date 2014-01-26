//
//  RORDBCommon.h
//  RevolUtioN
//
//  Created by Beyond on 13-6-24.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RORContextUtils.h"

@interface RORDBCommon : NSObject

+ (NSDate *)getDateFromId:(id)obj;
+ (NSString *)getStringFromId:(id)obj;
+ (NSNumber *)getNumberFromId:(id)obj;
+ (NSString *)getStringFromRoutes:(NSArray *)routes;
+ (NSArray *)getRoutesFromString:(NSString *)route_str;
+ (NSString *)getStringFromSpeedList:(NSArray *)speedList;
+ (NSMutableArray *)getSpeedListFromString:(NSString *)speedListString;
@end
