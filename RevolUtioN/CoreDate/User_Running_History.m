//
//  User_Running_History.m
//  RevolUtioN
//
//  Created by leon on 13828.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "User_Running_History.h"
#import "RORDBCommon.h"


@implementation User_Running_History

@dynamic userId;
@dynamic runUuid;
@dynamic missionId;
@dynamic missionTypeId;
@dynamic missionRoute;
@dynamic missionStartTime;
@dynamic missionEndTime;
@dynamic missionDate;
@dynamic spendCarlorie;
@dynamic duration;
@dynamic avgSpeed;
@dynamic steps;
@dynamic distance;
@dynamic missionGrade;
@dynamic goldCoin;
@dynamic extraGoldCoin;
@dynamic experience;
@dynamic extraExperience;
@dynamic fatness;
@dynamic health;
@dynamic actionIds;
@dynamic comment;
@dynamic valid;
@dynamic missionUuid;
@dynamic sequence;
@dynamic propGet;
@dynamic commitTime;
@dynamic friendId;
@dynamic friendName;

+(User_Running_History *) intiUnassociateEntity:(NSManagedObjectContext *) context{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User_Running_History" inManagedObjectContext:context];
    User_Running_History *unassociatedEntity = [[User_Running_History alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    return unassociatedEntity;
}

+(User_Running_History *) removeAssociateForEntity:(User_Running_History *)associatedEntity withContext:(NSManagedObjectContext *) context{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User_Running_History" inManagedObjectContext:context];
    User_Running_History *unassociatedEntity = [[User_Running_History alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    for (NSString *attr in [[entity attributesByName] allKeys]) {
        [unassociatedEntity setValue:[associatedEntity valueForKey:attr] forKey:attr];
    }
    return unassociatedEntity;
}

-(void)initWithDictionary:(NSDictionary *)dict{
    NSLog(@"%@",dict);
    self.avgSpeed = [RORDBCommon getNumberFromId:[dict valueForKey:@"avgSpeed"]];
    self.comment = [RORDBCommon getStringFromId:[dict valueForKey:@"comment"]];
    self.distance = [RORDBCommon getNumberFromId:[dict valueForKey:@"distance"]];
    self.userId = [RORDBCommon getNumberFromId:[dict valueForKey:@"userId"]];
    self.runUuid= [RORDBCommon getStringFromId:[dict valueForKey:@"runUuid"]];
    self.missionTypeId = [RORDBCommon getNumberFromId:[dict valueForKey:@"missionTypeId"]];
    self.missionRoute = [RORDBCommon getStringFromId:[dict valueForKey:@"missionRoute"]];
    self.missionStartTime = [RORDBCommon getDateFromId:[dict valueForKey:@"missionStartTime"]];
    self.missionEndTime = [RORDBCommon getDateFromId:[dict valueForKey:@"missionEndTime"]];
    self.missionDate = [RORDBCommon getDateFromId:[dict valueForKey:@"missionDate"]];
    self.spendCarlorie = [RORDBCommon getNumberFromId:[dict valueForKey:@"spendCarlorie"]];
    self.duration = [RORDBCommon getNumberFromId:[dict valueForKey:@"duration"]];
    self.missionGrade = [RORDBCommon getNumberFromId:[dict valueForKey:@"missionGrade"]];
    self.goldCoin = [RORDBCommon getNumberFromId:[dict valueForKey:@"goldCoin"]];
    self.extraGoldCoin = [RORDBCommon getNumberFromId:[dict valueForKey:@"extraGoldCoin"]];
    self.experience = [RORDBCommon getNumberFromId:[dict valueForKey:@"experience"]];
    self.extraExperience = [RORDBCommon getNumberFromId:[dict valueForKey:@"extraExperience"]];
    self.fatness = [RORDBCommon getNumberFromId:[dict valueForKey:@"fatness"]];
    self.health = [RORDBCommon getNumberFromId:[dict valueForKey:@"health"]];
    self.missionId = [RORDBCommon getNumberFromId:[dict valueForKey:@"missionId"]];
    self.steps = [RORDBCommon getNumberFromId:[dict valueForKey:@"steps"]];
    self.commitTime = [RORDBCommon getDateFromId:[dict valueForKey:@"commitTime"]];
    self.valid = [RORDBCommon getNumberFromId:[dict valueForKey:@"valid"]];
    self.missionUuid = [RORDBCommon getStringFromId:[dict valueForKey:@"missionUuid"]];
    self.sequence = [RORDBCommon getNumberFromId:[dict valueForKey:@"sequence"]];
    self.propGet = [RORDBCommon getStringFromId:[dict valueForKey:@"propGet"]];
    self.actionIds = [RORDBCommon getStringFromId:[dict valueForKey:@"actionIds"]];
    self.friendId = [RORDBCommon getNumberFromId:[dict valueForKey:@"friendId"]];
    self.friendName = [RORDBCommon getStringFromId:[dict valueForKey:@"friendName"]];
}

-(void)copyFromUserRunningHistory:(User_Running_History *)history{
    self.avgSpeed = [RORDBCommon getNumberFromId:history.avgSpeed];
    self.comment = [RORDBCommon getStringFromId:history.comment];
    self.distance = [RORDBCommon getNumberFromId:history.distance];
    self.userId = [RORDBCommon getNumberFromId:history.userId];
    self.runUuid= [RORDBCommon getStringFromId:history.runUuid];
    self.missionTypeId = [RORDBCommon getNumberFromId:history.missionTypeId];
    self.missionRoute = [RORDBCommon getStringFromId:history.missionRoute];
    self.missionStartTime = [RORDBCommon getDateFromId:history.missionStartTime];
    self.missionEndTime = [RORDBCommon getDateFromId:history.missionEndTime];
    self.missionDate = [RORDBCommon getDateFromId:history.missionDate];
    self.spendCarlorie = [RORDBCommon getNumberFromId:history.spendCarlorie];
    self.duration = [RORDBCommon getNumberFromId:history.duration];
    self.missionGrade = [RORDBCommon getNumberFromId:history.missionGrade];
    self.goldCoin = [RORDBCommon getNumberFromId:history.goldCoin];
    self.extraGoldCoin = [RORDBCommon getNumberFromId:history.extraGoldCoin];
    self.experience = [RORDBCommon getNumberFromId:history.experience];
    self.extraExperience = [RORDBCommon getNumberFromId:history.extraExperience];
    self.fatness = [RORDBCommon getNumberFromId:history.fatness];
    self.health = [RORDBCommon getNumberFromId:history.health];
    self.missionId = [RORDBCommon getNumberFromId:history.missionId];
    self.steps = [RORDBCommon getNumberFromId:history.steps];
    self.commitTime = [RORDBCommon getDateFromId:history.commitTime];
    self.valid = [RORDBCommon getNumberFromId:history.valid];
    self.missionUuid = [RORDBCommon getStringFromId:history.missionUuid];
    self.sequence = [RORDBCommon getNumberFromId:history.sequence];
    self.propGet = [RORDBCommon getStringFromId:history.propGet];
    self.actionIds = [RORDBCommon getStringFromId:history.actionIds];
    self.friendId = [RORDBCommon getNumberFromId:history.friendId];
    self.friendName = [RORDBCommon getStringFromId:history.friendName];
}

-(NSMutableDictionary *)transToDictionary{
    NSLog(@"%@",self);
    NSMutableDictionary *tempoDict = [[NSMutableDictionary alloc] init];
    [tempoDict setValue:self.avgSpeed forKey:@"avgSpeed"];
    [tempoDict setValue:self.comment forKey:@"comment"];
    [tempoDict setValue:self.distance forKey:@"distance"];
    [tempoDict setValue:self.userId forKey:@"userId"];
    [tempoDict setValue:self.runUuid forKey:@"runUuid"];
    [tempoDict setValue:self.missionTypeId forKey:@"missionTypeId"];
    [tempoDict setValue:self.missionRoute forKey:@"missionRoute"];
    [tempoDict setValue:[RORDBCommon getStringFromId:self.missionStartTime] forKey:@"missionStartTime"];
    [tempoDict setValue:[RORDBCommon getStringFromId:self.missionEndTime] forKey:@"missionEndTime"];
    [tempoDict setValue:[RORDBCommon getStringFromId:self.missionDate] forKey:@"missionDate"];
    [tempoDict setValue:self.spendCarlorie forKey:@"spendCarlorie"];
    [tempoDict setValue:self.duration forKey:@"duration"];
    [tempoDict setValue:self.steps forKey:@"steps"];
    [tempoDict setValue:self.missionGrade forKey:@"missionGrade"];
    [tempoDict setValue:self.goldCoin forKey:@"goldCoin"];
    [tempoDict setValue:self.extraGoldCoin forKey:@"extraGoldCoin"];
    [tempoDict setValue:self.experience forKey:@"experience"];
    [tempoDict setValue:self.extraExperience forKey:@"extraExperience"];
    [tempoDict setValue:self.fatness forKey:@"fatness"];
    [tempoDict setValue:self.health forKey:@"health"];
    [tempoDict setValue:self.missionId forKey:@"missionId"];
    [tempoDict setValue:[RORDBCommon getStringFromId:self.commitTime] forKey:@"commitTime"];
    [tempoDict setValue:self.valid forKey:@"valid"];
    [tempoDict setValue:self.missionUuid forKey:@"missionUuid"];
    [tempoDict setValue:self.sequence forKey:@"sequence"];
    [tempoDict setValue:self.propGet forKey:@"propGet"];
    [tempoDict setValue:self.actionIds forKey:@"actionIds"];
    [tempoDict setValue:self.friendId forKeyPath:@"friendId"];
    [tempoDict setValue:self.friendName forKeyPath:@"friendName"];
    return tempoDict;
}

@end
