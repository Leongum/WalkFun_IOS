//
//  Friend_Sort.m
//  WalkFun
//
//  Created by leon on 14-1-25.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "Friend_Sort.h"
#import "RORDBCommon.h"

@implementation Friend_Sort

@dynamic totalDistance;
@dynamic userTitle;
@dynamic userTitlePic;
@dynamic level;
@dynamic sex;
@dynamic friendName;
@dynamic friendId;

+(Friend_Sort *) removeAssociateForEntity:(Friend_Sort *)associatedEntity{
    NSManagedObjectContext *context = [RORContextUtils getShareContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Friend_Sort" inManagedObjectContext:context];
    Friend_Sort *unassociatedEntity = [[Friend_Sort alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    for (NSString *attr in [[entity attributesByName] allKeys]) {
        [unassociatedEntity setValue:[associatedEntity valueForKey:attr] forKey:attr];
    }
    return unassociatedEntity;
}

-(void)initWithDictionary:(NSDictionary *)dict{
    self.friendId = [RORDBCommon getNumberFromId:[dict valueForKey:@"friendId"]];
    self.friendName = [RORDBCommon getStringFromId:[dict valueForKey:@"friendName"]];
    self.sex = [RORDBCommon getStringFromId:[dict valueForKey:@"sex"]];
    self.level = [RORDBCommon getNumberFromId:[dict valueForKey:@"level"]];
    self.userTitle = [RORDBCommon getStringFromId:[dict valueForKey:@"userTitle"]];
    self.userTitlePic = [RORDBCommon getStringFromId:[dict valueForKey:@"userTitlePic"]];
    self.totalDistance = [RORDBCommon getNumberFromId:[dict valueForKey:@"totalDistance"]];
}

@end
