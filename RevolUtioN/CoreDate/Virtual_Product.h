//
//  Virtual_Product.h
//  WalkFun
//
//  Created by leon on 14-2-14.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Virtual_Product : NSManagedObject

@property (nonatomic, retain) NSDate * updateTime;
@property (nonatomic, retain) NSNumber * dropFlag;
@property (nonatomic, retain) NSNumber * virtualPrice;
@property (nonatomic, retain) NSString * productDescription;
@property (nonatomic, retain) NSString * productName;
@property (nonatomic, retain) NSNumber * productId;
@property (nonatomic, retain) NSString *picLink;

+(Virtual_Product *) removeAssociateForEntity:(Virtual_Product *)associatedEntity;

-(void)initWithDictionary:(NSDictionary *)dict;

@end