//
//  Action.h
//  WalkFun
//
//  Created by leon on 14-1-25.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Action : NSManagedObject

@property (nonatomic, retain) NSNumber * actionFromId;
@property (nonatomic, retain) NSString * actionFromName;
@property (nonatomic, retain) NSNumber * actionToId;
@property (nonatomic, retain) NSString * actionToName;
@property (nonatomic, retain) NSNumber * actionId;
@property (nonatomic, retain) NSString * actionName;
@property (nonatomic, retain) NSDate * updateTime;

+(Action *) initUnassociateEntity:(NSManagedObjectContext *) context;

+(Action *) removeAssociateForEntity:(Action *)associatedEntity withContext:(NSManagedObjectContext *) context;

-(void)initWithDictionary:(NSDictionary *)dict;

-(NSMutableDictionary *)transToDictionary;

@end
