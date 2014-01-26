//
//  RORHttpResponse.h
//  RevolUtioN
//
//  Created by leon on 13-7-14.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RORHttpResponse : NSObject

@property (nonatomic) NSInteger responseStatus;
@property (nonatomic, retain) NSString * errorCode;
@property (nonatomic, retain) NSString * errorMessage;
@property (nonatomic, retain) NSData * responseData;

-(void)initWithDictionary:(NSDictionary *)dict;

@end
