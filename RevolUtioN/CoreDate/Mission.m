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
@dynamic triggerActionId;
@dynamic triggerFightId;
@dynamic triggerNumbers;
@dynamic goldCoin;
@dynamic experience;
@dynamic maxLevelLimit;
@dynamic minLevelLimit;
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
    self.triggerActionId = [RORDBCommon getNumberFromId:[dict valueForKey:@"triggerActionId"]];
    self.triggerFightId = [RORDBCommon getNumberFromId:[dict valueForKey:@"triggerFightId"]];
    self.triggerNumbers = [RORDBCommon getNumberFromId:[dict valueForKey:@"triggerNumbers"]];
    self.goldCoin = [RORDBCommon getNumberFromId:[dict valueForKey:@"goldCoin"]];
    self.experience = [RORDBCommon getNumberFromId:[dict valueForKey:@"experience"]];
    self.maxLevelLimit = [RORDBCommon getNumberFromId:[dict valueForKey:@"maxLevelLimit"]];
    self.minLevelLimit = [RORDBCommon getNumberFromId:[dict valueForKey:@"minLevelLimit"]];
    self.updateTime = [RORDBCommon getDateFromId:[dict valueForKey:@"updateTime"]];
}
@end
