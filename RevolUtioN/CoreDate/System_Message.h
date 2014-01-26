//
//  System_Message.h
//  RevolUtioN
//
//  Created by leon on 13-9-14.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface System_Message : NSManagedObject

@property (nonatomic, retain) NSDate * updateTime;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSNumber * messageId;
@property (nonatomic, retain) NSString * rule;

+(System_Message *) removeAssociateForEntity:(System_Message *)associatedEntity;

-(void)initWithDictionary:(NSDictionary *)dict;

@end
