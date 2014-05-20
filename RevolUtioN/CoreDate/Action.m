//
//  Action.m
//  WalkFun
//
//  Created by leon on 14-1-25.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "Action.h"
#import "RORDBCommon.h"

@implementation Action

@dynamic actionFromId;
@dynamic actionFromName;
@dynamic actionToId;
@dynamic actionToName;
@dynamic actionId;
@dynamic actionName;
@dynamic updateTime;


+(Action *) initUnassociateEntity:(NSManagedObjectContext *) context{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Action" inManagedObjectContext:context];
    Action *unassociatedEntity = [[Action alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    return unassociatedEntity;
}

+(Action *) removeAssociateForEntity:(Action *)associatedEntity  withContext:(NSManagedObjectContext *) context{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Action" inManagedObjectContext:context];
    Action *unassociatedEntity = [[Action alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    for (NSString *attr in [[entity attributesByName] allKeys]) {
        [unassociatedEntity setValue:[associatedEntity valueForKey:attr] forKey:attr];
    }
    return unassociatedEntity;
}

-(void)initWithDictionary:(NSDictionary *)dict{
    self.actionFromId = [RORDBCommon getNumberFromId:[dict valueForKey:@"actionFromId"]];
    self.actionFromName = [RORDBCommon getStringFromId:[dict valueForKey:@"actionFromName"]];
    self.actionToId = [RORDBCommon getNumberFromId:[dict valueForKey:@"actionToId"]];
    self.actionToName = [RORDBCommon getStringFromId:[dict valueForKey:@"actionToName"]];
    self.actionId = [RORDBCommon getNumberFromId:[dict valueForKey:@"actionId"]];
    self.actionName = [RORDBCommon getStringFromId:[dict valueForKey:@"actionName"]];
    self.updateTime = [RORDBCommon getDateFromId:[dict valueForKey:@"updateTime"]];
}

-(NSMutableDictionary *)transToDictionary{
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    [tempDict setValue:self.actionFromId forKey:@"actionFromId"];
    [tempDict setValue:self.actionFromName forKey:@"actionFromName"];
    [tempDict setValue:self.actionToId forKey:@"actionToId"];
    [tempDict setValue:self.actionToName forKey:@"actionToName"];
    [tempDict setValue:self.actionId forKey:@"actionId"];
    [tempDict setValue:self.actionName forKey:@"actionName"];
    return tempDict;
}

@end
