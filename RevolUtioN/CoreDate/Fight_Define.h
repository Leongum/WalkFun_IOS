//
//  Fight_Define.h
//  WalkFun
//
//  Created by leon on 14-3-21.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Fight_Define : NSManagedObject

@property (nonatomic, retain) NSNumber * fightId;
@property (nonatomic, retain) NSNumber * inUsing;
@property (nonatomic, retain) NSString * fightName;
@property (nonatomic, retain) NSNumber * minLevelLimit;
@property (nonatomic, retain) NSNumber * maxLevelLimit;
@property (nonatomic, retain) NSString * monsterName;
@property (nonatomic, retain) NSNumber * monsterLevel;
@property (nonatomic, retain) NSNumber * monsterMaxFight;
@property (nonatomic, retain) NSNumber * monsterMinFight;
@property (nonatomic, retain) NSNumber * basePowerConsume;
@property (nonatomic, retain) NSNumber * baseExperience;
@property (nonatomic, retain) NSNumber * baseGold;
@property (nonatomic, retain) NSString * fightWin;
@property (nonatomic, retain) NSString * winGot;
@property (nonatomic, retain) NSString * winGotRule;
@property (nonatomic, retain) NSString * fightLoose;
@property (nonatomic, retain) NSNumber * triggerProbability;
@property (nonatomic, retain) NSDate * updateTime;

+(Fight_Define *) removeAssociateForEntity:(Fight_Define *)associatedEntity;

-(void)initWithDictionary:(NSDictionary *)dict;

@end
