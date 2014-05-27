//
//  RORRunHistoryServices.m
//  RevolUtioN
//
//  Created by leon on 13-7-22.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORRunHistoryServices.h"
#import "RORNetWorkUtils.h"
//#import "RORUserServices.h"
//#import "RORUserPropsService.h"

@implementation RORRunHistoryServices

/*  --------------------------
 
 user running history
 
 -------------------------------*/

//open out
+(User_Running_History *)fetchRunHistoryByRunId:(NSString *) runUuid{
    return [self fetchRunHistoryByRunId:runUuid withContext:nil];
}

+(User_Running_History *)fetchRunHistoryByRunId:(NSString *) runUuid withContext:(NSManagedObjectContext *) context{
    
    NSString *table=@"User_Running_History";
    NSString *query = @"runUuid = %@";
    NSArray *params = [NSArray arrayWithObjects:runUuid, nil];
    Boolean needContext = true;
    if(context == nil){
        context = [RORContextUtils getPrivateContext];
        needContext = false;
    }
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query withContext:context];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    if (!needContext) {
        return [User_Running_History removeAssociateForEntity:(User_Running_History *) [fetchObject objectAtIndex:0] withContext:context];
    }
    return (User_Running_History *) [fetchObject objectAtIndex:0];
    
}

//open out
+(NSArray*)fetchRunHistoryByUserId:(NSNumber*)userId{
    return [self fetchRunHistoryByUserId:userId withContext:nil];
}

+(NSArray*)fetchRunHistoryByUserId:(NSNumber*)userId withContext:(NSManagedObjectContext *) context{
    NSString *table=@"User_Running_History";
    NSString *query = @"userId = %@";
    NSArray *params = [NSArray arrayWithObjects:userId, nil];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"missionStartTime" ascending:NO];
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
        for (User_Running_History *histroy in fetchObject) {
            [historyList addObject:[User_Running_History removeAssociateForEntity:histroy withContext:context]];
        }
        return [historyList copy];
    }
    return fetchObject;
}

//open out
+ (BOOL)uploadRunningHistories{
    //if(![RORNetWorkUtils getDoUploadable])return NO;
    NSNumber *userId = [RORUserUtils getUserId];
    if(userId.integerValue > 0){
        NSArray *dataList = [self fetchUnsyncedRunHistories:nil];
        if([dataList count] > 0){
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (User_Running_History *history in dataList) {
                history.userId = userId;
                history.commitTime = [RORUserUtils getSystemTime];
                [array addObject:history.transToDictionary];
            }
            RORHttpResponse *httpResponse = [RORRunHistoryClientHandler createRunHistories:userId withRunHistories:array];
            if ([httpResponse responseStatus] == 200){
                [self updateUnsyncedRunHistories];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_GetUserDetails" object:nil userInfo:nil];
                //[RORUserServices syncUserInfoById:userId];
                //[RORUserPropsService syncUserProps:userId];
                return YES;
                
            } else {
                NSLog(@"error: statCode = %@", [httpResponse errorMessage]);
                return NO;
            }
        }
    }
    return YES;
}

+(NSArray *)fetchUnsyncedRunHistories:(NSManagedObjectContext *) context{
    
    NSNumber *userId = [RORUserUtils getUserId];
    NSString *table=@"User_Running_History";
    NSString *query = @"userId = %@ and commitTime = nil";
    NSArray *params = [NSArray arrayWithObjects:userId, nil];
    Boolean needContext = true;
    if(context == nil){
        context = [RORContextUtils getPrivateContext];
        needContext = false;
    }
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query withContext:context];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    if(!needContext){
        NSMutableArray *historyList = [[NSMutableArray alloc] init];
        for (User_Running_History *histroy in fetchObject) {
            User_Running_History *newHistory = [User_Running_History removeAssociateForEntity:histroy withContext: context];
            [historyList addObject:newHistory];
        }
        return [historyList copy];
    }
    return fetchObject;
}

+(void)updateUnsyncedRunHistories{
    NSNumber *userId = [RORUserUtils getUserId];
    NSManagedObjectContext *context = [RORContextUtils getPrivateContext];
    NSArray *fetchObject = [self fetchUnsyncedRunHistories:context];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return;
    }
    for (User_Running_History *info in fetchObject) {
        info.userId = userId;
        info.commitTime = [RORUserUtils getSystemTime];
    }
    [RORContextUtils saveContext:context];
}

