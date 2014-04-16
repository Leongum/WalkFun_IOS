//
//  Friend.m
//  RevolUtioN
//
//  Created by leon on 13-8-28.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "Friend.h"
#import "RORDBCommon.h"

@implementation Friend

@dynamic addTime;
@dynamic friendId;
@dynamic friendStatus;
@dynamic friendEach;
@dynamic updateTime;
@dynamic userId;
@dynamic lastWalkTime;

@synthesize sex;
@synthesize userName;
@synthesize userTitle;
@synthesize level;
@synthesize fight,fightPlus,power,powerPlus;
@synthesize totalFights;
@synthesize fightsWin;
@synthesize totalFriendFights;
@synthesize friendFightWin;

+(Friend *) removeAssociateForEntity:(Friend *)associatedEntity{
    NSManagedObjectContext *context = [RORContextUtils getShareContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Friend" inManagedObjectContext:context];
    Friend *unassociatedEntity = [[Friend alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    for (NSString *attr in [[entity attributesByName] allKeys]) {
        [unassociatedEntity setValue:[associatedEntity valueForKey:attr] forKey:attr];
    }
    return unassociatedEntity;
}

-(void)initWithDictionary:(NSDictionary *)dict{
    self.userId = [RORDBCommon getNumberFromId:[dict valueForKey:@"userId"]];
    self.friendId = [RORDBCommon getNumberFromId:[dict valueForKey:@"friendId"]];
    self.friendStatus = [RORDBCommon getNumberFromId:[dict valueForKey:@"friendStatus"]];
    self.friendEach = [RORDBCommon getNumberFromId:[dict valueForKey:@"friendEach"]];
    self.addTime = [RORDBCommon getDateFromId:[dict valueForKey:@"addTime"]];
    self.updateTime = [RORDBCommon getDateFromId:[dict valueForKey:@"updateTime"]];
    self.lastWalkTime = [RORDBCommon getDateFromId:[dict valueForKey:@"lastWalkTime"]];
}

-(NSMutableDictionary *)transToDictionary{
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    [tempDict setValue:self.userId forKey:@"userId"];
    [tempDict setValue:self.friendId forKey:@"friendId"];
    [tempDict setValue:self.friendStatus forKey:@"friendStatus"];
    [tempDict setValue:self.friendEach forKey:@"friendEach"];
    [tempDict setValue:self.lastWalkTime forKey:@"lastWalkTime"];
    return tempDict;
}

+(Friend *) intiUnassociateEntity{
    NSManagedObjectContext *context = [RORContextUtils getShareContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Friend" inManagedObjectContext:context];
    Friend *unassociatedEntity = [[Friend alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    return unassociatedEntity;
}
@end
