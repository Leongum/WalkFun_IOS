//
//  User_Prop.h
//  WalkFun
//
//  Created by leon on 14-2-14.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User_Prop : NSManagedObject

@property (nonatomic, retain) NSNumber * ownNumber;
@property (nonatomic, retain) NSString * productName;
@property (nonatomic, retain) NSNumber * productId;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSDate * updateTime;

+(User_Prop *) intiUnassociateEntity;

+(User_Prop *) removeAssociateForEntity:(User_Prop *)associatedEntity;

-(void)initWithDictionary:(NSDictionary *)dict;

-(NSMutableDictionary *)transToDictionary;

@end
