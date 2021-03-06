//
//  User_Running_History.h
//  RevolUtioN
//
//  Created by leon on 13-8-28.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface User_Running_History : NSManagedObject

@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSString * runUuid;
@property (nonatomic, retain) NSNumber * missionId;
@property (nonatomic, retain) NSNumber * missionTypeId;
@property (nonatomic, retain) NSString * missionRoute;
@property (nonatomic, retain) NSDate * missionStartTime;
@property (nonatomic, retain) NSDate * missionEndTime;
@property (nonatomic, retain) NSDate * missionDate;
@property (nonatomic, retain) NSNumber * spendCarlorie;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSNumber * avgSpeed;
@property (nonatomic, retain) NSNumber * steps;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSNumber * missionGrade;
@property (nonatomic, retain) NSNumber * goldCoin;
@property (nonatomic, retain) NSNumber * extraGoldCoin;
@property (nonatomic, retain) NSNumber * experience;
@property (nonatomic, retain) NSNumber * extraExperience;
@property (nonatomic, retain) NSNumber * fatness;
@property (nonatomic, retain) NSNumber * health;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSNumber * valid;
@property (nonatomic, retain) NSString * missionUuid;
@property (nonatomic, retain) NSNumber * sequence;
@property (nonatomic, retain) NSString * propGet;
@property (nonatomic, retain) NSString * actionIds;
@property (nonatomic, retain) NSDate * commitTime;
@property (nonatomic, retain) NSNumber * friendId;
@property (nonatomic, retain) NSString * friendName;

+(User_Running_History *) intiUnassociateEntity:(NSManagedObjectContext *) context;

+(User_Running_History *) removeAssociateForEntity:(User_Running_History *)associatedEntity withContext:(NSManagedObjectContext *) context;

-(void)copyFromUserRunningHistory:(User_Running_History *)history;

-(void)initWithDictionary:(NSDictionary *)dict;

-(NSMutableDictionary *)transToDictionary;
@end
