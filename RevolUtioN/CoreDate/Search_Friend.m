//
//  Search_Friend.m
//  WalkFun
//
//  Created by leon on 14-1-25.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "Search_Friend.h"
#import "RORDBCommon.h"

@implementation Search_Friend

@synthesize userId;
@synthesize nickName;
@synthesize sex;
@synthesize level;
@synthesize power;
@synthesize fatness;
@synthesize fight;
@synthesize totalFights;
@synthesize fightsWin;
@synthesize totalFriendFights;
@synthesize friendFightWin;

-(void)initWithDictionary:(NSDictionary *)dict{
    self.userId = [RORDBCommon getNumberFromId:[dict valueForKey:@"userId"]];
    self.nickName = [RORDBCommon getStringFromId:[dict valueForKey:@"nickName"]];
    self.sex = [RORDBCommon getStringFromId:[dict valueForKey:@"sex"]];
    self.level = [RORDBCommon getNumberFromId:[dict valueForKey:@"level"]];
    self.power = [RORDBCommon getNumberFromId:[dict valueForKey:@"power"]];
    self.fatness = [RORDBCommon getNumberFromId:[dict valueForKey:@"fatness"]];
    self.fight = [RORDBCommon getNumberFromId:[dict valueForKey:@"fight"]];
    self.totalFights = [RORDBCommon getNumberFromId:[dict valueForKey:@"totalFights"]];
    self.fightsWin = [RORDBCommon getNumberFromId:[dict valueForKey:@"fightsWin"]];
    self.totalFriendFights = [RORDBCommon getNumberFromId:[dict valueForKey:@"totalFriendFights"]];
    self.friendFightWin = [RORDBCommon getNumberFromId:[dict valueForKey:@"friendFightWin"]];
}

@end
