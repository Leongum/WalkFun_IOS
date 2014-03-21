//
//  Fight_Define.m
//  WalkFun
//
//  Created by leon on 14-3-21.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "Fight_Define.h"
#import "RORDBCommon.h"

@implementation Fight_Define

@dynamic fightId;
@dynamic inUsing;
@dynamic fightName;
@dynamic minLevelLimit;
@dynamic maxLevelLimit;
@dynamic monsterName;
@dynamic monsterLevel;
@dynamic monsterMaxFight;
@dynamic monsterMinFight;
@dynamic basePowerConsume;
@dynamic baseExperience;
@dynamic baseGold;
@dynamic fightWin;
@dynamic winGot;
@dynamic winGotRule;
@dynamic fightLoose;
@dynamic triggerProbability;
@dynamic updateTime;

+(Fight_Define *) removeAssociateForEntity:(Fight_Define *)associatedEntity{
    NSManagedObjectContext *context = [RORContextUtils getShareContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Fight_Define" inManagedObjectContext:context];
    Fight_Define *unassociatedEntity = [[Fight_Define alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    for (NSString *attr in [[entity attributesByName] allKeys]) {
        [unassociatedEntity setValue:[associatedEntity valueForKey:attr] forKey:attr];
    }
    return unassociatedEntity;
}

-(void)initWithDictionary:(NSDictionary *)dict{
    self.fightId = [RORDBCommon getNumberFromId:[dict valueForKey:@"id"]];
    self.inUsing = [RORDBCommon getNumberFromId:[dict valueForKey:@"inUsing"]];
    self.fightName = [RORDBCommon getStringFromId:[dict valueForKey:@"fName"]];
    self.monsterName = [RORDBCommon getStringFromId:[dict valueForKey:@"mName"]];
    self.monsterLevel = [RORDBCommon getNumberFromId:[dict valueForKey:@"mLevel"]];
    self.monsterMaxFight = [RORDBCommon getNumberFromId:[dict valueForKey:@"mMaxFight"]];
    self.monsterMinFight = [RORDBCommon getNumberFromId:[dict valueForKey:@"mMinFight"]];
    self.basePowerConsume = [RORDBCommon getNumberFromId:[dict valueForKey:@"bPower"]];
    self.baseExperience = [RORDBCommon getNumberFromId:[dict valueForKey:@"bExperience"]];
    self.baseGold = [RORDBCommon getNumberFromId:[dict valueForKey:@"bGold"]];
    self.fightWin = [RORDBCommon getStringFromId:[dict valueForKey:@"fWin"]];
    self.winGot = [RORDBCommon getStringFromId:[dict valueForKey:@"winGot"]];
    self.winGotRule = [RORDBCommon getStringFromId:[dict valueForKey:@"winRule"]];
    self.fightLoose = [RORDBCommon getStringFromId:[dict valueForKey:@"fLoose"]];
    self.triggerProbability =[RORDBCommon getNumberFromId:[dict valueForKey:@"tProb"]];
    self.minLevelLimit = [RORDBCommon getNumberFromId:[dict valueForKey:@"minLimit"]];
    self.maxLevelLimit = [RORDBCommon getNumberFromId:[dict valueForKey:@"maxLimit"]];
    self.updateTime = [RORDBCommon getDateFromId:[dict valueForKey:@"updateTime"]];
}

@end
