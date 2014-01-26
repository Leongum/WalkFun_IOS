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
@property (nonatomic, retain) NSString * missionDescription;
@property (nonatomic, retain) NSNumber * scores;
@property (nonatomic, retain) NSNumber * experience;
@property (nonatomic, retain) NSNumber * missionFlag;
@property (nonatomic, retain) NSNumber * levelLimited;
@property (nonatomic, retain) NSNumber * missionTimeLimited;
@property (nonatomic, retain) NSNumber * missionDistanceLimited;
@property (nonatomic, retain) NSNumber * missionToTimeLimited;
@property (nonatomic, retain) NSNumber * missionFromTimeLimited;
@property (nonatomic, retain) NSNumber * cycleTime;
@property (nonatomic, retain) NSNumber *suggestionMaxSpeed;
@property (nonatomic, retain) NSNumber *suggestionMinSpeed;
@property (nonatomic, retain) NSNumber * sequence;
@property (nonatomic, retain) NSDate * updateTime;

+(Mission *) removeAssociateForEntity:(Mission *)associatedEntity;

-(void)initWithDictionary:(NSDictionary *)dict;
@end
