//
//  RORThirdPartyClientHandler.h
//  RevolUtioN
//
//  Created by leon on 13-8-7.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RORConstant.h"
#import "RORUtils.h"
#import "RORHttpClientHandler.h"
#import "RORHttpResponse.h"

@interface RORThirdPartyClientHandler : NSObject

+(RORHttpResponse *)getWeatherInfo:(NSString *)citycode;

+(RORHttpResponse *)getPM25Info:(NSString *)city withProvince:(NSString *) province;

@end
