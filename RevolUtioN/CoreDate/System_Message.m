//
//  System_Message.m
//  RevolUtioN
//
//  Created by leon on 13-9-14.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "System_Message.h"
#import "RORDBCommon.h"

@implementation System_Message

@dynamic updateTime;
@dynamic message;
@dynamic messageId;
@dynamic rule;

+(System_Message *) removeAssociateForEntity:(System_Message *)associatedEntity{
    NSManagedObjectContext *context = [RORContextUtils getShareContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"System_Message" inManagedObjectContext:context];
    System_Message *unassociatedEntity = [[System_Message alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    for (NSString *attr in [[entity attributesByName] allKeys]) {
        [unassociatedEntity setValue:[associatedEntity valueForKey:attr] forKey:attr];
    }
    return unassociatedEntity;
}

-(void)initWithDictionary:(NSDictionary *)dict{
    self.messageId = [RORDBCommon getNumberFromId:[dict valueForKey:@"messageId"]];
    self.rule = [RORDBCommon getStringFromId:[dict valueForKey:@"rule"]];
    self.message = [RORDBCommon getStringFromId:[dict valueForKey:@"message"]];
    self.updateTime = [RORDBCommon getDateFromId:[dict valueForKey:@"updateTime"]];
}

@end
