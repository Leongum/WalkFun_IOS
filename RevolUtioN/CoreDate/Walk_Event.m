//
//  Walk_Event.m
//  WalkFun
//
//  Created by leon on 14-3-21.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "Walk_Event.h"
#import "RORDBCommon.h"

@implementation Walk_Event

@dynamic eType;
@dynamic eId;
@dynamic eWin;
@dynamic times;
@dynamic lati;
@dynamic longi;
@dynamic power;

-(void)initWithDictionary:(NSDictionary *)dict{
    self.eType = [RORDBCommon getStringFromId:[dict valueForKey:@"eType"]];
    self.eId = [RORDBCommon getNumberFromId:[dict valueForKey:@"eId"]];
    self.eWin = [RORDBCommon getNumberFromId:[dict valueForKey:@"eWin"]];
    self.times = [RORDBCommon getNumberFromId:[dict valueForKey:@"times"]];
    self.lati = [RORDBCommon getNumberFromId:[dict valueForKey:@"lati"]];
    self.longi = [RORDBCommon getNumberFromId:[dict valueForKey:@"longi"]];
    self.power = [RORDBCommon getNumberFromId:[dict valueForKey:@"power"]];
}

@end
