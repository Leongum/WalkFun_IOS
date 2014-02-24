//
//  Reward_Details.h
//  WalkFun
//
//  Created by leon on 14-2-24.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Reward_Details : NSObject

@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSNumber * actionId;
@property (nonatomic, retain) NSNumber * rewardMoney;
@property (nonatomic, retain) NSNumber *rewardPropId;

-(void)initWithDictionary:(NSDictionary *)dict;

@end