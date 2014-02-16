//
//  RORRunHistoryClientHandler.m
//  RevolUtioN
//
//  Created by leon on 13-7-22.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORRunHistoryClientHandler.h"

@implementation RORRunHistoryClientHandler

+(RORHttpResponse *)createRunHistories:(NSNumber *) userId withRunHistories:(NSMutableArray *) runHistories{
    NSString *requestUrl = [NSString stringWithFormat:HISTORY_POST_RUNNING_HISTORY_URL, userId];
    RORHttpResponse *httpResponse = [RORHttpClientHandler postRequest:requestUrl withRequstBody:[RORUtils toJsonFormObject:runHistories]];
    return httpResponse;
}

+(RORHttpResponse *)getRunHistories:(NSNumber *)userId withLastUpdateTime:(NSString *) lastUpdateTime{
    NSString *url = [NSString stringWithFormat:HISTORY_GET_RUNNING_HISTORY_URL, userId, lastUpdateTime];
    RORHttpResponse *httpResponse = [RORHttpClientHandler getRequest:url];
    return httpResponse;
}

+(RORHttpResponse *)getSimpleRunHistories:(NSNumber *)userId{
    NSString *url = [NSString stringWithFormat:HISTORY_GET_SIMPLE_RUNNING_HISTORY_URL, userId];
    RORHttpResponse *httpResponse = [RORHttpClientHandler getRequest:url];
    return httpResponse;
}

+(RORHttpResponse *)getMissionHistories:(NSNumber *)userId withLastUpdateTime:(NSString *) lastUpdateTime{
    NSString *url = [NSString stringWithFormat:HISTORY_GET_MISSION_HISTORY_URL, userId, lastUpdateTime];
    RORHttpResponse *httpResponse = [RORHttpClientHandler getRequest:url];
    return httpResponse;
}

+(RORHttpResponse *)getUsingMissionHistories:(NSNumber *)userId{
    NSString *url = [NSString stringWithFormat:HISTORY_GET_USER_USING_MISSION_URL, userId];
    RORHttpResponse *httpResponse = [RORHttpClientHandler getRequest:url];
    return httpResponse;
}

+(RORHttpResponse *)createMissionHistories:(NSNumber *)userId withMissionHistories:(NSMutableArray *) missionHistories{
    NSString *requestUrl = [NSString stringWithFormat:HISTORY_POST_MISSION_HISTORY_URL, userId];
    RORHttpResponse *httpResponse = [RORHttpClientHandler postRequest:requestUrl withRequstBody:[RORUtils toJsonFormObject:missionHistories]];
    return httpResponse;
}
@end