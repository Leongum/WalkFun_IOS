//
//  RORUserUtils.h
//  RevolUtioN
//
//  Created by leon on 13-8-28.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RORUtils.h"

@interface RORUserUtils : NSObject

+ (NSNumber *)getUserId;

+ (NSString *)getUserName;

+ (NSString *)getDeviceToken;

+ (NSNumber *)getUserWeight;

+ (NSString *)getUserUuid;

+ (void)logout;

+ (NSDate *)getSystemTime;

+ (NSMutableDictionary *)getUserInfoPList;

+ (NSMutableDictionary *)getUserSettingsPList;

+ (void)writeToUserSettingsPList:(NSDictionary *) settingDict;

+ (void)writeToUserInfoPList:(NSDictionary *) userDict;

+ (void)initialUserInfoPlist;

+ (void)saveLastUpdateTime: (NSString *) key;

+ (NSString *)getLastUpdateTime: (NSString *) key;

//+ (void)userInfoUpdateHandler:(id<ISSUserInfo>)userInfo withSNSType:(ShareType) shareType;

+ (NSString *)formatedSpeed:(double)metersPerSec;

+(NSNumber *)timePerKM2kmPerHour:(double)seconds;

+ (NSNumber *)getDownLoaded;

+(void)doneDowned;

+(NSNumber*)hasStatisticsPageAppeared;

+(void)statisticsPageDidAppeared;

+(NSNumber*)getStatisticsDefaultPage;

+(void)saveStatisticsDefaultPage:(NSInteger)page;

+(void)syncSystemData;

+(UIImage *)getImageForUserSex:(NSString *)sexString;

//解析propHaving字段为道具id及显示个数的dictionary
+(NSDictionary *)parsePropHavingString:(NSString *)propHaving;

//获得用户当前体力值
+(NSInteger)getUserPowerLeft;
+(void)saveUserPowerLeft:(NSInteger)powerLeft;

@end
