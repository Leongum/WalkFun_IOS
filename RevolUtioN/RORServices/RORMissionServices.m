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


@end
