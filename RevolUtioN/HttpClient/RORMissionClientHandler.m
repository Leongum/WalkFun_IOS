//
//  RORMissionClientHandler.m
//  RevolUtioN
//
//  Created by leon on 13-7-22.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORMissionClientHandler.h"

@implementation RORMissionClientHandler

+(RORHttpResponse *)getMissions:(NSString *) lastUpdateTime{
    NSString *url = [NSString stringWithFormat:MISSION_GET_URL, lastUpdateTime];
    RORHttpResponse *httpResponse = [RORHttpClientHandler getRequest:url];
    return httpResponse;
}

+(RORHttpResponse *)getDailyMission:(NSNumber *) userId{
    NSString *url = [NSString stringWithFormat:MISSION_DAILY_GET_URL, userId];
    RORHttpResponse *httpResponse = [RORHttpClientHandler getRequest:url];
    return httpResponse;
}

@end
