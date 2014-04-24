//
//  Version_Control.m
//  RevolUtioN
//
//  Created by leon on 13-8-28.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "Version_Control.h"
#import "RORDBCommon.h"


@implementation Version_Control

@synthesize decs;
@synthesize platform;
@synthesize subVersion;
@synthesize systemTime;
@synthesize version;
@synthesize descVersion;
@synthesize missionLastUpdateTime;
@synthesize fightDefineUpdateTime;
@synthesize recommendLastUpdateTime;
@synthesize productLastUpdateTime;
@synthesize actionDefineUpdateTime;

-(void)initWithDictionary:(NSDictionary *)dict{
    self.platform = [RORDBCommon getStringFromId:[dict valueForKey:@"platform"]];
    self.version = [RORDBCommon getNumberFromId:[dict valueForKey:@"version"]];
    self.subVersion = [RORDBCommon getNumberFromId:[dict valueForKey:@"subVersion"]];
    self.descVersion = [RORDBCommon getNumberFromId:[dict valueForKey:@"descVersion"]];
    self.decs = [RORDBCommon getStringFromId:[dict valueForKey:@"description"]];
    self.systemTime = [RORDBCommon getDateFromId:[dict valueForKey:@"systemTime"]];
    self.missionLastUpdateTime = [RORDBCommon getDateFromId:[dict valueForKey:@"missionLastUpdateTime"]];
    self.fightDefineUpdateTime = [RORDBCommon getDateFromId:[dict valueForKey:@"fightDefineUpdateTime"]];
    self.recommendLastUpdateTime = [RORDBCommon getDateFromId:[dict valueForKey:@"recommendLastUpdateTime"]];
    self.productLastUpdateTime = [RORDBCommon getDateFromId:[dict valueForKey:@"productLastUpdateTime"]];
    self.actionDefineUpdateTime = [RORDBCommon getDateFromId:[dict valueForKey:@"actionDefineUpdateTime"]];
}

@end
