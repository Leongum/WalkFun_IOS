//
//  RORVirtualProductClientHandler.m
//  WalkFun
//
//  Created by leon on 14-2-16.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "RORVirtualProductClientHandler.h"

@implementation RORVirtualProductClientHandler

+(RORHttpResponse *)getVirtualProducts:(NSString *) lastUpdateTime{
    NSString *url = [NSString stringWithFormat:VIRTUAL_PRODUCT_GET_URL,lastUpdateTime];
    RORHttpResponse *httpResponse = [RORHttpClientHandler getRequest:url];
    return httpResponse;
}

+(RORHttpResponse *)createVProductBuyInfo:(NSNumber *)userId withBuyInfo:(NSDictionary *) buyInfo{
    NSString *requestUrl = [NSString stringWithFormat:VIRTUAL_PRODUCT_BUY_URL, userId];
    RORHttpResponse *httpResponse = [RORHttpClientHandler postRequest:requestUrl withRequstBody:[RORUtils toJsonFormObject:buyInfo]];
    return httpResponse;
}
@end
