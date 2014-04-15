//
//  Virtual_Product.h
//  WalkFun
//
//  Created by leon on 14-2-14.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "StrokeLabel.h"

@interface Virtual_Product : NSManagedObject

@property (nonatomic, retain) NSDate * updateTime;
@property (nonatomic, retain) NSNumber * propFlag;
@property (nonatomic, retain) NSNumber * virtualPrice;
@property (nonatomic, retain) NSString * productDescription;
@property (nonatomic, retain) NSString * productName;
@property (nonatomic, retain) NSNumber * productId;
@property (nonatomic, retain) NSString *picLink;
@property (nonatomic, retain) NSString *effectiveRule;
@property (nonatomic, retain) NSString *dropPicList;
@property (nonatomic, retain) NSNumber * minLevelLimit;
@property (nonatomic, retain) NSNumber * maxLevelLimit;
@property (nonatomic, retain) NSNumber *maxDropNum;

+(Virtual_Product *) removeAssociateForEntity:(Virtual_Product *)associatedEntity;

-(void)initWithDictionary:(NSDictionary *)dict;

@end
