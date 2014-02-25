//
//  Virtual_Product_Buy.h
//  WalkFun
//
//  Created by leon on 14-2-25.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Virtual_Product_Buy : NSObject

@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSNumber * productId;
@property (nonatomic, retain) NSNumber * numbers;
@property (nonatomic, retain) NSDate * buyTime;

-(NSMutableDictionary *)transToDictionary;
@end
