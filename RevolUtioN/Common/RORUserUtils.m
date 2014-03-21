//
//  RORUserUtils.m
//  RevolUtioN
//
//  Created by leon on 13-8-28.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORUserUtils.h"
#import "RORMissionServices.h"
#import "RORUserServices.h"
#import "RORVirtualProductService.h"

static NSNumber *userId = nil;

static NSDate *systemTime = nil;

static NSDate *syncTime;

@implementation RORUserUtils

+ (NSNumber *)getUserId{
    if (userId == nil || userId.integerValue < 0){
        NSMutableDictionary *userDict = [self getUserInfoPList];
        userId = [userDict valueForKey:@"userId"];
    }
    if(userId == nil){
        userId = [NSNumber numberWithInteger:-1];
    }
    return userId;
}

+ (NSString *)getUserName{
    NSMutableDictionary *userDict = [self getUserInfoPList];
    return [userDict valueForKey:@"nickName"];
}

+ (NSString *)getDeviceToken{
    NSMutableDictionary *userDict = [self getUserInfoPList];
    return [userDict valueForKey:@"deviceToken"];
}

+ (NSNumber *)getDownLoaded{
    NSMutableDictionary *userDict = [self getUserInfoPList];
    return [userDict valueForKey:@"downLoaded"];
    
}

+(void)doneDowned{
    NSMutableDictionary *userDict = [RORUserUtils getUserInfoPList];
    [userDict setValue:[NSNumber numberWithInt:1] forKey:@"downLoaded"];
    [self writeToUserInfoPList:userDict];
}

+(void)statisticsPageDidAppeared{
    NSMutableDictionary *userDict = [RORUserUtils getUserInfoPList];
    [userDict setValue:[NSNumber numberWithInt:1] forKey:@"statisticsPageAppeared"];
    [self writeToUserInfoPList:userDict];
}

+(NSNumber*)hasStatisticsPageAppeared{
    NSMutableDictionary *userDict = [self getUserInfoPList];
    return [userDict valueForKey:@"statisticsPageAppeared"];
}

+(NSNumber*)getStatisticsDefaultPage{
    NSMutableDictionary *userDict = [self getUserInfoPList];
    return [userDict valueForKey:@"statisticsDefaultPage"];
}

+(void)saveStatisticsDefaultPage:(NSInteger)page{
    NSMutableDictionary *userDict = [RORUserUtils getUserInfoPList];
    [userDict setValue:[NSNumber numberWithInt:page] forKey:@"statisticsDefaultPage"];
    [self writeToUserInfoPList:userDict];
}

+ (NSString *)getUserUuid{
    NSMutableDictionary *userDict = [self getUserInfoPList];
    NSString *uuid = (NSString *)[userDict objectForKey:@"uuid"];
    return uuid;
}

+(NSNumber *)getUserWeight{
    NSMutableDictionary *settinglist = [RORUserUtils getUserSettingsPList];
    id weight = [settinglist valueForKey:@"weight"];
    if (weight)
        return [RORDBCommon getNumberFromId:weight];
    else
        return [NSNumber numberWithInteger:60];
}

+(NSDate *)getSystemTime{
    if (systemTime == nil){
        [RORSystemService syncVersion:@"ios"];
        NSMutableDictionary *userDict = [self getUserInfoPList];
        systemTime =[RORUtils getDateFromString:[userDict valueForKey:@"systemTime"]];
    }
    return systemTime;
}

+ (void)resetUserId{
    userId = [[NSNumber alloc] initWithInt:-1];
}

+ (NSMutableDictionary *)getUserSettingsPList{
    NSArray *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [ doc objectAtIndex:0 ];
    NSString *path = [docPath stringByAppendingPathComponent:@"userSettings.plist"];
    NSMutableDictionary *settingDict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    if(settingDict == nil){
        settingDict = [self defaultSettingsPList];
    }
    return settingDict;
}

+ (NSMutableDictionary *)defaultSettingsPList{
    NSArray *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [ doc objectAtIndex:0 ];
    NSString *path = [docPath stringByAppendingPathComponent:@"userSettings.plist"];
    NSMutableDictionary *settingDict = [[NSMutableDictionary alloc] init];
    [settingDict setValue:DEFAULT_NET_WORK_MODE forKey:@"uploadMode"];
    [settingDict setValue:DEFAULT_WEIGHT forKey:@"weight"];
    [settingDict setValue:DEFAULT_HEIGHT forKey:@"height"];
    [settingDict setValue:DEFAULT_SEX forKey:@"sex"];
    [settingDict setValue:DEFAULT_SPEEDTYPE forKey:@"speedType"];
    [settingDict setValue:DEFAULT_ANIMATION forKey:@"loadingAnimation"];
    [settingDict writeToFile:path atomically:YES];
    return settingDict;
}

