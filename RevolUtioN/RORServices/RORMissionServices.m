//
//  RORMissionServices.m
//  RevolUtioN
//
//  Created by leon on 13-7-21.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORMissionServices.h"
#import "RORNetWorkUtils.h"

@implementation RORMissionServices

//open out
+(Mission *)fetchMission:(NSNumber *) missionId{
    return [self fetchMission:missionId withContext:nil];
}

+(Mission *)fetchMission:(NSNumber *) missionId withContext:(NSManagedObjectContext *) context{
    NSString *table=@"Mission";
    NSString *query = @"missionId = %@";
    NSArray *params = [NSArray arrayWithObjects:missionId, nil];
    Boolean needContext = true;
    if(context == nil){
        needContext = false;
        context = [RORContextUtils getPrivateContext];
    }
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query withContext:context];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    Mission *mission = (Mission *) [fetchObject objectAtIndex:0];
    if(!needContext){
        return [Mission removeAssociateForEntity:mission withContext:context];
    }
    return mission;
}

//open out
+ (BOOL)syncMissions{
    NSError *error = nil;
    NSManagedObjectContext *context = [RORContextUtils getPrivateContext];
    NSString *lastUpdateTime = [RORUserUtils getLastUpdateTime:@"MissionUpdateTime"];

    RORHttpResponse *httpResponse =[RORMissionClientHandler getMissions:lastUpdateTime];
    
    if ([httpResponse responseStatus]  == 200){
        NSArray *missionList = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
        for (NSDictionary *missionDict in missionList){
            NSNumber *missionId = [missionDict valueForKey:@"missionId"];
            Mission *missionEntity = [self fetchMission:missionId withContext:context];
            if(missionEntity == nil)
                missionEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Mission" inManagedObjectContext:context];
            [missionEntity initWithDictionary:missionDict];
        }
        
        [RORContextUtils saveContext:context];
        [RORUserUtils saveLastUpdateTime:@"MissionUpdateTime"];
    } else {
        NSLog(@"sync with host error: can't get mission list. Status Code: %d", [httpResponse responseStatus]);
        return NO;
    }
    return YES;
}

//open out
//debug
+(NSArray *)fetchMissionList{
    return [self fetchMissionList:0 withContext:nil];
}

+(NSArray *)fetchMissionList:(MissionTypeEnum *) missionType withContext:(NSManagedObjectContext *) context{
    NSString *table=@"Mission";
    NSString *query = @"missionTypeId = %@ and missionFlag != -1";
    NSArray *params = [NSArray arrayWithObjects:[NSNumber numberWithInteger:(NSInteger)missionType], nil];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"sequence" ascending:YES];
    NSArray *sortParams = [NSArray arrayWithObject:sortDescriptor];
    if(context == nil){
        context = [RORContextUtils getPrivateContext];
    }
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query withOrderBy:sortParams withContext:context];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    NSMutableArray *missionDetails = [NSMutableArray arrayWithCapacity:10];
    for (Mission *mission in fetchObject) {
        [missionDetails addObject:[Mission removeAssociateForEntity:mission withContext:context]];
    }
    return [(NSArray*)missionDetails mutableCopy];
}

//open out
+ (Mission *)fetchDailyMission{
    NSError *error = nil;
    NSManagedObjectContext *context = [RORContextUtils getPrivateContext];
    NSString *lastUpdateTime = [RORUserUtils getLastUpdateTime:@"DailyMissionGetTime"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //设置日期格式
    NSDate *today = [NSDate date]; //当前日期
    NSDate *fetchDay = [dateFormatter dateFromString:lastUpdateTime];
//    BOOL b = [today isEqualToDate:fetchDay];//日期相同返回YES
    if([RORUtils isTheDay:fetchDay equalTo:today]){
        NSMutableDictionary *userDict = [RORUserUtils getUserInfoPList];
        NSNumber * missionId =  [userDict valueForKey:@"dailyMissionId"];
        return [self fetchMission:missionId];
    }
    else{
        RORHttpResponse *httpResponse =[RORMissionClientHandler getDailyMission:[RORUserUtils getUserId]];
        
        if ([httpResponse responseStatus]  == 200){
            NSDictionary *missionDict = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
            NSNumber *missionId = [missionDict valueForKey:@"missionId"];
            Mission *missionEntity = [self fetchMission:missionId withContext:context];
            if(missionEntity == nil)
                missionEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Mission" inManagedObjectContext:context];
            [missionEntity initWithDictionary:missionDict];
            
            [RORContextUtils saveContext:context];
            [RORUserUtils saveLastUpdateTime:@"DailyMissionGetTime"];
            NSMutableDictionary *userDict = [RORUserUtils getUserInfoPList];
            [userDict setValue:missionId forKey:@"dailyMissionId"];
            [RORUserUtils writeToUserInfoPList:userDict];
            return [Mission removeAssociateForEntity:missionEntity withContext:context];
        } else {
            NSLog(@"sync with host error: can't get daily mission. Status Code: %d", [httpResponse responseStatus]);
            return NO;
        }
        return nil;
    }
}

+(Mission *)getTodayMission{
    NSMutableDictionary *userInfoList = [RORUserUtils getUserInfoPList];
    //如果已经集满了三次日常任务，但没有兑换奖励，则接不到新的任务
    NSNumber *missionProcess = (NSNumber *)[userInfoList objectForKey:@"missionProcess"];
    if (missionProcess.integerValue >= 3)
        return nil;
    
    NSDate *date = [userInfoList valueForKey:@"lastDailyMissionFinishedDate"];
    if (date== nil || ![RORUtils isTheDay:date equalTo:[NSDate date]]){
        Mission *todayMission = [RORMissionServices fetchDailyMission];
        
        return todayMission;
    }
    return nil;
}
@end
