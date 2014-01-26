//
//  RORHttpResponse.m
//  RevolUtioN
//
//  Created by leon on 13-7-14.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORHttpResponse.h"

@implementation RORHttpResponse

@synthesize responseStatus;
@synthesize errorCode;
@synthesize errorMessage;
@synthesize responseData;

-(void)initWithDictionary:(NSDictionary *)dict{
    self.responseStatus = [[dict valueForKey:@"responseStatus"] intValue];
    self.errorCode = [dict valueForKey:@"errorCode"];
    self.errorMessage = [dict valueForKey:@"errorMessage"];
    self.responseData =[dict valueForKey:@"responseData"];
}

@end