+ (void)writeToUserSettingsPList:(NSDictionary *) settingDict{
    NSArray *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [ doc objectAtIndex:0 ];
    NSString *path = [docPath stringByAppendingPathComponent:@"userSettings.plist"];
    NSMutableDictionary *pInfo = [self getUserSettingsPList];
    [pInfo addEntriesFromDictionary:settingDict];
    [pInfo writeToFile:path atomically:YES];
}

+ (NSString *)hasLoggedIn{
    NSMutableDictionary *userDict = [self getUserInfoPList];
    NSString *name = [userDict valueForKey:@"nickName"];
    
    if (!([name isEqual:@""] || name == nil))
        return name;
    else
        return nil;
}

+ (NSMutableDictionary *)getUserInfoPList{
    NSArray *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [ doc objectAtIndex:0 ];
    NSString *path = [docPath stringByAppendingPathComponent:@"userInfo.plist"];
    NSMutableDictionary *userDict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    if (userDict == nil)
        userDict = [[NSMutableDictionary alloc] init];
    
    return userDict;
}

+ (void)writeToUserInfoPList:(NSDictionary *) userDict{
    NSArray *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [ doc objectAtIndex:0 ];
    NSString *path = [docPath stringByAppendingPathComponent:@"userInfo.plist"];
    NSMutableDictionary *pInfo = [self getUserInfoPList];
    [pInfo addEntriesFromDictionary:userDict];
    [pInfo writeToFile:path atomically:YES];
}

+ (void)logout{
    NSArray *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [ doc objectAtIndex:0 ];
    NSString *path = [docPath stringByAppendingPathComponent:@"userInfo.plist"];
    NSMutableDictionary *logoutDict = [[NSMutableDictionary alloc] init];
    [logoutDict setValue:[self getLastUpdateTime:@"MissionUpdateTime"] forKey:@"MissionUpdateTime"];
    [logoutDict setValue:[self getLastUpdateTime:@"VirtualProductUpdateTime"] forKey:@"VirtualProductUpdateTime"];
    [logoutDict setValue:[self getLastUpdateTime:@"ActionDefineLastUpdateTime"] forKey:@"ActionDefineLastUpdateTime"];
    [logoutDict setValue:[self getLastUpdateTime:@"RecommendLastUpdateTime"] forKey:@"RecommendLastUpdateTime"];
    [logoutDict setValue:[self getLastUpdateTime:@"FightDefineLastUpdateTime"] forKey:@"FightDefineLastUpdateTime"];
    [logoutDict setValue:[self getDeviceToken] forKey:@"deviceToken"];
    [logoutDict writeToFile:path atomically:YES];
    userId = [NSNumber numberWithInteger:-1];
    NSArray *tables = [NSArray arrayWithObjects:@"Action",@"Friend",@"Friend_Sort",@"User_Base",@"User_Detail",@"User_Prop",@"User_Running_History",@"User_Mission_History", nil];
    [RORContextUtils clearTableData:tables];
}

+ (void)saveLastUpdateTime: (NSString *) key{
    NSMutableDictionary *userDict = [self getUserInfoPList];
    NSString *systemTime = (NSString *)[userDict objectForKey:@"systemTime"];
    [userDict setValue:systemTime forKey:key];
    [self writeToUserInfoPList:userDict];
}

+(NSString *)getCurrentTime{
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *formatDateString = [formate stringFromDate:[NSDate date]];
    return formatDateString;
}

+ (void)saveLastUpdateTimeUseLocalTime: (NSString *) key{
    NSMutableDictionary *userDict = [self getUserInfoPList];
    NSString *systemTime = [self getCurrentTime];
    [userDict setValue:systemTime forKey:key];
    [self writeToUserInfoPList:userDict];
}

+ (NSString *)getLastUpdateTime: (NSString *) key{
    NSMutableDictionary *userDict = [self getUserInfoPList];
    NSString *lastUpdateTime = (NSString *)[userDict objectForKey:key];
    if(lastUpdateTime == nil){
        lastUpdateTime = @"2000-01-01 00:00:00";
    }
    lastUpdateTime = [RORUtils getStringFromDate:[RORUtils getDateFromString:lastUpdateTime]];
    return lastUpdateTime;
}

