//
//  Action_Define.m
//  WalkFun
//
//  Created by leon on 14-2-16.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "Action_Define.h"
#import "RORDBCommon.h"

@implementation Action_Define

@dynamic actionType;
@dynamic inUsing;
@dynamic actionName;
@dynamic actionDescription;
@dynamic actionAttribute;
@dynamic actionRule;
@dynamic effectiveRule;
@dynamic actionId;
@dynamic triggerProbability;
@dynamic soundLink;
@dynamic updateTime;

+(Action_Define *) removeAssociateForEntity:(Action_Define *)associatedEntity{
    NSManagedObjectContext *context = [RORContextUtils getShareContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Action_Define" inManagedObjectContext:context];
    Action_Define *unassociatedEntity = [[Action_Define alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    for (NSString *attr in [[entity attributesByName] allKeys]) {
        [unassociatedEntity setValue:[associatedEntity valueForKey:attr] forKey:attr];
    }
    return unassociatedEntity;
}

-(void)initWithDictionary:(NSDictionary *)dict{
    self.actionId = [RORDBCommon getNumberFromId:[dict valueForKey:@"actionId"]];
    self.actionType = [RORDBCommon getNumberFromId:[dict valueForKey:@"actionType"]];
    self.inUsing = [RORDBCommon getNumberFromId:[dict valueForKey:@"inUsing"]];
    self.actionName = [RORDBCommon getStringFromId:[dict valueForKey:@"actionName"]];
    self.actionDescription = [RORDBCommon getStringFromId:[dict valueForKey:@"actionDescription"]];
    self.actionAttribute = [RORDBCommon getStringFromId:[dict valueForKey:@"actionAttribute"]];
    self.actionRule = [RORDBCommon getStringFromId:[dict valueForKey:@"actionRule"]];
    self.effectiveRule = [RORDBCommon getStringFromId:[dict valueForKey:@"effectiveRule"]];
    self.triggerProbability = [RORDBCommon getNumberFromId:[dict valueForKey:@"triggerProbability"]];
    self.soundLink = [RORDBCommon getStringFromId:[dict valueForKey:@"soundLink"]];
    self.updateTime = [RORDBCommon getDateFromId:[dict valueForKey:@"updateTime"]];
}

@end
