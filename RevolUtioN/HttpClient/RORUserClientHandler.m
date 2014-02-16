//
//  RORUserClientHandler.m
//  RevolUtioN
//
//  Created by leon on 13-7-15.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORUserClientHandler.h"

@implementation RORUserClientHandler

+(RORHttpResponse *)getUserInfoByUserNameAndPassword:(NSString *) userName withPassword:(NSString *) password{
    NSString *url = [NSString stringWithFormat:USER_LOGIN_URL ,userName, password];
    RORHttpResponse *httpResponse = [RORHttpClientHandler getRequest:url];
    return httpResponse;
}

+(RORHttpResponse *)createUserInfoByUserDic:(NSDictionary *) userInfo{
    RORHttpResponse *httpResponse = [RORHttpClientHandler postRequest:USER_REGISTER_URL withRequstBody:[RORUtils toJsonFormObject:userInfo]];
    return httpResponse;
}

+(RORHttpResponse *)getUserInfoById:(NSNumber *) userId withLastUpdateTime:(NSString *) lastUpdateTime{
    NSString *url = [NSString stringWithFormat:USER_GETINFO_BY_ID_URL ,userId,lastUpdateTime];
    RORHttpResponse *httpResponse = [RORHttpClientHandler getRequest:url];
    return httpResponse;
}

+(RORHttpResponse *)updateUserBaseInfo:(NSNumber *)userId withUserInfo:(NSDictionary *) userInfo{
    NSString *url = [NSString stringWithFormat:USER_BASE_UPDATE_URL ,userId];
    RORHttpResponse *httpResponse = [RORHttpClientHandler putRequest:url withRequstBody:[RORUtils toJsonFormObject:userInfo]];
    return httpResponse;
}

+(RORHttpResponse *)updateUserDetailInfo:(NSNumber *)userId withUserInfo:(NSDictionary *) userInfo{
    NSString *url = [NSString stringWithFormat:USER_DETAIL_UPDATE_URL ,userId];
    RORHttpResponse *httpResponse = [RORHttpClientHandler putRequest:url withRequstBody:[RORUtils toJsonFormObject:userInfo]];
    return httpResponse;
}

+(RORHttpResponse *)createFriendInfo:(NSNumber *)userId withFriendInfo:(NSDictionary *) friendInfo{
    NSString *requestUrl = [NSString stringWithFormat:FRIEND_CREATE_OR_UPDATE_URL, userId];
    RORHttpResponse *httpResponse = [RORHttpClientHandler postRequest:requestUrl withRequstBody:[RORUtils toJsonFormObject:friendInfo]];
    return httpResponse;
}

+(RORHttpResponse *)getFriendFansInfo:(NSNumber *)userId withLastUpdateTime:(NSString *) lastUpdateTime{
    NSString *url = [NSString stringWithFormat:FRIEND_GET_FANS_URL, userId, lastUpdateTime];
    RORHttpResponse *httpResponse = [RORHttpClientHandler getRequest:url];
    return httpResponse;
}

+(RORHttpResponse *)getFriendFollowsInfo:(NSNumber *)userId withLastUpdateTime:(NSString *) lastUpdateTime{
    NSString *url = [NSString stringWithFormat:FRIEND_GET_FOLLOWER_URL, userId, lastUpdateTime];
    RORHttpResponse *httpResponse = [RORHttpClientHandler getRequest:url];
    return httpResponse;
}

+(RORHttpResponse *)searchFriendInfo:(NSString *)nickName{
    NSString *url = [NSString stringWithFormat:FRIEND_SEARCH_URL, nickName];
    RORHttpResponse *httpResponse = [RORHttpClientHandler getRequest:url];
    return httpResponse;
}

+(RORHttpResponse *)getFriendSortInfo:(NSNumber *)userId withLastUpdateTime:(NSString *) lastUpdateTime{
    NSString *url = [NSString stringWithFormat:FRIEND_SORT_UPDATE_URL, userId, lastUpdateTime];
    RORHttpResponse *httpResponse = [RORHttpClientHandler getRequest:url];
    return httpResponse;
}

+(RORHttpResponse *)createActionInfo:(NSNumber *)userId withActionInfo:(NSDictionary *) actionInfo{
    NSString *requestUrl = [NSString stringWithFormat:ACTION_CREATE_ACTION_URL, userId];
    RORHttpResponse *httpResponse = [RORHttpClientHandler postRequest:requestUrl withRequstBody:[RORUtils toJsonFormObject:actionInfo]];
    return httpResponse;
}

+(RORHttpResponse *)getActionInfo:(NSNumber *)userId{
    NSString *url = [NSString stringWithFormat:ACTION_GET_ACTION_URL, userId];
    RORHttpResponse *httpResponse = [RORHttpClientHandler getRequest:url];
    return httpResponse;
}

+(RORHttpResponse *)getUserProps:(NSNumber *)userId withLastUpdateTime:(NSString *) lastUpdateTime{
    NSString *url = [NSString stringWithFormat:PROP_GET_URL, userId, lastUpdateTime];
    RORHttpResponse *httpResponse = [RORHttpClientHandler getRequest:url];
    return httpResponse;
}

+(RORHttpResponse *)createOrUpdateUserProp:(NSNumber *)userId withUserProps:(NSMutableArray *) userProps{
    NSString *requestUrl = [NSString stringWithFormat:PROP_CREATE_URL, userId];
    RORHttpResponse *httpResponse = [RORHttpClientHandler postRequest:requestUrl withRequstBody:[RORUtils toJsonFormObject:userProps]];
    return httpResponse;
}
@end
