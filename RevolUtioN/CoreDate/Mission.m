//
//  Mission.m
//  RevolUtioN
//
//  Created by leon on 13828.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "Mission.h"
#import "RORDBCommon.h"

@implementation Mission

@dynamic missionId;
@dynamic missionTypeId;//0 for steps times limit 1 for prop drop limit 2 for prop use for user
@dynamic missionName;
@dynamic missionRule;
@dynamic missionDescription;
@dynamic triggerSteps;
@dynamic triggerTimes;
@dynamic triggerDistances;
@dynamic triggerPropId;
@dynamic triggerPropNumbers;
@dynamic triggerUserNumbers;
@dynamic goldCoin;
@dynamic experience;
@dynamic updateTime;

+(Mission *) removeAssociateForEntity:(Mission *)associatedEntity{
    NSManagedObjectContext *context = [RORContextUtils getShareContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Mission" inManagedObjectContext:context];
    Mission *unassociatedEntity = [[Mission alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    for (NSString *attr in [[entity attributesByName] allKeys]) {
        [unassociatedEntity setValue:[associatedEntity valueForKey:attr] forKey:attr];
    }
    return unassociatedEntity;
}

-(void)initWithDictionary:(NSDictionary *)dict{
    self.missionId = [RORDBCommon getNumberFromId:[dict valueForKey:@"missionId"]];
    self.missionName = [RORDBCommon getStringFromId:[dict valueForKey:@"missionName"]];
    self.missionTypeId = [RORDBCommon getNumberFromId:[dict valueForKey:@"missionTypeId"]];
    self.missionRule = [RORDBCommon getStringFromId:[dict valueForKey:@"missionRule"]];
    self.missionDescription = [RORDBCommon getStringFromId:[dict valueForKey:@"missionDescription"]];
    self.triggerSteps = [RORDBCommon getNumberFromId:[dict valueForKey:@"triggerSteps"]];
    self.triggerTimes = [RORDBCommon getNumberFromId:[dict valueForKey:@"triggerTimes"]];
    self.triggerDistances = [RORDBCommon getNumberFromId:[dict valueForKey:@"triggerDistances"]];
    self.triggerPropId = [RORDBCommon getNumberFromId:[dict valueForKey:@"triggerPropId"]];
    self.triggerPropNumbers = [RORDBCommon getNumberFromId:[dict valueForKey:@"triggerPropNumbers"]];
    self.triggerUserNumbers = [RORDBCommon getNumberFromId:[dict valueForKey:@"triggerUserNumbers"]];
    self.goldCoin = [RORDBCommon getNumberFromId:[dict valueForKey:@"goldCoin"]];
    self.experience = [RORDBCommon getNumberFromId:[dict valueForKey:@"experience"]];
    self.updateTime = [RORDBCommon getDateFromId:[dict valueForKey:@"updateTime"]];
}
@end
