//
//  RORShareService.m
//  RevolUtioN
//
//  Created by leon on 13-8-15.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORShareService.h"

@implementation RORShareService

//login return 0, register return 1. error return -1
+ (int)loginFromSNS:(UMSocialAccountEntity *)userInfo{
    NSManagedObjectContext *context = [RORContextUtils getPrivateContext];
    if(userInfo == nil || userInfo.usid == nil){
        return -1;
    }
    User_Base *user = [User_Base intiUnassociateEntity:context];
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
        loginUser = [RORUserServices registerUser:regDict];
        if(loginUser != nil){
            return 1;
        }else{
            return -1;
        }
    }
    return 0;
}

+(void)LQ_Runreward:(User_Running_History *)bestRecord{
    if(bestRecord.valid.integerValue == 1 && (bestRecord.distance.doubleValue > 500 || bestRecord.duration.doubleValue > 300))
    {
        //[LingQianSDK trackActionWithName:@"runreward"];
    }
}

@end