+(NSString *)formatedSpeed:(double)kmperhour{
    double metersPerSec = kmperhour/3.6;
    NSMutableDictionary *settinglist = [self getUserSettingsPList];
    NSInteger speedType = ((NSNumber *)[settinglist valueForKey:@"speedType"]).integerValue;
    double orginSpeed = metersPerSec;
    if (speedType == 0) {
        if (orginSpeed == 0)
            return @"0\'0\"/km";
        int minutes = (int)(1000/( orginSpeed * 60));
        int seconds = ((int) (1000/orginSpeed)) % 60;
        return [NSString stringWithFormat:@"%d\'%d\"/km", minutes, seconds];
    } else {
        return [NSString stringWithFormat:@"%.1f km/h", kmperhour];
    }
}

+(NSNumber *)timePerKM2kmPerHour:(double)seconds{
    return [NSNumber numberWithDouble:3600/seconds];
}

+(void)syncSystemData{
    //sync version
    Version_Control *version = [RORSystemService syncVersion:@"ios"];
    if(version != nil){
        NSString *missionLastUpdateTime = [RORUserUtils getLastUpdateTime:@"MissionUpdateTime"];
        NSString *recommendLastUpdateTime = [RORUserUtils getLastUpdateTime:@"RecommendLastUpdateTime"];
        NSString *productLastUpdateTime = [RORUserUtils getLastUpdateTime:@"VirtualProductUpdateTime"];
        NSString *actionDefineUpdateTime = [RORUserUtils getLastUpdateTime:@"ActionDefineLastUpdateTime"];
        NSString *fightDefineUpdateTime = [RORUserUtils getLastUpdateTime:@"FightDefineLastUpdateTime"];
        NSTimeInterval missionScape = [version.missionLastUpdateTime timeIntervalSinceDate:[RORUtils getDateFromString:missionLastUpdateTime]];
        NSTimeInterval recommendScape = [version.recommendLastUpdateTime timeIntervalSinceDate:[RORUtils getDateFromString:recommendLastUpdateTime]];
        NSTimeInterval productScape = [version.productLastUpdateTime timeIntervalSinceDate:[RORUtils getDateFromString:productLastUpdateTime]];
        NSTimeInterval actionDefineScape = [version.actionDefineUpdateTime timeIntervalSinceDate:[RORUtils getDateFromString:actionDefineUpdateTime]];
        NSTimeInterval fightDefineScape = [version.fightDefineUpdateTime timeIntervalSinceDate:[RORUtils getDateFromString:fightDefineUpdateTime]];
        if(missionScape > 0)
        {
            //sync missions
            [RORMissionServices syncMissions];
        }
        if(recommendScape > 0)
        {
            //sync missions
            [RORSystemService syncRecommendApp];
        }
        if(productScape > 0)
        {
            //sync virtual product
            [RORVirtualProductService syncVProduct];
            [RORVirtualProductService syncAllItemImages];
        }
        if(actionDefineScape > 0)
        {
            //sync action define
            [RORSystemService syncActionDefine];
            [RORVirtualProductService syncAllEventSounds];
        }
        if(fightDefineScape > 0)
        {
            //sync fight define
            [RORSystemService syncFightDefine];
        }
        [self saveLastUpdateTimeUseLocalTime:@"lastSyncSystemDataTime"];
    }
    NSNumber *userId = [RORUserUtils getUserId];
    if([userId intValue] > 0){
        //sync userInfo.
        [RORUserServices syncUserInfoById:userId];
    }
}

+(UIImage *)getImageForUserSex:(NSString *)sexString{
    if ([sexString isEqualToString:@"男"]){
        return [UIImage imageNamed:@"male.png"];
    } else if ([sexString isEqualToString:@"女"]){
        return [UIImage imageNamed:@"female.png"];
    } else {
        return [UIImage imageNamed:@"notSure.png"];
    }
}

+(NSDictionary *)parsePropHavingString:(NSString *)propHaving{
    NSMutableDictionary *itemsForDisplayDict = [[NSMutableDictionary alloc]init];
    NSArray *propHavingStringList = [propHaving componentsSeparatedByString:@"|"];
    for (NSString *propHavingString in propHavingStringList){
        NSArray *proHavingPair = [propHavingString componentsSeparatedByString:@","];
        if (proHavingPair.count == 2){
            NSNumber *itemId = [RORDBCommon getNumberFromId:[proHavingPair objectAtIndex:0]];
            NSNumber *quantity = [RORDBCommon getNumberFromId:[proHavingPair objectAtIndex:1]];
            [itemsForDisplayDict setObject:quantity forKey:itemId];
        }
    }
    return itemsForDisplayDict;
}

+(void)initialUserInfoPlist{
    NSDictionary *saveDict = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInteger:0],@"missionProcess", nil];
    
    [self writeToUserInfoPList:saveDict];
}

@end

