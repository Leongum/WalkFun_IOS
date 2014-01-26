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

+ (NSNumber *)getUserWeight;

+ (NSString *)getUserUuid;

+ (void)logout;

+ (NSDate *)getSystemTime;

+ (NSMutableDictionary *)getUserInfoPList;

+ (NSMutableDictionary *)getUserSettingsPList;

+ (void)writeToUserSettingsPList:(NSDictionary *) settingDict;

+ (void)writeToUserInfoPList:(NSDictionary *) userDict;

+ (void)saveLastUpdateTime: (NSString *) key;

+ (NSString *)getLastUpdateTime: (NSString *) key;

+ (void)userInfoUpdateHandler:(id<ISSUserInfo>)userInfo withSNSType:(ShareType) shareType;

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
@end
