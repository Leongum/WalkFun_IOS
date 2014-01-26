//
//  User_Detail.h
//  WalkFun
//
//  Created by leon on 14-1-25.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User_Detail : NSManagedObject

@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSNumber * picId;
@property (nonatomic, retain) NSString * userTitle;
@property (nonatomic, retain) NSNumber * userTitleId;
@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) NSNumber * experience;
@property (nonatomic, retain) NSNumber * scores;
@property (nonatomic, retain) NSNumber * totalActiveTimes;
@property (nonatomic, retain) NSNumber * totalCarlorie;
@property (nonatomic, retain) NSNumber * totalDistance;
@property (nonatomic, retain) NSNumber * totalSteps;
@property (nonatomic, retain) NSNumber * totalWalkingTimes;
@property (nonatomic, retain) NSNumber * avgSpeed;
@property (nonatomic, retain) NSDate * lastActiveTime;
@property (nonatomic, retain) NSString * lastWalkingAddress;
@property (nonatomic, retain) NSNumber * lastWalkingDistance;
@property (nonatomic, retain) NSString * lastWalkingPoint;
@property (nonatomic, retain) NSNumber * lastWalkingSteps;
@property (nonatomic, retain) NSNumber * lastWalkingTime;
@property (nonatomic, retain) NSNumber * maxCombo;
@property (nonatomic, retain) NSNumber * currentCombo;
@property (nonatomic, retain) NSDate * updateTime;

+(User_Detail *) removeAssociateForEntity:(User_Detail *)associatedEntity;

-(void)initWithDictionary:(NSDictionary *)dict;

-(NSMutableDictionary *)transToDictionary;

@end
