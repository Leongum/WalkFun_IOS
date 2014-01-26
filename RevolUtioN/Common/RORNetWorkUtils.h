//
//  RORNetWorkUtils.h
//  RevolUtioN
//
//  Created by leon on 13-8-29.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "RORUserUtils.h"
#import "RORConstant.h"

@interface RORNetWorkUtils : NSObject

+ (BOOL) getDoUploadable;

+ (BOOL) getIsConnetioned;

+ (void) initCheckNetWork;

+ (void) updateNetWorkStatus:(NetworkStatus) newNetWorkStatus;

@end
