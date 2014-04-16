//
//  Search_Friend.h
//  WalkFun
//
//  Created by leon on 14-1-25.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Search_Friend : NSObject

@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSString * nickName;
@property (nonatomic, retain) NSString * sex;
@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) NSNumber * fatness;
@property (nonatomic, retain) NSNumber * power;
@property (nonatomic, retain) NSNumber * fight;
@property (nonatomic, retain) NSNumber * totalFights;
@property (nonatomic, retain) NSNumber * fightsWin;
@property (nonatomic, retain) NSNumber * totalFriendFights;
@property (nonatomic, retain) NSNumber * friendFightWin;

-(void)initWithDictionary:(NSDictionary *)dict;

@end
