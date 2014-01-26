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
@synthesize userTitle;
@synthesize lastActiveTime;

-(void)initWithDictionary:(NSDictionary *)dict{
    self.userId = [RORDBCommon getNumberFromId:[dict valueForKey:@"userId"]];
    self.nickName = [RORDBCommon getStringFromId:[dict valueForKey:@"nickName"]];
    self.sex = [RORDBCommon getStringFromId:[dict valueForKey:@"sex"]];
    self.level = [RORDBCommon getNumberFromId:[dict valueForKey:@"level"]];
    self.userTitle = [RORDBCommon getStringFromId:[dict valueForKey:@"userTitle"]];
    self.lastActiveTime = [RORDBCommon getDateFromId:[dict valueForKey:@"lastActiveTime"]];
}

@end
