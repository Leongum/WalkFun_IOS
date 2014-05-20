//
//  Action_Define.h
//  WalkFun
//
//  Created by leon on 14-2-16.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Action_Define : NSManagedObject

@property (nonatomic, retain) NSNumber * actionType;
@property (nonatomic, retain) NSString * actionName;
@property (nonatomic, retain) NSNumber * inUsing;
@property (nonatomic, retain) NSString * soundLink;
@property (nonatomic, retain) NSString * actionDescription;
@property (nonatomic, retain) NSString * actionAttribute;
@property (nonatomic, retain) NSString * actionRule;
@property (nonatomic, retain) NSString * effectiveRule;
@property (nonatomic, retain) NSNumber * actionId;
@property (nonatomic, retain) NSNumber * triggerProbability;
@property (nonatomic, retain) NSNumber * minLevelLimit;
@property (nonatomic, retain) NSNumber * maxLevelLimit;
@property (nonatomic, retain) NSDate * updateTime;

+(Action_Define *) removeAssociateForEntity:(Action_Define *)associatedEntity withContext:(NSManagedObjectContext *) context;

-(void)initWithDictionary:(NSDictionary *)dict;

@end
