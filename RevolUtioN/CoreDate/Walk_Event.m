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

@synthesize eType;
@synthesize eId;
@synthesize eWin;
@synthesize times;
@synthesize lati;
@synthesize longi;
@synthesize power;

-(id)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.eType = [RORDBCommon getStringFromId:[dict valueForKey:@"eType"]];
        self.eId = [RORDBCommon getNumberFromId:[dict valueForKey:@"eId"]];
        self.eWin = [RORDBCommon getNumberFromId:[dict valueForKey:@"eWin"]];
        self.times = [RORDBCommon getNumberFromId:[dict valueForKey:@"times"]];
        self.lati = [RORDBCommon getNumberFromId:[dict valueForKey:@"lati"]];
        self.longi = [RORDBCommon getNumberFromId:[dict valueForKey:@"longi"]];
        self.power = [RORDBCommon getNumberFromId:[dict valueForKey:@"power"]];
    }
    return self;
}

-(NSMutableDictionary *)transToDictionary{
    NSMutableDictionary *tempoDict = [[NSMutableDictionary alloc] init];
    [tempoDict setValue:self.eType forKey:@"eType"];
    [tempoDict setValue:self.eId forKey:@"eId"];
    [tempoDict setValue:self.eWin forKey:@"eWin"];
    [tempoDict setValue:self.times forKey:@"times"];
    [tempoDict setValue:self.lati forKey:@"lati"];
    [tempoDict setValue:self.longi forKey:@"longi"];
    [tempoDict setValue:self.power forKey:@"power"];

    return tempoDict;
}
@end
