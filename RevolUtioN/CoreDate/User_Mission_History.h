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
@property (nonatomic, retain) NSString * missionName;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSDate * lastRunTime;
@property (nonatomic, retain) NSNumber * historyStatus;
@property (nonatomic, retain) NSNumber * totalActiveTimes;
@property (nonatomic, retain) NSNumber * currentCombo;
@property (nonatomic, retain) NSDate * updateTime;
@property (nonatomic, retain) NSNumber * operate;

+(User_Mission_History *) intiUnassociateEntity;

+(User_Mission_History *) removeAssociateForEntity:(User_Mission_History *)associatedEntity;

-(void)initWithDictionary:(NSDictionary *)dict;

-(NSMutableDictionary *)transToDictionary;

@end
