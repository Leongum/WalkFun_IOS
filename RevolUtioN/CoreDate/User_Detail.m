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
@dynamic userTitlePic;
@dynamic userFatDesc;
@dynamic level;
@dynamic goldCoin;
@dynamic goldCoinSpeed;
@dynamic health;
@dynamic experienceSpeed;
@dynamic fatness;
@dynamic experience;
@dynamic totalActiveTimes;
@dynamic totalCarlorie;
@dynamic totalDistance;
@dynamic totalSteps;
@dynamic totalWalkingTimes;
@dynamic maxCombo;
@dynamic currentCombo;
@dynamic missionCombo;
@dynamic propHaving;
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
    self.userTitlePic = [RORDBCommon getStringFromId:[dict valueForKey:@"userTitlePic"]];
    self.userFatDesc = [RORDBCommon getStringFromId:[dict valueForKey:@"userFatDesc"]];
    self.level = [RORDBCommon getNumberFromId:[dict valueForKey:@"level"]];
    self.goldCoin = [RORDBCommon getNumberFromId:[dict valueForKey:@"goldCoin"]];
    self.goldCoinSpeed = [RORDBCommon getNumberFromId:[dict valueForKey:@"goldCoinSpeed"]];
    self.health = [RORDBCommon getNumberFromId:[dict valueForKey:@"health"]];
    self.fatness = [RORDBCommon getNumberFromId:[dict valueForKey:@"fatness"]];
    self.experience = [RORDBCommon getNumberFromId:[dict valueForKey:@"experience"]];
    self.experienceSpeed = [RORDBCommon getNumberFromId:[dict valueForKey:@"experienceSpeed"]];
    self.totalActiveTimes = [RORDBCommon getNumberFromId:[dict valueForKey:@"totalActiveTimes"]];
    self.totalCarlorie = [RORDBCommon getNumberFromId:[dict valueForKey:@"totalCarlorie"]];
    self.totalDistance = [RORDBCommon getNumberFromId:[dict valueForKey:@"totalDistance"]];
    self.totalSteps = [RORDBCommon getNumberFromId:[dict valueForKey:@"totalSteps"]];
    self.totalWalkingTimes = [RORDBCommon getNumberFromId:[dict valueForKey:@"totalWalkingTimes"]];
    self.maxCombo = [RORDBCommon getNumberFromId:[dict valueForKey:@"maxCombo"]];
    self.currentCombo = [RORDBCommon getNumberFromId:[dict valueForKey:@"currentCombo"]];
    self.missionCombo = [RORDBCommon getNumberFromId:[dict valueForKey:@"missionCombo"]];
    self.propHaving = [RORDBCommon getStringFromId:[dict valueForKey:@"propHaving"]];
    self.updateTime = [RORDBCommon getDateFromId:[dict valueForKey:@"updateTime"]];
}

-(NSMutableDictionary *)transToDictionary{
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    [tempDict setValue:self.userId forKey:@"userId"];
    [tempDict setValue:self.picId forKey:@"picId"];
    [tempDict setValue:self.userTitle forKey:@"userTitle"];
    [tempDict setValue:self.userTitlePic forKey:@"userTitlePic"];
    [tempDict setValue:self.userFatDesc forKey:@"userFatDesc"];
    [tempDict setValue:self.level forKey:@"level"];
    [tempDict setValue:self.goldCoin forKey:@"goldCoin"];
    [tempDict setValue:self.goldCoinSpeed forKey:@"goldCoinSpeed"];
    [tempDict setValue:self.health forKey:@"health"];
    [tempDict setValue:self.fatness forKey:@"fatness"];
    [tempDict setValue:self.experience forKey:@"experience"];
    [tempDict setValue:self.experienceSpeed forKey:@"experienceSpeed"];
    [tempDict setValue:self.totalActiveTimes forKey:@"totalActiveTimes"];
    [tempDict setValue:self.totalCarlorie forKey:@"totalCarlorie"];
    [tempDict setValue:self.totalDistance forKey:@"totalDistance"];
    [tempDict setValue:self.totalSteps forKey:@"totalSteps"];
    [tempDict setValue:self.totalWalkingTimes forKey:@"totalWalkingTimes"];
    [tempDict setValue:self.maxCombo forKey:@"maxCombo"];
    [tempDict setValue:self.currentCombo forKey:@"currentCombo"];
    [tempDict setValue:self.missionCombo forKey:@"missionCombo"];
    return tempDict;
}

@end
