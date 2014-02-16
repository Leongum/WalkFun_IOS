//
//  RORSystemClientHandler.h
//  RevolUtioN
//
//  Created by leon on 13-8-10.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RORConstant.h"
#import "RORUserUtils.h"
#import "RORHttpClientHandler.h"
#import "RORHttpResponse.h"

@interface RORSystemClientHandler : NSObject

+(RORHttpResponse *)getVersionInfo:(NSString *) platform;

+(RORHttpResponse *)getSystemMessage:(NSString *) lastUpdateTime;

+(RORHttpResponse *)getRecommendApp:(NSString *) lastUpdateTime;

+(RORHttpResponse *)getActionDefine:(NSString *) lastUpdateTime;
@end
