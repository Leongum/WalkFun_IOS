//
//  RORMissionClientHandler.h
//  RevolUtioN
//
//  Created by leon on 13-7-22.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RORConstant.h"
#import "RORUserUtils.h"
#import "RORHttpClientHandler.h"
#import "RORHttpResponse.h"

@interface RORMissionClientHandler : NSObject

+(RORHttpResponse *)getMissions:(NSString *) lastUpdateTime;

@end
