//
//  RORHttpClientHandler.h
//  RevolUtioN
//
//  Created by leon on 13-7-9.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RORHttpResponse.h"

@interface RORHttpClientHandler : NSObject

+(RORHttpResponse *) postRequest:(NSString *)url withRequstBody:(NSString *)reqBody;

+(RORHttpResponse *) putRequest:(NSString *)url withRequstBody:(NSString *)reqBody;

+(RORHttpResponse *) getRequest: (NSString *)url;

+(RORHttpResponse *) getRequest: (NSString *)url withHeaders:(NSMutableDictionary *) headers;

@end
