//
//  RORSystemClientHandler.m
//  RevolUtioN
//
//  Created by leon on 13-8-10.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORSystemClientHandler.h"

@implementation RORSystemClientHandler

+(RORHttpResponse *)getVersionInfo:(NSString *) platform{
    NSString *url = [NSString stringWithFormat:SYSTEM_VERSION_URL ,platform];
    RORHttpResponse *httpResponse = [RORHttpClientHandler getRequest:url];
    return httpResponse;
}

+(RORHttpResponse *)getRecommendApp:(NSString *) lastUpdateTime{
    NSString *url = [NSString stringWithFormat:SYSTEM_RECOMMEND_APP_URL, lastUpdateTime];
    RORHttpResponse *httpResponse = [RORHttpClientHandler getRequest:url];
    return httpResponse;
}

+(RORHttpResponse *)getActionDefine:(NSString *) lastUpdateTime{
    NSString *url = [NSString stringWithFormat:SYSTEM_ACTION_DEFINE_URL, lastUpdateTime];
    RORHttpResponse *httpResponse = [RORHttpClientHandler getRequest:url];
    return httpResponse;
}

+(RORHttpResponse *)getFightDefine:(NSString *) lastUpdateTime{
    NSString *url = [NSString stringWithFormat:SYSTEM_FIGHT_DEFINE_URL, lastUpdateTime];
    RORHttpResponse *httpResponse = [RORHttpClientHandler getRequest:url];
    return httpResponse;
}

@end
