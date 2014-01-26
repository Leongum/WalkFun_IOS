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
@dynamic missionTypeId;
@dynamic missionName;
@dynamic missionDescription;
@dynamic scores;
@dynamic experience;
@dynamic missionFlag;
@dynamic levelLimited;
@dynamic missionTimeLimited;
@dynamic missionDistanceLimited;
@dynamic missionToTimeLimited;
@dynamic missionFromTimeLimited;
@dynamic cycleTime;
@dynamic suggestionMaxSpeed;
@dynamic suggestionMinSpeed;
@dynamic sequence;
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
    self.missionDescription = [RORDBCommon getStringFromId:[dict valueForKey:@"missionDescription"]];
    self.scores = [RORDBCommon getNumberFromId:[dict valueForKey:@"scores"]];
    self.experience = [RORDBCommon getNumberFromId:[dict valueForKey:@"experience"]];
    self.missionFlag = [RORDBCommon getNumberFromId:[dict valueForKey:@"missionFlag"]];
    self.levelLimited = [RORDBCommon getNumberFromId:[dict valueForKey:@"levelLimited"]];
    self.missionTimeLimited = [RORDBCommon getNumberFromId:[dict valueForKey:@"missionTimeLimited"]];
    self.missionDistanceLimited = [RORDBCommon getNumberFromId:[dict valueForKey:@"missionDistanceLimited"]];
    self.missionFromTimeLimited = [RORDBCommon getNumberFromId:[dict valueForKey:@"missionFromTimeLimited"]];
    self.missionToTimeLimited = [RORDBCommon getNumberFromId:[dict valueForKey:@"missionToTimeLimited"]];
    self.cycleTime = [RORDBCommon getNumberFromId:[dict valueForKey:@"cycleTime"]];
    self.suggestionMaxSpeed = [RORDBCommon getNumberFromId:[dict valueForKey:@"suggestionMaxSpeed"]];
    self.suggestionMinSpeed = [RORDBCommon getNumberFromId:[dict valueForKey:@"suggestionMinSpeed"]];
    self.sequence = [RORDBCommon getNumberFromId:[dict valueForKey:@"sequence"]];
    self.updateTime = [RORDBCommon getDateFromId:[dict valueForKey:@"updateTime"]];
}
@end
