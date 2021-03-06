//
//  Friend.h
//  RevolUtioN
//
//  Created by leon on 13-8-28.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Friend : NSManagedObject

@property (nonatomic, retain) NSDate * addTime;
@property (nonatomic, retain) NSNumber * friendId;
@property (nonatomic, retain) NSNumber * friendStatus;
@property (nonatomic, retain) NSNumber * friendEach;
@property (nonatomic, retain) NSDate * updateTime;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSDate * lastWalkTime;

@property (nonatomic, retain) NSString * sex;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) NSString * userTitle;
@property (nonatomic, retain) NSNumber * fight;
@property (nonatomic, retain) NSNumber * fightPlus;
@property (nonatomic, retain) NSNumber * power;
@property (nonatomic, retain) NSNumber * powerPlus;
@property (nonatomic, retain) NSNumber * totalFights;
@property (nonatomic, retain) NSNumber * fightsWin;
@property (nonatomic, retain) NSNumber * totalFriendFights;
@property (nonatomic, retain) NSNumber * friendFightWin;


+(Friend *) removeAssociateForEntity:(Friend *)associatedEntity withContext:(NSManagedObjectContext *) context;

-(void)initWithDictionary:(NSDictionary *)dict;

-(NSMutableDictionary *)transToDictionary;

+(Friend *) intiUnassociateEntity:(NSManagedObjectContext *) context;
@end
