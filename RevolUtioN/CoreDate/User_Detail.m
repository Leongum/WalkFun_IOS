//
//  User_Detail.m
//  WalkFun
//
//  Created by leon on 14-1-25.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "User_Detail.h"
#import "RORDBCommon.h"

@implementation User_Detail

@dynamic userId;
@dynamic picId;
@dynamic userTitle;
@dynamic userTitleId;
@dynamic level;
@dynamic scores;
@dynamic avgSpeed;
@dynamic experience;
@dynamic totalActiveTimes;
@dynamic totalCarlorie;
@dynamic totalDistance;
@dynamic totalSteps;
@dynamic totalWalkingTimes;
@dynamic lastActiveTime;
@dynamic lastWalkingAddress;
@dynamic lastWalkingDistance;
@dynamic lastWalkingPoint;
@dynamic lastWalkingSteps;
@dynamic lastWalkingTime;
@dynamic maxCombo;
@dynamic currentCombo;
@dynamic updateTime;

+(User_Detail *) removeAssociateForEntity:(User_Detail *)associatedEntity{
    NSManagedObjectContext *context = [RORContextUtils getShareContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User_Detail" inManagedObjectContext:context];
    User_Detail *unassociatedEntity = [[User_Detail alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    for (NSString *attr in [[entity attributesByName] allKeys]) {
        [unassociatedEntity setValue:[associatedEntity valueForKey:attr] forKey:attr];
    }
    return unassociatedEntity;
}

-(void)initWithDictionary:(NSDictionary *)dict{
    self.userId = [RORDBCommon getNumberFromId:[dict valueForKey:@"userId"]];
    self.picId = [RORDBCommon getNumberFromId:[dict valueForKey:@"picId"]];
    self.userTitle = [RORDBCommon getStringFromId:[dict valueForKey:@"userTitle"]];
    self.userTitleId = [RORDBCommon getNumberFromId:[dict valueForKey:@"userTitleId"]];
    self.level = [RORDBCommon getNumberFromId:[dict valueForKey:@"level"]];
    self.scores = [RORDBCommon getNumberFromId:[dict valueForKey:@"scores"]];
    self.avgSpeed = [RORDBCommon getNumberFromId:[dict valueForKey:@"avgSpeed"]];
    self.experience = [RORDBCommon getNumberFromId:[dict valueForKey:@"experience"]];
    self.totalActiveTimes = [RORDBCommon getNumberFromId:[dict valueForKey:@"totalActiveTimes"]];
    self.totalCarlorie = [RORDBCommon getNumberFromId:[dict valueForKey:@"totalCarlorie"]];
    self.totalDistance = [RORDBCommon getNumberFromId:[dict valueForKey:@"totalDistance"]];
    self.totalSteps = [RORDBCommon getNumberFromId:[dict valueForKey:@"totalSteps"]];
    self.totalWalkingTimes = [RORDBCommon getNumberFromId:[dict valueForKey:@"totalWalkingTimes"]];
    self.lastActiveTime = [RORDBCommon getDateFromId:[dict valueForKey:@"lastActiveTime"]];
    self.lastWalkingAddress = [RORDBCommon getStringFromId:[dict valueForKey:@"lastWalkingAddress"]];
    self.lastWalkingDistance = [RORDBCommon getNumberFromId:[dict valueForKey:@"lastWalkingDistance"]];
    self.lastWalkingPoint = [RORDBCommon getStringFromId:[dict valueForKey:@"lastWalkingPoint"]];
    self.lastWalkingSteps = [RORDBCommon getNumberFromId:[dict valueForKey:@"lastWalkingSteps"]];
    self.lastWalkingTime = [RORDBCommon getNumberFromId:[dict valueForKey:@"lastWalkingTime"]];
    self.maxCombo = [RORDBCommon getNumberFromId:[dict valueForKey:@"maxCombo"]];
    self.currentCombo = [RORDBCommon getNumberFromId:[dict valueForKey:@"currentCombo"]];
    self.updateTime = [RORDBCommon getDateFromId:[dict valueForKey:@"updateTime"]];
}

-(NSMutableDictionary *)transToDictionary{
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    [tempDict setValue:self.userId forKey:@"userId"];
    [tempDict setValue:self.picId forKey:@"picId"];
    [tempDict setValue:self.userTitle forKey:@"userTitle"];
    [tempDict setValue:self.userTitleId forKey:@"userTitleId"];
    [tempDict setValue:self.level forKey:@"level"];
    [tempDict setValue:self.scores forKey:@"scores"];
    [tempDict setValue:self.avgSpeed forKey:@"avgSpeed"];
    [tempDict setValue:self.experience forKey:@"experience"];
    [tempDict setValue:self.totalActiveTimes forKey:@"totalActiveTimes"];
    [tempDict setValue:self.totalCarlorie forKey:@"totalCarlorie"];
    [tempDict setValue:self.totalDistance forKey:@"totalDistance"];
    [tempDict setValue:self.totalSteps forKey:@"totalSteps"];
    [tempDict setValue:self.totalWalkingTimes forKey:@"totalWalkingTimes"];
    [tempDict setValue:[RORDBCommon getStringFromId: self.lastActiveTime] forKey:@"lastActiveTime"];
    [tempDict setValue:self.lastWalkingAddress forKey:@"lastWalkingAddress"];
    [tempDict setValue:self.lastWalkingDistance forKey:@"lastWalkingDistance"];
    [tempDict setValue:self.lastWalkingPoint forKey:@"lastWalkingPoint"];
    [tempDict setValue:self.lastWalkingSteps forKey:@"lastWalkingSteps"];
    [tempDict setValue:self.lastWalkingTime forKey:@"lastWalkingTime"];
    [tempDict setValue:self.maxCombo forKey:@"maxCombo"];
    [tempDict setValue:self.currentCombo forKey:@"currentCombo"];
    return tempDict;
}

@end
