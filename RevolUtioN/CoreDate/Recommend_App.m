//
//  Recommend_App.m
//  WalkFun
//
//  Created by Bjorn on 14-1-10.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "Recommend_App.h"
#import "RORDBCommon.h"

@implementation Recommend_App
@dynamic appId;
@dynamic appPicLink;
@dynamic appName;
@dynamic appDescription;
@dynamic appAddress;
@dynamic updateTime;
@dynamic recommendStatus;
@dynamic sequence;

-(void)initWithDictionary:(NSDictionary *)dict{
    self.appId = [RORDBCommon getNumberFromId:[dict valueForKey:@"appId"]];
    self.appPicLink = [RORDBCommon getStringFromId:[dict valueForKey:@"appPicLink"]];
    self.appName = [RORDBCommon getStringFromId:[dict valueForKey:@"appName"]];
    self.appDescription = [RORDBCommon getStringFromId:[dict valueForKey:@"appDescription"]];
    self.appAddress = [RORDBCommon getStringFromId:[dict valueForKey:@"appAddress"]];
    self.updateTime = [RORDBCommon getDateFromId:[dict valueForKey:@"updateTime"]];
    self.recommendStatus = [RORDBCommon getNumberFromId:[dict valueForKey:@"recommendStatus"]];
    self.sequence = [RORDBCommon getNumberFromId:[dict valueForKey:@"sequence"]];
}

+(Recommend_App *) removeAssociateForEntity:(Recommend_App *)associatedEntity withContext:(NSManagedObjectContext *) context{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Recommend_App" inManagedObjectContext:context];
    Recommend_App *unassociatedEntity = [[Recommend_App alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    for (NSString *attr in [[entity attributesByName] allKeys]) {
        [unassociatedEntity setValue:[associatedEntity valueForKey:attr] forKey:attr];
    }
    return unassociatedEntity;
}

@end
