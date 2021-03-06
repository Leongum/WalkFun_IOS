//
//  User_Mission_History.h
//  WalkFun
//
//  Created by leon on 14-1-25.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User_Mission_History : NSManagedObject

@property (nonatomic, retain) NSString * missionUuid;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSNumber * missionId;
@property (nonatomic, retain) NSNumber * missionTypeId;
@property (nonatomic, retain) NSString * missionName;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSNumber * missionStatus;//0 success 1 failed
@property (nonatomic, retain) NSString * missionStatusComment;
@property (nonatomic, retain) NSDate * updateTime;

+(User_Mission_History *) intiUnassociateEntity:(NSManagedObjectContext *) context;

+(User_Mission_History *) removeAssociateForEntity:(User_Mission_History *)associatedEntity withContext:(NSManagedObjectContext *) context;

-(void)initWithDictionary:(NSDictionary *)dict;

-(NSMutableDictionary *)transToDictionary;

@end
