//
//  User_Base.m
//  RevolUtioN
//
//  Created by leon on 13-8-28.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "User_Base.h"
#import "RORDBCommon.h"


@implementation User_Base

@dynamic userId;
@dynamic uuid;
@dynamic deviceId;
@dynamic userName;
@dynamic password;
@dynamic nickName;
@dynamic sex;
@dynamic age;
@dynamic weight;
@dynamic height;
@dynamic platformInfo;
@dynamic updateTime;

@synthesize userDetail;

+(User_Base *) intiUnassociateEntity{
    NSManagedObjectContext *context = [RORContextUtils getShareContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User_Base" inManagedObjectContext:context];
    User_Base *unassociatedEntity = [[User_Base alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    return unassociatedEntity;
}

+(User_Base *) removeAssociateForEntity:(User_Base *)associatedEntity{
    NSManagedObjectContext *context = [RORContextUtils getShareContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User_Base" inManagedObjectContext:context];
    User_Base *unassociatedEntity = [[User_Base alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    for (NSString *attr in [[entity attributesByName] allKeys]) {
        [unassociatedEntity setValue:[associatedEntity valueForKey:attr] forKey:attr];
    }
    unassociatedEntity.userDetail = [User_Detail removeAssociateForEntity:associatedEntity.userDetail];
    return unassociatedEntity;
}

-(void)initWithDictionary:(NSDictionary *)dict{
    self.userId = [RORDBCommon getNumberFromId:[dict valueForKey:@"userId"]];
    self.uuid = [RORDBCommon getStringFromId:[dict valueForKey:@"uuid"]];
    self.deviceId = [RORDBCommon getStringFromId:[dict valueForKey:@"deviceId"]];
    self.nickName = [RORDBCommon getStringFromId:[dict valueForKey:@"nickName"]];
    self.userName = [RORDBCommon getStringFromId:[dict valueForKey:@"userName"]];
    self.sex = [RORDBCommon getStringFromId:[dict valueForKey:@"sex"]];
    self.age = [RORDBCommon getNumberFromId:[dict valueForKey:@"age"]];
    self.weight = [RORDBCommon getNumberFromId:[dict valueForKey:@"weight"]];
    self.height = [RORDBCommon getNumberFromId:[dict valueForKey:@"height"]];
    self.platformInfo = [RORDBCommon getStringFromId:[dict valueForKey:@"platformInfo"]];
    self.updateTime = [RORDBCommon getDateFromId:[dict valueForKey:@"updateTime"]];
}

-(NSMutableDictionary *)transToDictionary{
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    [tempDict setValue:self.userId forKey:@"userId"];
    [tempDict setValue:self.uuid forKey:@"uuid"];
    [tempDict setValue:self.deviceId forKey:@"deviceId"];
    [tempDict setValue:self.userId forKey:@"userId"];
    [tempDict setValue:self.nickName forKey:@"nickName"];
    [tempDict setValue:self.userName forKey:@"userName"];
    [tempDict setValue:self.sex forKey:@"sex"];
    [tempDict setValue:self.age forKey:@"age"];
    [tempDict setValue:self.weight forKey:@"weight"];
    [tempDict setValue:self.height forKey:@"height"];
    [tempDict setValue:self.platformInfo forKey:@"platformInfo"];
    return tempDict;
}

@end
