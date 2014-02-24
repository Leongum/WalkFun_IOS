//
//  Reward_Details.m
//  WalkFun
//
//  Created by leon on 14-2-24.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "Reward_Details.h"
#import "RORDBCommon.h"


@implementation Reward_Details

@synthesize userId;
@synthesize actionId;
@synthesize rewardMoney;
@synthesize rewardPropId;

-(void)initWithDictionary:(NSDictionary *)dict{
    self.userId = [RORDBCommon getNumberFromId:[dict valueForKey:@"userId"]];
    self.actionId = [RORDBCommon getNumberFromId:[dict valueForKey:@"actionId"]];
    self.rewardMoney = [RORDBCommon getNumberFromId:[dict valueForKey:@"rewardMoney"]];
    self.rewardPropId = [RORDBCommon getNumberFromId:[dict valueForKey:@"rewardPropId"]];
}

@end
