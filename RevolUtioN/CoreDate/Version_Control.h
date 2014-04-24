//
//  Version_Control.h
//  RevolUtioN
//
//  Created by leon on 13-8-28.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Version_Control : NSObject

@property (nonatomic, retain) NSString * decs;
@property (nonatomic, retain) NSString * platform;
@property (nonatomic, retain) NSNumber * subVersion;
@property (nonatomic, retain) NSDate * systemTime;
@property (nonatomic, retain) NSNumber * version;
@property (nonatomic, retain) NSNumber * descVersion;
@property (nonatomic, retain) NSDate * missionLastUpdateTime;
@property (nonatomic, retain) NSDate * fightDefineUpdateTime;
@property (nonatomic, retain) NSDate *recommendLastUpdateTime;
@property (nonatomic, retain) NSDate *productLastUpdateTime;
@property (nonatomic, retain) NSDate *actionDefineUpdateTime;


-(void)initWithDictionary:(NSDictionary *)dict;
@end
