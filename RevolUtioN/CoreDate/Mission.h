//
//  Mission.h
//  RevolUtioN
//
//  Created by leon on 13-8-28.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Mission : NSManagedObject

@property (nonatomic, retain) NSNumber * missionId;
@property (nonatomic, retain) NSNumber * missionTypeId;
@property (nonatomic, retain) NSString * missionName;
@property (nonatomic, retain) NSString * missionRule;
@property (nonatomic, retain) NSString * missionDescription;
@property (nonatomic, retain) NSNumber * triggerSteps;
@property (nonatomic, retain) NSNumber * triggerTimes;
@property (nonatomic, retain) NSNumber * triggerDistances;
@property (nonatomic, retain) NSNumber * triggerActionId;
@property (nonatomic, retain) NSNumber * triggerFightId;
@property (nonatomic, retain) NSNumber * triggerNumbers;
@property (nonatomic, retain) NSNumber * goldCoin;
@property (nonatomic, retain) NSNumber * experience;
@property (nonatomic, retain) NSNumber * minLevelLimit;
@property (nonatomic, retain) NSNumber * maxLevelLimit;
@property (nonatomic, retain) NSDate * updateTime;

+(Mission *) removeAssociateForEntity:(Mission *)associatedEntity;

-(void)initWithDictionary:(NSDictionary *)dict;
@end
