//
//  Friend_Sort.h
//  WalkFun
//
//  Created by leon on 14-1-25.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Friend_Sort : NSManagedObject

@property (nonatomic, retain) NSNumber * friendId;
@property (nonatomic, retain) NSString * friendName;
@property (nonatomic, retain) NSString * sex;
@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) NSNumber * fatness;
@property (nonatomic, retain) NSNumber * power;
@property (nonatomic, retain) NSNumber * fight;
@property (nonatomic, retain) NSNumber * fightPlus;
@property (nonatomic, retain) NSNumber * totalFights;
@property (nonatomic, retain) NSNumber * fightsWin;
@property (nonatomic, retain) NSNumber * totalFriendFights;
@property (nonatomic, retain) NSNumber * friendFightWin;

+(Friend_Sort *) removeAssociateForEntity:(Friend_Sort *)associatedEntity;

-(void)initWithDictionary:(NSDictionary *)dict;

@end
