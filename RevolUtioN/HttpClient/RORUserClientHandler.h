//
//  RORUserClientHandler.h
//  RevolUtioN
//
//  Created by leon on 13-7-15.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RORConstant.h"
#import "RORUserUtils.h"
#import "RORHttpClientHandler.h"
#import "RORHttpResponse.h"

@interface RORUserClientHandler : NSObject

+(RORHttpResponse *)getUserInfoByUserNameAndPassword:(NSString *) userName withPassword:(NSString *) password;

+(RORHttpResponse *)createUserInfoByUserDic:(NSDictionary *) userInfo;

+(RORHttpResponse *)getUserInfoById:(NSNumber *) userId withLastUpdateTime:(NSString *) lastUpdateTime;

+(RORHttpResponse *)updateUserBaseInfo:(NSNumber *)userId withUserInfo:(NSDictionary *) userInfo;

+(RORHttpResponse *)updateUserDetailInfo:(NSNumber *)userId withUserInfo:(NSDictionary *) userInfo;

+(RORHttpResponse *)createFriendInfo:(NSNumber *)userId withFriendInfo:(NSDictionary *) friendInfo;

+(RORHttpResponse *)getFriendFansInfo:(NSNumber *)userId withLastUpdateTime:(NSString *) lastUpdateTime;

+(RORHttpResponse *)getFriendFollowsInfo:(NSNumber *)userId withLastUpdateTime:(NSString *) lastUpdateTime;

+(RORHttpResponse *)searchFriendInfo:(NSString *)nickName;

+(RORHttpResponse *)getFriendSortInfo:(NSNumber *)userId withLastUpdateTime:(NSString *) lastUpdateTime;

+(RORHttpResponse *)createActionInfo:(NSNumber *)userId withActionInfo:(NSDictionary *) actionInfo;

+(RORHttpResponse *)getActionInfo:(NSNumber *)userId;

+(RORHttpResponse *)getUserProps:(NSNumber *)userId withLastUpdateTime:(NSString *) lastUpdateTime;

+(RORHttpResponse *)createOrUpdateUserProp:(NSNumber *)userId withUserProps:(NSMutableArray *) userProps;

@end