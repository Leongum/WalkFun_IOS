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
    return [self fetchMissionHistoryByMissionUuid:missionUuid withContext:nil];
}

+(User_Mission_History *)fetchMissionHistoryByMissionUuid:(NSString *) missionUuid withContext:(NSManagedObjectContext *) context{
    
    NSString *table=@"User_Mission_History";
    NSString *query = @"missionUuid = %@";
    NSArray *params = [NSArray arrayWithObjects:missionUuid, nil];
    Boolean needContext = true;
    if (context == nil) {
        needContext = false;
        context = [RORContextUtils getPrivateContext];
    }
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query withContext: context];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    if (!needContext) {
        return [User_Mission_History removeAssociateForEntity:(User_Mission_History *) [fetchObject objectAtIndex:0] withContext:context];
    }
    return (User_Mission_History *) [fetchObject objectAtIndex:0];
    
}

//open out
+(NSArray*)fetchFinishedMissionHistoryByUserId:(NSNumber*)userId{
    return [self fetchFinishedMissionHistoryByUserId:userId withContext:nil];
}

+(NSArray*)fetchFinishedMissionHistoryByUserId:(NSNumber*)userId withContext:(NSManagedObjectContext *) context{
    NSString *table=@"User_Mission_History";
    NSString *query = @"userId = %@";
    NSArray *params = [NSArray arrayWithObjects:userId, nil];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"startTime" ascending:NO];
    NSArray *sortParams = [NSArray arrayWithObject:sortDescriptor];
    Boolean needContext = true;
    if(context == nil){
        context = [RORContextUtils getPrivateContext];
        needContext = false;
    }
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query withOrderBy:sortParams withContext:context];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    if(!needContext){
        NSMutableArray *historyList = [[NSMutableArray alloc] init];
        for (User_Mission_History *histroy in fetchObject) {
            [historyList addObject:[User_Mission_History removeAssociateForEntity:histroy withContext:context]];
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
        NSArray *dataList = [self fetchUnsyncedMissionHistories:nil];
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

+(NSArray *)fetchUnsyncedMissionHistories:(NSManagedObjectContext *) context{
    
    NSNumber *userId = [RORUserUtils getUserId];
    NSString *table=@"User_Mission_History";
    NSString *query = @"userId = %@ and updateTime = nil";
    NSArray *params = [NSArray arrayWithObjects:userId, nil];
    Boolean needContext = true;
    if(context == nil){
        context = [RORContextUtils getPrivateContext];
        needContext = false;
    }
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query withContext: context];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    if(!needContext){
        NSMutableArray *historyList = [[NSMutableArray alloc] init];
        for (User_Mission_History *histroy in fetchObject) {
            User_Mission_History *newHistory = [User_Mission_History removeAssociateForEntity:histroy withContext:context];
            [historyList addObject:newHistory];
        }
        return [historyList copy];
    }
    return fetchObject;
}

+(void)updateUnsyncedMissionHistories{
    NSManagedObjectContext *context = [RORContextUtils getPrivateContext];
    NSArray *fetchObject = [self fetchUnsyncedMissionHistories:context];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return;
    }
    for (User_Mission_History *info in fetchObject) {
        info.updateTime = [RORUserUtils getSystemTime];
    }
    [RORContextUtils saveContext:context];
}

//open out
+ (BOOL)syncMissionHistories:(NSNumber *)userId{
    //if(![RORNetWorkUtils getDoUploadable])return NO;
    NSError *error = nil;
    NSString *lastUpdateTime = [RORUserUtils getLastUpdateTime:@"MissionHistoryUpdateTime"];
     NSManagedObjectContext *context = [RORContextUtils getPrivateContext];
    RORHttpResponse *httpResponse =[RORRunHistoryClientHandler getMissionHistories:userId withLastUpdateTime:lastUpdateTime];
    if ([httpResponse responseStatus]  == 200){
        NSArray *missionHistoryList = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
        for (NSDictionary *missionHistoryDict in missionHistoryList){
            NSString *missionUuid = [missionHistoryDict valueForKey:@"missionUuid"];
            User_Mission_History *missionHistoryEntity = [self fetchMissionHistoryByMissionUuid:missionUuid withContext:context];
            //use local data insteade of service data when update in local.
            if(missionHistoryEntity!= nil && missionHistoryEntity.updateTime == nil){
                continue;
            }
            if(missionHistoryEntity == nil)
                missionHistoryEntity = [NSEntityDescription insertNewObjectForEntityForName:@"User_Mission_History" inManagedObjectContext:context];
            
            [missionHistoryEntity initWithDictionary:missionHistoryDict];
        }
        [RORContextUtils saveContext:context];
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
        NSManagedObjectContext *context = [RORContextUtils getPrivateContext];
        NSString *missionUuid = missionHistory.missionUuid;
        User_Mission_History *missionHistoryEntity = [self fetchMissionHistoryByMissionUuid:missionUuid withContext:context];
        if(missionHistoryEntity == nil)
            missionHistoryEntity = [NSEntityDescription insertNewObjectForEntityForName:@"User_Mission_History" inManagedObjectContext:context];
        //loop through all attributes and assign then to the clone
        NSDictionary *attributes = [[NSEntityDescription
                                     entityForName:@"User_Mission_History"
                                     inManagedObjectContext:context] attributesByName];
        
        for (NSString *attr in [attributes allKeys]) {
            [missionHistoryEntity setValue:[missionHistory valueForKey:attr] forKey:attr];
        }
        missionHistoryEntity.updateTime = nil;
        [RORContextUtils saveContext:context];
    }
    return YES;
}
@end
