//
//  Simple_User_Run_History.m
//  WalkFun
//
//  Created by leon on 14-2-14.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "Simple_User_Run_History.h"
#import "RORDBCommon.h"

@implementation Simple_User_Run_History

@synthesize userId;
@synthesize spendCarlorie;
@synthesize duration;
@synthesize avgSpeed;
@synthesize steps;
@synthesize distance;
@synthesize missionGrade;
@synthesize propGet;
@synthesize missionEndTime;

-(void)initWithDictionary:(NSDictionary *)dict{
    self.avgSpeed = [RORDBCommon getNumberFromId:[dict valueForKey:@"avgSpeed"]];
    self.distance = [RORDBCommon getNumberFromId:[dict valueForKey:@"distance"]];
    self.userId = [RORDBCommon getNumberFromId:[dict valueForKey:@"userId"]];
    self.missionEndTime = [RORDBCommon getDateFromId:[dict valueForKey:@"missionEndTime"]];
    self.spendCarlorie = [RORDBCommon getNumberFromId:[dict valueForKey:@"spendCarlorie"]];
    self.duration = [RORDBCommon getNumberFromId:[dict valueForKey:@"duration"]];
    self.missionGrade = [RORDBCommon getNumberFromId:[dict valueForKey:@"missionGrade"]];
    self.steps = [RORDBCommon getNumberFromId:[dict valueForKey:@"steps"]];
    self.propGet = [RORDBCommon getStringFromId:[dict valueForKey:@"propGet"]];
}

@end
