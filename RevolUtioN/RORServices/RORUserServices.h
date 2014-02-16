//
//  RORUserServices.h
//  RevolUtioN
//
//  Created by leon on 13-7-14.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User_Base.h"
#import "User_Detail.h"
#import "Search_Friend.h"
#import "RORAppDelegate.h"
#import "RORContextUtils.h"
#import "RORHttpResponse.h"
#import "RORUserClientHandler.h"

@interface RORUserServices : NSObject

//根据用户id 获取本地用户信息。不与服务器同步
+(User_Base *)fetchUser:(NSNumber *) userId;

//获取本地user base的信息
+(User_Base *)fetchUserBaseById:(NSNumber *) userId;

//获取本地 user detail的信息
+(User_Detail *)fetchUserDetailByUserId:(NSNumber *) userId;

//注册用户，返回用户信息
+(User_Base *)registerUser:(NSDictionary *)registerDic;

//根据用户id获取服务器用户信息，同步服务器。
+(User_Base *)syncUserInfoById:(NSNumber *)userId;

//登录。
+(User_Base *)syncUserInfoByLogin:(NSString *)userName withUserPassword:(NSString *) password;

//提交本地用户数据
+(void)uploadUserInfo;

//保存user base 信息到本地，不包含上传。
+(BOOL)saveUserBaseInfoToDB:(User_Base *)userBase;

//保存user detail 信息到本地，不包含上传
+(BOOL)saveUserDetailInfoToDB:(User_Detail *)userDetail;

//根据昵称查询用户，服务器同步获取。返回Search_Friend
+(NSArray *)searchFriend:(NSString *) nickName;



//logout之后删除本地数据
+(void)clearUserData;
@end
