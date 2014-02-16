//
//  Simple_User_Run_History.h
//  WalkFun
//
//  Created by leon on 14-2-14.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Simple_User_Run_History : NSObject

@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSNumber * spendCarlorie;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSNumber * avgSpeed;
@property (nonatomic, retain) NSNumber * steps;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSNumber * missionGrade;
@property (nonatomic, retain) NSString * propGet;
@property (nonatomic, retain) NSDate * missionEndTime;

-(void)initWithDictionary:(NSDictionary *)dict;

@end
