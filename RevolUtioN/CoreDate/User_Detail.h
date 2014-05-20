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
@property (nonatomic, retain) NSString * userTitlePic;
@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) NSNumber * experience;
@property (nonatomic, retain) NSNumber * goldCoin;
@property (nonatomic, retain) NSNumber * fatness;
@property (nonatomic, retain) NSNumber * power;
@property (nonatomic, retain) NSNumber * powerPlus;
@property (nonatomic, retain) NSNumber * fight;
@property (nonatomic, retain) NSNumber * fightPlus;
@property (nonatomic, retain) NSNumber * totalActiveTimes;
@property (nonatomic, retain) NSNumber * totalCarlorie;
@property (nonatomic, retain) NSNumber * totalDistance;
@property (nonatomic, retain) NSNumber * totalSteps;
@property (nonatomic, retain) NSNumber * totalWalkingTimes;
@property (nonatomic, retain) NSNumber * totalFights;
@property (nonatomic, retain) NSNumber * fightsWin;
@property (nonatomic, retain) NSNumber * totalFriendFights;
@property (nonatomic, retain) NSNumber * friendFightWin;
@property (nonatomic, retain) NSNumber * missionCombo;
@property (nonatomic, retain) NSString * propHaving;
@property (nonatomic, retain) NSDate * updateTime;

+(User_Detail *) removeAssociateForEntity:(User_Detail *)associatedEntity withContext:(NSManagedObjectContext *) context;

-(void)initWithDictionary:(NSDictionary *)dict;

-(NSMutableDictionary *)transToDictionary;

@end
