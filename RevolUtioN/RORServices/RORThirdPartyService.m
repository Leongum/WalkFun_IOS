//
//  RORThirdPartyService.m
//  RevolUtioN
//
//  Created by leon on 13-8-7.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORThirdPartyService.h"

@implementation RORThirdPartyService

+(NSDictionary *)syncWeatherInfo:(NSString *)cityCode{
    if(cityCode == nil) return nil;
    NSError *error = nil;
    NSDictionary *weatherInfo = nil;
    RORHttpResponse *httpResponse = [RORThirdPartyClientHandler getWeatherInfo:cityCode];
    
    if ([httpResponse responseStatus] == 200){
        NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
        //    weatherDic字典中存放的数据也是字典型，从它里面通过键值取值
        weatherInfo = [weatherDic objectForKey:@"weatherinfo"];
    }
    return weatherInfo;
}

+(NSDictionary *)syncPM25Info:(NSString *)city withProvince:(NSString *)province{
     if(city == nil || province == nil) return nil;
    NSError *error = nil;
    NSDictionary *pm25Info = nil;
    RORHttpResponse *httpResponse = [RORThirdPartyClientHandler getPM25Info:city withProvince:province];
    
    if ([httpResponse responseStatus] == 200){
        pm25Info = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingAllowFragments error:&error];
    }
    return pm25Info;
}

@end
