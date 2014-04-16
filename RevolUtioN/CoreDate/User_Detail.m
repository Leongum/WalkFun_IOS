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
@dynamic level;
@dynamic goldCoin;
@dynamic fatness;
@dynamic power;
@dynamic powerPlus;
@dynamic fight;
@dynamic fightPlus;
@dynamic experience;
@dynamic totalActiveTimes;
@dynamic totalCarlorie;
@dynamic totalDistance;
@dynamic totalSteps;
@dynamic totalWalkingTimes;
@dynamic totalFights;
@dynamic fightsWin;
@dynamic totalFriendFights;
@dynamic friendFightWin;
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
    self.level = [RORDBCommon getNumberFromId:[dict valueForKey:@"level"]];
    self.goldCoin = [RORDBCommon getNumberFromId:[dict valueForKey:@"goldCoin"]];
    self.fatness = [RORDBCommon getNumberFromId:[dict valueForKey:@"fatness"]];
    self.power = [RORDBCommon getNumberFromId:[dict valueForKey:@"power"]];
    self.powerPlus = [RORDBCommon getNumberFromId:[dict valueForKey:@"powerPlus"]];
    self.fight = [RORDBCommon getNumberFromId:[dict valueForKey:@"fight"]];
    self.fightPlus = [RORDBCommon getNumberFromId:[dict valueForKey:@"fightPlus"]];
    self.experience = [RORDBCommon getNumberFromId:[dict valueForKey:@"experience"]];
    self.totalActiveTimes = [RORDBCommon getNumberFromId:[dict valueForKey:@"totalActiveTimes"]];
    self.totalCarlorie = [RORDBCommon getNumberFromId:[dict valueForKey:@"totalCarlorie"]];
    self.totalDistance = [RORDBCommon getNumberFromId:[dict valueForKey:@"totalDistance"]];
    self.totalSteps = [RORDBCommon getNumberFromId:[dict valueForKey:@"totalSteps"]];
    self.totalWalkingTimes = [RORDBCommon getNumberFromId:[dict valueForKey:@"totalWalkingTimes"]];
    self.totalFights = [RORDBCommon getNumberFromId:[dict valueForKey:@"totalFights"]];
    self.fightsWin = [RORDBCommon getNumberFromId:[dict valueForKey:@"fightsWin"]];
    self.totalFriendFights = [RORDBCommon getNumberFromId:[dict valueForKey:@"totalFriendFights"]];
    self.friendFightWin = [RORDBCommon getNumberFromId:[dict valueForKey:@"friendFightWin"]];
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
    [tempDict setValue:self.level forKey:@"level"];
    [tempDict setValue:self.goldCoin forKey:@"goldCoin"];
    [tempDict setValue:self.fatness forKey:@"fatness"];
    [tempDict setValue:self.power forKey:@"power"];
    [tempDict setValue:self.powerPlus forKey:@"powerPlus"];
    [tempDict setValue:self.fight forKey:@"fight"];
    [tempDict setValue:self.fightPlus forKey:@"fightPlus"];
    [tempDict setValue:self.experience forKey:@"experience"];
    [tempDict setValue:self.totalActiveTimes forKey:@"totalActiveTimes"];
    [tempDict setValue:self.totalCarlorie forKey:@"totalCarlorie"];
    [tempDict setValue:self.totalDistance forKey:@"totalDistance"];
    [tempDict setValue:self.totalSteps forKey:@"totalSteps"];
    [tempDict setValue:self.totalWalkingTimes forKey:@"totalWalkingTimes"];
    [tempDict setValue:self.totalFights forKey:@"totalFights"];
    [tempDict setValue:self.fightsWin forKey:@"fightsWin"];
    [tempDict setValue:self.totalFriendFights forKey:@"totalFriendFights"];
    [tempDict setValue:self.friendFightWin forKey:@"friendFightWin"];
    [tempDict setValue:self.missionCombo forKey:@"missionCombo"];
    return tempDict;
}

@end