//open out
+ (BOOL)syncRunningHistories:(NSNumber *)userId{
    //if(![RORNetWorkUtils getDoUploadable])return NO;
    NSError *error = nil;
    NSString *lastUpdateTime = [RORUserUtils getLastUpdateTime:@"RunningHistoryUpdateTime"];
    
    RORHttpResponse *httpResponse =[RORRunHistoryClientHandler getRunHistories:userId withLastUpdateTime:lastUpdateTime];
     NSManagedObjectContext *context = [RORContextUtils getPrivateContext];
    if ([httpResponse responseStatus]  == 200){
        NSArray *runHistoryList = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
        for (NSDictionary *runHistoryDict in runHistoryList){
            NSString *runUuid = [runHistoryDict valueForKey:@"runUuid"];
            User_Running_History *runHistoryEntity = [self fetchRunHistoryByRunId:runUuid withContext:context];
            if(runHistoryEntity == nil)
                runHistoryEntity = [NSEntityDescription insertNewObjectForEntityForName:@"User_Running_History" inManagedObjectContext:context];
            [runHistoryEntity initWithDictionary:runHistoryDict];
        }
        [RORContextUtils saveContext:context];
        [RORUserUtils saveLastUpdateTime:@"RunningHistoryUpdateTime"];
        return YES;
    } else {
        NSLog(@"sync with host error: can't sync running history. Status Code: %d", [httpResponse responseStatus]);
    }
    return NO;
}


//open out
+ (NSMutableArray *)getSimpleRunningHistories:(NSNumber *)userId{
    NSError *error = nil;
    RORHttpResponse *httpResponse =[RORRunHistoryClientHandler getSimpleRunHistories:userId];
    if ([httpResponse responseStatus]  == 200){
        NSArray *simpleRunHistoryList = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
        NSMutableArray *simpleHistoryList = [[NSMutableArray alloc] init];
        for (NSDictionary *simpleRunHistoryDict in simpleRunHistoryList){
            Simple_User_Run_History *simpleRunHistory = [[Simple_User_Run_History alloc] init];
            [simpleRunHistory initWithDictionary:simpleRunHistoryDict];
            [simpleHistoryList addObject:simpleRunHistory];
        }
        return simpleHistoryList;
    } else {
        NSLog(@"sync with host error: can't get Simple Running Histories. Status Code: %d", [httpResponse responseStatus]);
    }
    return nil;
}

//open out
+ (BOOL) saveRunInfoToDB:(User_Running_History *)runningHistory{
    //check uuid
    if(runningHistory.runUuid != nil){
        NSManagedObjectContext *context = [RORContextUtils getPrivateContext];
        User_Running_History *runHistory = [NSEntityDescription insertNewObjectForEntityForName:@"User_Running_History" inManagedObjectContext:context];
        //loop through all attributes and assign then to the clone
        NSDictionary *attributes = [[NSEntityDescription
                                     entityForName:@"User_Running_History"
                                     inManagedObjectContext:context] attributesByName];
        
        for (NSString *attr in [attributes allKeys]) {
            [runHistory setValue:[runningHistory valueForKey:attr] forKey:attr];
        }
        runHistory.commitTime = nil;
        [RORContextUtils saveContext:context];
    }
    return YES;
}

//open out
+(NSArray *)fetchRunHistoryByMissionUuid:(NSString *) missionUuid{
    NSString *table=@"User_Running_History";
    NSString *query = @"missionUuid = %@ and valid = 1";
    NSArray *params = [NSArray arrayWithObjects:missionUuid, nil];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"sequence" ascending:YES];
    NSArray *sortParams = [NSArray arrayWithObject:sortDescriptor];
    NSManagedObjectContext *context = [RORContextUtils getPrivateContext];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query withOrderBy:sortParams withContext:context];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    NSMutableArray *historyList = [[NSMutableArray alloc] init];
    for (User_Running_History *histroy in fetchObject) {
        User_Running_History *newHistory = [User_Running_History removeAssociateForEntity:histroy withContext:context];
        [historyList addObject:newHistory];
    }
    return [historyList copy];
}




@end
