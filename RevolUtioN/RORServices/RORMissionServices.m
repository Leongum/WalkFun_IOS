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
    return [self fetchMission:missionId withContext:NO];
}

+(Mission *)fetchMission:(NSNumber *) missionId withContext:(BOOL) needContext{
    NSString *table=@"Mission";
    NSString *query = @"missionId = %@";
    NSArray *params = [NSArray arrayWithObjects:missionId, nil];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    Mission *mission = (Mission *) [fetchObject objectAtIndex:0];
    if(!needContext){
        return [Mission removeAssociateForEntity:mission];
    }
    return mission;
}

//open out
+ (BOOL)syncMissions{
    NSError *error = nil;
    NSManagedObjectContext *context = [RORContextUtils getShareContext];
    NSString *lastUpdateTime = [RORUserUtils getLastUpdateTime:@"MissionUpdateTime"];

    RORHttpResponse *httpResponse =[RORMissionClientHandler getMissions:lastUpdateTime];
    
    if ([httpResponse responseStatus]  == 200){
        NSArray *missionList = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
        for (NSDictionary *missionDict in missionList){
            NSNumber *missionId = [missionDict valueForKey:@"missionId"];
            Mission *missionEntity = [self fetchMission:missionId withContext:YES];
            if(missionEntity == nil)
                missionEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Mission" inManagedObjectContext:context];
            [missionEntity initWithDictionary:missionDict];
        }
        
        [RORContextUtils saveContext];
        [RORUserUtils saveLastUpdateTime:@"MissionUpdateTime"];
    } else {
        NSLog(@"sync with host error: can't get mission list. Status Code: %d", [httpResponse responseStatus]);
        return NO;
    }
    return YES;
}

//open out
+(NSArray *)fetchMissionList{
    return [self fetchMissionList:MissionTypeEasy withContext:NO];
}

+(NSArray *)fetchMissionList:(MissionTypeEnum *) missionType withContext:(BOOL) needContext{
    NSString *table=@"Mission";
    NSString *query = @"missionTypeId = %@ and missionFlag != -1";
    NSArray *params = [NSArray arrayWithObjects:[NSNumber numberWithInteger:(NSInteger)missionType], nil];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"sequence" ascending:YES];
    NSArray *sortParams = [NSArray arrayWithObject:sortDescriptor];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query withOrderBy:sortParams];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    NSMutableArray *missionDetails = [NSMutableArray arrayWithCapacity:10];
    for (Mission *mission in fetchObject) {
        [missionDetails addObject:[Mission removeAssociateForEntity:mission]];
    }
    return [(NSArray*)missionDetails mutableCopy];
}

//open out
+ (Mission *)fetchDailyMission{
    NSError *error = nil;
    NSManagedObjectContext *context = [RORContextUtils getShareContext];
    NSString *lastUpdateTime = [RORUserUtils getLastUpdateTime:@"DailyMissionGetTime"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/MM/dd"]; //设置日期格式
    NSDate *today = [NSDate date]; //当前日期
    NSDate *fetchDay = [dateFormatter dateFromString:lastUpdateTime];
    BOOL b = [today isEqualToDate:fetchDay];//日期相同返回YES
    if(b){
        NSMutableDictionary *userDict = [RORUserUtils getUserInfoPList];
        NSNumber * missionId =  [userDict valueForKey:@"dailyMissionId"];
        return [self fetchMission:missionId];
    }
    else{
        RORHttpResponse *httpResponse =[RORMissionClientHandler getDailyMission:[RORUserUtils getUserId]];
        
        if ([httpResponse responseStatus]  == 200){
            NSDictionary *missionDict = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
            NSNumber *missionId = [missionDict valueForKey:@"missionId"];
            Mission *missionEntity = [self fetchMission:missionId withContext:YES];
            if(missionEntity == nil)
                missionEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Mission" inManagedObjectContext:context];
            [missionEntity initWithDictionary:missionDict];
            
            [RORContextUtils saveContext];
            [RORUserUtils saveLastUpdateTime:@"DailyMissionGetTime"];
            NSMutableDictionary *userDict = [RORUserUtils getUserInfoPList];
            [userDict setValue:missionId forKey:@"dailyMissionId"];
            [RORUserUtils writeToUserInfoPList:userDict];
            return [Mission removeAssociateForEntity:missionEntity];
        } else {
            NSLog(@"sync with host error: can't get daily mission. Status Code: %d", [httpResponse responseStatus]);
            return NO;
        }
        return nil;
    }
}
@end
