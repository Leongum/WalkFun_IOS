//
//  RORShareService.h
//  RevolUtioN
//
//  Created by leon on 13-8-15.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User_Base.h"
#import "RORUserServices.h"
#import "User_Running_History.h"

@interface RORShareService : NSObject

//login return YES, register return NO.
+ (int)loginFromSNS:(UMSocialAccountEntity *)userInfo;

//lingqian shwo reward
+(void)LQ_Runreward:(User_Running_History *)bestRecord;

@end
