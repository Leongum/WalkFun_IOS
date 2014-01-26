//
//  RORDBCommon.m
//  RevolUtioN
//
//  Created by Beyond on 13-6-24.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORDBCommon.h"
#import <CoreLocation/CoreLocation.h>

@implementation RORDBCommon

+ (BOOL) isEmpty:(id)obj {
    if (obj == nil || [obj isKindOfClass:[NSNull class]])
        return YES;
    return NO;
}

+ (NSDate *)getDateFromId:(id)obj{
    if ([self isEmpty:obj])
        return nil;
    if ([obj isKindOfClass:[NSString class]]){
        NSString *str = (NSString *)obj;
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [formatter dateFromString:str];
        return date;
    } else if([obj isKindOfClass:[NSDate class]]){
        return (NSDate *)obj;
    }
    return nil;
}

+ (NSString *)getStringFromId:(id)obj{
    if ([self isEmpty:obj])
        return nil;
    if ([obj isKindOfClass:[NSString class]])
        return (NSString *)obj;
    if ([obj isKindOfClass:[NSDate class]]){
        NSDateFormatter *formate = [[NSDateFormatter alloc] init];
        [formate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        return [formate stringFromDate:obj];
    }
    return [NSString stringWithFormat:@"%@", obj];
}

+ (NSNumber *)getNumberFromId:(id)obj{
    if ([self isEmpty:obj])
        return nil;
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    if ([obj isKindOfClass:[NSString class]]){
        NSString *str = (NSString *) obj;
        NSNumber *result = [f numberFromString:str];
        if(!(result))
            return nil;
        return result;
    } else if ([obj isKindOfClass:[NSNumber class]]){
        return (NSNumber *)obj;
    }
    return nil;
}

+ (NSString *)getStringFromRoutes:(NSArray *)routes{
    NSMutableString *route_str = [[NSMutableString alloc] init];

    for (NSArray *routePoints in routes) {
        for (int i=0; i<routePoints.count; i++){
            CLLocation *loc_i = [routePoints objectAtIndex:i];
            CLLocationCoordinate2D loc_coor = [loc_i coordinate];
            [route_str appendString:[NSString stringWithFormat:@"%f,%f ",loc_coor.latitude, loc_coor.longitude]];
        }
        [route_str appendString:@"|"];
    }
    
    return route_str;
}

+ (NSArray *)getRoutesFromString:(NSString *)route_str{
    NSMutableArray *routes = [[NSMutableArray alloc]init];
    NSArray *route_str_array = [route_str componentsSeparatedByString:@"|"];
    for (NSString *routePoints_str in route_str_array) {
        NSArray *pairs = [routePoints_str componentsSeparatedByString:@" "];
        NSMutableArray *routePoints = [[NSMutableArray alloc] init];
        for (int i=0; i<pairs.count-1; i++){
            NSString *thisString = (NSString *)[pairs objectAtIndex:i];
            NSArray *pair = [thisString componentsSeparatedByString:@","];
            float latitude = [[self getNumberFromId:pair[0]] floatValue];
            float longitude = [[self getNumberFromId:pair[1]] floatValue];
            CLLocation *loc = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
            [routePoints addObject:loc];
        }
        [routes addObject:routePoints];
    }
    return routes;
}

+ (NSString *)getStringFromSpeedList:(NSArray *)speedList{
    NSMutableString *speedListString = [[NSMutableString alloc]init];
    for (int i=0; i<speedList.count; i++){
        NSNumber *spdNum = [speedList objectAtIndex:i];
        [speedListString appendString:[NSString stringWithFormat:@"%.2f,", spdNum.doubleValue]];
    }
    return speedListString;
}

+ (NSMutableArray *)getSpeedListFromString:(NSString *)speedListString{
    NSMutableArray *speedList = [[NSMutableArray alloc]init];
    NSArray *speedStrList = [speedListString componentsSeparatedByString:@","];
    for (int i=0; i<speedStrList.count; i++){
        NSString *thisString = (NSString *)[speedStrList objectAtIndex:i];
        NSNumber *thisNumber = [self getNumberFromId:thisString];
        if (thisNumber)
            [speedList addObject:thisNumber];
    }
    return speedList;
}

@end
