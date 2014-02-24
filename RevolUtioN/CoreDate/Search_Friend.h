//
//  Search_Friend.h
//  WalkFun
//
//  Created by leon on 14-1-25.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Search_Friend : NSObject

@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSString * nickName;
@property (nonatomic, retain) NSString * sex;
@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) NSString * userTitle;
@property (nonatomic, retain) NSString * userTitlePic;
@property (nonatomic, retain) NSDate * lastActiveTime;

-(void)initWithDictionary:(NSDictionary *)dict;

@end
