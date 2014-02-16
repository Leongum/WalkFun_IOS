//
//  RORVirtualProductClientHandler.h
//  WalkFun
//
//  Created by leon on 14-2-16.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RORConstant.h"
#import "RORUserUtils.h"
#import "RORHttpClientHandler.h"
#import "RORHttpResponse.h"

@interface RORVirtualProductClientHandler : NSObject

+(RORHttpResponse *)getVirtualProducts:(NSString *) lastUpdateTime;

+(RORHttpResponse *)createVProductBuyInfo:(NSNumber *)userId withBuyInfo:(NSDictionary *) buyInfo;
@end
