//
//  RORRunHistoryClientHandler.h
//  RevolUtioN
//
//  Created by leon on 13-7-22.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RORConstant.h"
#import "RORUtils.h"
#import "RORHttpClientHandler.h"
#import "RORHttpResponse.h"

@interface RORRunHistoryClientHandler : NSObject

+(RORHttpResponse *)createRunHistories:(NSNumber *) userId withRunHistories:(NSMutableArray *) runHistories;

+(RORHttpResponse *)getRunHistories:(NSNumber *)userId withLastUpdateTime:(NSString *) lastUpdateTime;

+(RORHttpResponse *)getSimpleRunHistories:(NSNumber *)userId;

+(RORHttpResponse *)getMissionHistories:(NSNumber *)userId withLastUpdateTime:(NSString *) lastUpdateTime;

+(RORHttpResponse *)getUsingMissionHistories:(NSNumber *)userId;

+(RORHttpResponse *)createMissionHistories:(NSNumber *)userId withMissionHistories:(NSMutableArray *) missionHistories;

@end

