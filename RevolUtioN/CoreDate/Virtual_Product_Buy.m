//
//  Virtual_Product_Buy.m
//  WalkFun
//
//  Created by leon on 14-2-25.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "Virtual_Product_Buy.h"
#import "RORDBCommon.h"

@implementation Virtual_Product_Buy

@synthesize userId;
@synthesize productId;
@synthesize numbers;
@synthesize buyTime;

-(NSMutableDictionary *)transToDictionary{
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    [tempDict setValue:self.userId forKey:@"userId"];
    [tempDict setValue:self.productId forKey:@"productId"];
    [tempDict setValue:self.numbers forKey:@"numbers"];
//    [tempDict setValue:self.buyTime forKey:@"buyTime"];
    return tempDict;
}

@end
