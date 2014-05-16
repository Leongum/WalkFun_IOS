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

@property (retain) NSNumber * fightId;
@property (retain) NSNumber * inUsing;
@property (retain) NSString * fightName;
@property (retain) NSNumber * minLevelLimit;
@property (retain) NSNumber * maxLevelLimit;
@property (retain) NSString * monsterName;
@property (retain) NSNumber * monsterLevel;
@property (retain) NSNumber * monsterMaxFight;
@property (retain) NSNumber * monsterMinFight;
@property (retain) NSNumber * basePowerConsume;
@property (retain) NSNumber * baseExperience;
@property (retain) NSNumber * baseGold;
@property (retain) NSString * fightWin;
@property (retain) NSString * winGot;
@property (retain) NSString * winGotRule;
@property (retain) NSString * fightLoose;
@property (retain) NSNumber * triggerProbability;
@property (retain) NSDate * updateTime;

+(Fight_Define *) removeAssociateForEntity:(Fight_Define *)associatedEntity;

-(void)initWithDictionary:(NSDictionary *)dict;

@end
