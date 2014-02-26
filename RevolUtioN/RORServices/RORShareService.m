//
//  RORShareService.m
//  RevolUtioN
//
//  Created by leon on 13-8-15.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORShareService.h"

@implementation RORShareService

//login return YES, register return NO.
+ (BOOL)loginFromSNS:(UMSocialAccountEntity *)userInfo{
    User_Base *user = [User_Base intiUnassociateEntity];
    user.userName = userInfo.usid;
    user.nickName = userInfo.userName;
    user.sex = @"未知";
    user.password = [RORUtils md5:user.userName];
    user.platformInfo = @"ios";
    //todo:: add device id.
    user.deviceId = [RORUserUtils getDeviceToken];
    
    User_Base *loginUser = [RORUserServices syncUserInfoByLogin:user.userName withUserPassword:[RORUtils md5:user.password]];
    
    if (loginUser == nil){
        NSDictionary *regDict = [[NSDictionary alloc]initWithObjectsAndKeys:
                                 user.userName, @"userName",
                                 [RORUtils md5:user.password], @"password",
                                 user.nickName, @"nickName",
                                 user.sex, @"sex",
                                 user.deviceId, @"deviceId",
                                 user.platformInfo, @"platformInfo",
                                 nil];
        [RORUserServices registerUser:regDict];
        return NO;
    }
    return YES;
}

+(void)LQ_Runreward:(User_Running_History *)bestRecord{
    if(bestRecord.valid.integerValue == 1 && (bestRecord.distance.doubleValue > 500 || bestRecord.duration.doubleValue > 300))
    {
        //[LingQianSDK trackActionWithName:@"runreward"];
    }
}

@end
