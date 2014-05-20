//
//  User_Prop.m
//  WalkFun
//
//  Created by leon on 14-2-14.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "User_Prop.h"
#import "RORDBCommon.h"

@implementation User_Prop

@dynamic ownNumber;
@dynamic productName;
@dynamic productId;
@dynamic userId;
@dynamic updateTime;

+(User_Prop *) intiUnassociateEntity:(NSManagedObjectContext *) context{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User_Prop" inManagedObjectContext:context];
    User_Prop *unassociatedEntity = [[User_Prop alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    return unassociatedEntity;
}

+(User_Prop *) removeAssociateForEntity:(User_Prop *)associatedEntity withContext:(NSManagedObjectContext *) context{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User_Prop" inManagedObjectContext:context];
    User_Prop *unassociatedEntity = [[User_Prop alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    for (NSString *attr in [[entity attributesByName] allKeys]) {
        [unassociatedEntity setValue:[associatedEntity valueForKey:attr] forKey:attr];
    }
    return unassociatedEntity;
}

-(void)initWithDictionary:(NSDictionary *)dict{
    self.userId = [RORDBCommon getNumberFromId:[dict valueForKey:@"userId"]];
    self.productId = [RORDBCommon getNumberFromId:[dict valueForKey:@"productId"]];
    self.productName= [RORDBCommon getStringFromId:[dict valueForKey:@"productName"]];
    self.ownNumber = [RORDBCommon getNumberFromId:[dict valueForKey:@"ownNumber"]];
    self.updateTime = [RORDBCommon getDateFromId:[dict valueForKey:@"updateTime"]];
}

-(NSMutableDictionary *)transToDictionary{
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    [tempDict setValue:self.userId forKey:@"userId"];
    [tempDict setValue:self.productId forKey:@"productId"];
    [tempDict setValue:self.productName forKey:@"productName"];
    [tempDict setValue:self.ownNumber forKey:@"ownNumber"];
    return tempDict;
}


@end
