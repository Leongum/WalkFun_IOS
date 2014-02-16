//
//  User_Mission_History.m
//  WalkFun
//
//  Created by leon on 14-1-25.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "User_Mission_History.h"
#import "RORDBCommon.h"

@implementation User_Mission_History

@dynamic missionUuid;
@dynamic userId;
@dynamic userName;
@dynamic missionId;
@dynamic missionName;
@dynamic startTime;
@dynamic endTime;
@dynamic lastRunTime;
@dynamic historyStatus;
@dynamic totalActiveTimes;
@dynamic updateTime;
@dynamic currentCombo;

+(User_Mission_History *) intiUnassociateEntity{
    NSManagedObjectContext *context = [RORContextUtils getShareContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User_Mission_History" inManagedObjectContext:context];
    User_Mission_History *unassociatedEntity = [[User_Mission_History alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    return unassociatedEntity;
}

+(User_Mission_History *) removeAssociateForEntity:(User_Mission_History *)associatedEntity{
    NSManagedObjectContext *context = [RORContextUtils getShareContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User_Mission_History" inManagedObjectContext:context];
    User_Mission_History *unassociatedEntity = [[User_Mission_History alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    for (NSString *attr in [[entity attributesByName] allKeys]) {
        [unassociatedEntity setValue:[associatedEntity valueForKey:attr] forKey:attr];
    }
    return unassociatedEntity;
}

-(void)initWithDictionary:(NSDictionary *)dict{
    self.missionUuid = [RORDBCommon getStringFromId:[dict valueForKey:@"missionUuid"]];
    self.userId = [RORDBCommon getNumberFromId:[dict valueForKey:@"userId"]];
    self.userName = [RORDBCommon getStringFromId:[dict valueForKey:@"userName"]];
    self.missionId = [RORDBCommon getNumberFromId:[dict valueForKey:@"missionId"]];
    self.missionName= [RORDBCommon getStringFromId:[dict valueForKey:@"missionName"]];
    self.startTime = [RORDBCommon getDateFromId:[dict valueForKey:@"startTime"]];
    self.endTime = [RORDBCommon getDateFromId:[dict valueForKey:@"endTime"]];
    self.lastRunTime = [RORDBCommon getDateFromId:[dict valueForKey:@"lastRunTime"]];
    self.historyStatus = [RORDBCommon getNumberFromId:[dict valueForKey:@"historyStatus"]];
    self.totalActiveTimes = [RORDBCommon getNumberFromId:[dict valueForKey:@"totalActiveTimes"]];
    self.updateTime = [RORDBCommon getDateFromId:[dict valueForKey:@"updateTime"]];
    self.currentCombo = [RORDBCommon getNumberFromId:[dict valueForKey:@"currentCombo"]];
}

-(NSMutableDictionary *)transToDictionary{
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    [tempDict setValue:self.missionUuid forKey:@"missionUuid"];
    [tempDict setValue:self.userId forKey:@"userId"];
    [tempDict setValue:self.userName forKey:@"userName"];
    [tempDict setValue:self.missionId forKey:@"missionId"];
    [tempDict setValue:self.missionName forKey:@"missionName"];
    [tempDict setValue:[RORDBCommon getStringFromId:self.startTime] forKey:@"startTime"];
    [tempDict setValue:[RORDBCommon getStringFromId:self.endTime] forKey:@"endTime"];
    [tempDict setValue:[RORDBCommon getStringFromId:self.lastRunTime] forKey:@"lastRunTime"];
    [tempDict setValue:self.historyStatus forKey:@"historyStatus"];
    [tempDict setValue:self.totalActiveTimes forKey:@"totalActiveTimes"];
    [tempDict setValue:self.currentCombo forKey:@"currentCombo"];
    return tempDict;
}

@end
