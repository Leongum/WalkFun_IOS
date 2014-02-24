//
//  RORMissionHistoyService.m
//  WalkFun
//
//  Created by leon on 14-1-26.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "RORMissionHistoyService.h"
#import "RORContextUtils.h"
#import "RORUserServices.h"

@implementation RORMissionHistoyService

//open out
+(User_Mission_History *)fetchMissionHistoryByMissionUuid:(NSString *) missionUuid{
    return [self fetchMissionHistoryByMissionUuid:missionUuid withContext:NO];
}

+(User_Mission_History *)fetchMissionHistoryByMissionUuid:(NSString *) missionUuid withContext:(BOOL) needContext{
    
    NSString *table=@"User_Mission_History";
    NSString *query = @"missionUuid = %@";
    NSArray *params = [NSArray arrayWithObjects:missionUuid, nil];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    if (!needContext) {
        return [User_Mission_History removeAssociateForEntity:(User_Mission_History *) [fetchObject objectAtIndex:0]];
    }
    return (User_Mission_History *) [fetchObject objectAtIndex:0];
    
}

//open out
+(NSArray*)fetchFinishedMissionHistoryByUserId:(NSNumber*)userId{
    return [self fetchFinishedMissionHistoryByUserId:userId withContext:NO];
}

+(NSArray*)fetchFinishedMissionHistoryByUserId:(NSNumber*)userId withContext:(BOOL) needContext{
    NSString *table=@"User_Mission_History";
    NSString *query = @"userId = %@";
    NSArray *params = [NSArray arrayWithObjects:userId, nil];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"startTime" ascending:NO];
    NSArray *sortParams = [NSArray arrayWithObject:sortDescriptor];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query withOrderBy:sortParams];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    if(!needContext){
        NSMutableArray *historyList = [[NSMutableArray alloc] init];
        for (User_Mission_History *histroy in fetchObject) {
            [historyList addObject:[User_Mission_History removeAssociateForEntity:histroy]];
        }
        return [historyList copy];
    }
    return fetchObject;
}

//open out
+ (BOOL)uploadMissionHistories{
    //if(![RORNetWorkUtils getDoUploadable])return NO;
    NSNumber *userId = [RORUserUtils getUserId];
    if(userId.integerValue > 0){
        NSArray *dataList = [self fetchUnsyncedMissionHistories:NO];
        if([dataList count] > 0){
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (User_Mission_History *history in dataList) {
                history.updateTime = [RORUserUtils getSystemTime];
                [array addObject:history.transToDictionary];
            }
            RORHttpResponse *httpResponse = [RORRunHistoryClientHandler createMissionHistories:userId withMissionHistories:array];
            if ([httpResponse responseStatus] == 200){
                [self updateUnsyncedMissionHistories];
                [RORUserServices syncUserInfoById:userId];
                return YES;
                
            } else {
                NSLog(@"error: statCode = %@", [httpResponse errorMessage]);
                return NO;
            }
        }
    }
    return YES;
}

+(NSArray *)fetchUnsyncedMissionHistories:(BOOL) needContext{
    
    NSNumber *userId = [RORUserUtils getUserId];
    NSString *table=@"User_Mission_History";
    NSString *query = @"userId = %@ and updateTime = nil";
    NSArray *params = [NSArray arrayWithObjects:userId, nil];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    if(!needContext){
        NSMutableArray *historyList = [[NSMutableArray alloc] init];
        for (User_Mission_History *histroy in fetchObject) {
            User_Mission_History *newHistory = [User_Mission_History removeAssociateForEntity:histroy];
            [historyList addObject:newHistory];
        }
        return [historyList copy];
    }
    return fetchObject;
}

+(void)updateUnsyncedMissionHistories{
    NSArray *fetchObject = [self fetchUnsyncedMissionHistories:YES];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return;
    }
    for (User_Mission_History *info in fetchObject) {
        info.updateTime = [RORUserUtils getSystemTime];
    }
    [RORContextUtils saveContext];
}

//open out
+ (BOOL)syncMissionHistories:(NSNumber *)userId{
    //if(![RORNetWorkUtils getDoUploadable])return NO;
    NSError *error = nil;
    NSString *lastUpdateTime = [RORUserUtils getLastUpdateTime:@"MissionHistoryUpdateTime"];
    
    RORHttpResponse *httpResponse =[RORRunHistoryClientHandler getMissionHistories:userId withLastUpdateTime:lastUpdateTime];
    if ([httpResponse responseStatus]  == 200){
        NSArray *missionHistoryList = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
        for (NSDictionary *missionHistoryDict in missionHistoryList){
            NSString *missionUuid = [missionHistoryDict valueForKey:@"missionUuid"];
            User_Mission_History *missionHistoryEntity = [self fetchMissionHistoryByMissionUuid:missionUuid withContext:YES];
            //use local data insteade of service data when update in local.
            if(missionHistoryEntity!= nil && missionHistoryEntity.updateTime == nil){
                continue;
            }
            if(missionHistoryEntity == nil)
                missionHistoryEntity = [NSEntityDescription insertNewObjectForEntityForName:@"User_Mission_History" inManagedObjectContext:[RORContextUtils getShareContext]];
            
            [missionHistoryEntity initWithDictionary:missionHistoryDict];
        }
        [RORContextUtils saveContext];
        [RORUserUtils saveLastUpdateTime:@"MissionHistoryUpdateTime"];
        return YES;
    } else {
        NSLog(@"sync with host error: can't get mission list. Status Code: %d", [httpResponse responseStatus]);
    }
    return NO;
}

//open out
//do all update or insert things.
+ (BOOL) saveMissionHistoryInfoToDB:(User_Mission_History *)missionHistory{
    //check uuid
    if(missionHistory.missionUuid != nil){
        NSString *missionUuid = missionHistory.missionUuid;
        User_Mission_History *missionHistoryEntity = [self fetchMissionHistoryByMissionUuid:missionUuid withContext:YES];
        if(missionHistoryEntity == nil)
            missionHistoryEntity = [NSEntityDescription insertNewObjectForEntityForName:@"User_Mission_History" inManagedObjectContext:[RORContextUtils getShareContext]];
        //loop through all attributes and assign then to the clone
        NSDictionary *attributes = [[NSEntityDescription
                                     entityForName:@"User_Mission_History"
                                     inManagedObjectContext:[RORContextUtils getShareContext]] attributesByName];
        
        for (NSString *attr in [attributes allKeys]) {
            [missionHistoryEntity setValue:[missionHistory valueForKey:attr] forKey:attr];
        }
        missionHistoryEntity.updateTime = nil;
        [RORContextUtils saveContext];
    }
    return YES;
}
@end
