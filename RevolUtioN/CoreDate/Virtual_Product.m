//
//  Virtual_Product.m
//  WalkFun
//
//  Created by leon on 14-2-14.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "Virtual_Product.h"
#import "RORDBCommon.h"

@implementation Virtual_Product

@dynamic updateTime;
@dynamic dropFlag;
@dynamic virtualPrice;
@dynamic productDescription;
@dynamic productName;
@dynamic productId;


+(Virtual_Product *) removeAssociateForEntity:(Virtual_Product *)associatedEntity{
    NSManagedObjectContext *context = [RORContextUtils getShareContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Virtual_Product" inManagedObjectContext:context];
    Virtual_Product *unassociatedEntity = [[Virtual_Product alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    for (NSString *attr in [[entity attributesByName] allKeys]) {
        [unassociatedEntity setValue:[associatedEntity valueForKey:attr] forKey:attr];
    }
    return unassociatedEntity;
}

-(void)initWithDictionary:(NSDictionary *)dict{
    self.productId = [RORDBCommon getNumberFromId:[dict valueForKey:@"productId"]];
    self.productName = [RORDBCommon getStringFromId:[dict valueForKey:@"productName"]];
    self.productDescription = [RORDBCommon getStringFromId:[dict valueForKey:@"productDescription"]];
    self.virtualPrice = [RORDBCommon getNumberFromId:[dict valueForKey:@"virtualPrice"]];
    self.dropFlag = [RORDBCommon getNumberFromId:[dict valueForKey:@"dropFlag"]];
    self.updateTime = [RORDBCommon getDateFromId:[dict valueForKey:@"updateTime"]];
}

@end
