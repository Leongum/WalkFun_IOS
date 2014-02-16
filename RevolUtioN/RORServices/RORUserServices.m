^{
    <#code#>
}//
//  RORUserServices.m
//  RevolUtioN
//
//  Created by leon on 13-7-14.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORUserServices.h"
#import "RORNetWorkUtils.h"

@implementation RORUserServices

//open out
+ (User_Base *)fetchUser:(NSNumber *) userId{
    User_Base *user = [self fetchUserBaseById:userId];
    if(user != nil){
        user.userDetail = [self fetchUserDetailByUserId:userId];
    }
    return user;
}

//open out
+ (User_Base *)fetchUserBaseById:(NSNumber *) userId{
    return  [self fetchUserBaseById:userId withContext:NO];
}

+ (User_Base *)fetchUserBaseById:(NSNumber *) userId withContext:(BOOL) needContext{
    NSString *table=@"User_Base";
    NSString *query = @"userId = %@";
    NSArray *params = [NSArray arrayWithObjects:userId, nil];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    User_Base *userInfo = (User_Base *) [fetchObject objectAtIndex:0];
    if (!needContext) {
        return [User_Base removeAssociateForEntity:userInfo];
    }
    return userInfo;
}

//open out
+(User_Detail *)fetchUserDetailByUserId:(NSNumber *) userId{
    return [self fetchUserDetailByUserId:userId withContext:NO];
}

+(User_Detail *)fetchUserDetailByUserId:(NSNumber *) userId withContext:(BOOL) needContext{
    NSString *table=@"User_Detail";
    NSString *query = @"userId = %@";
    NSArray *params = [NSArray arrayWithObjects:userId, nil];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    User_Detail *userDetails = (User_Detail *) [fetchObject objectAtIndex:0];
    if (!needContext) {
        return[User_Detail removeAssociateForEntity:userDetails];
    }
    return   userDetails;
}

//open out
+(User_Base *)registerUser:(NSDictionary *)registerDic{
    RORHttpResponse *httpResponse = [RORUserClientHandler createUserInfoByUserDic:registerDic];
    User_Base *userBase = [self syncUserFromResponse:httpResponse];
    [self saveUserInfoToList:userBase];
    return userBase;
}

//open out
+(User_Base *)syncUserInfoById:(NSNumber *)userId{
    if(userId <= 0) return nil;
    User_Base *localUser = [self fetchUser:userId];
    NSString *lastUpdateTime = nil;
    if(localUser !=nil){
        lastUpdateTime = [RORUtils getStringFromDate:localUser.userDetail.updateTime];
    }
    RORHttpResponse *httpResponse =[RORUserClientHandler getUserInfoById:userId withLastUpdateTime:lastUpdateTime];
    return [self syncUserFromResponse:httpResponse];
}

//open out
+(User_Base *)syncUserInfoByLogin:(NSString *)userName withUserPassword:(NSString *) password{
    if(userName == nil || password == nil) return nil;
    RORHttpResponse *httpResponse = [RORUserClientHandler getUserInfoByUserNameAndPassword:userName withPassword:password];
    User_Base *userBase = [self syncUserFromResponse:httpResponse];
    [self saveUserInfoToList:userBase];
    return userBase;
}

//open out
+(void)uploadUserInfo{
    NSNumber *userId = [RORUserUtils getUserId];
    if(userId.integerValue > 0){
        User_Base *userBase = [self fetchUserBaseById:userId withContext:YES];
        if(userBase!= nil && userBase.updateTime == nil)
        {
            NSDictionary *updateDic = userBase.transToDictionary;
            RORHttpResponse *httpResponse = [RORUserClientHandler updateUserBaseInfo:userId withUserInfo:updateDic];
            if ([httpResponse responseStatus] == 200){
                userBase.updateTime = [RORUserUtils getSystemTime];
                
            } else {
                NSLog(@"error: statCode = %@", [httpResponse errorMessage]);
            }
        }
        User_Detail *userDetail = [self fetchUserDetailByUserId:userId];
        if(userDetail!= nil && userDetail.updateTime == nil)
        {
            NSDictionary *updateDic = userDetail.transToDictionary;
            RORHttpResponse *httpResponse = [RORUserClientHandler updateUserDetailInfo:userId withUserInfo:updateDic];
            if ([httpResponse responseStatus] == 200){
                userDetail.updateTime =[RORUserUtils getSystemTime];
                
            } else {
                NSLog(@"error: statCode = %@", [httpResponse errorMessage]);
            }
        }
        [RORContextUtils saveContext];
    }
}

//open out do all update things.
+ (BOOL) saveUserBaseInfoToDB:(User_Base *)userBase{
    //check uuid
    if(userBase.userId != nil && userBase.userId.integerValue == [RORUserUtils getUserId].integerValue){
        NSNumber *userId = userBase.userId;
        User_Base *userBaseEntity = [self fetchUserBaseById:userId withContext:YES];
        //loop through all attributes and assign then to the clone
        NSDictionary *attributes = [[NSEntityDescription
                                     entityForName:@"User_Base"
                                     inManagedObjectContext:[RORContextUtils getShareContext]] attributesByName];
        
        for (NSString *attr in [attributes allKeys]) {
            [userBaseEntity setValue:[userBase valueForKey:attr] forKey:attr];
        }
        userBaseEntity.updateTime = nil;
        [RORContextUtils saveContext];
        [self saveUserInfoToList:userBase];
    }
    return YES;
}

//open out do all update things.
+ (BOOL) saveUserDetailInfoToDB:(User_Detail *)userDetail{
    //check uuid
    if(userDetail.userId != nil && userDetail.userId.integerValue == [RORUserUtils getUserId].integerValue){
        NSNumber *userId = userDetail.userId;
        User_Detail *userDetailEntity = [self fetchUserDetailByUserId:userId withContext:YES];
        //loop through all attributes and assign then to the clone
        NSDictionary *attributes = [[NSEntityDescription
                                     entityForName:@"User_Detail"
                                     inManagedObjectContext:[RORContextUtils getShareContext]] attributesByName];
        
        for (NSString *attr in [attributes allKeys]) {
            [userDetailEntity setValue:[userDetail valueForKey:attr] forKey:attr];
        }
        userDetailEntity.updateTime = nil;
        [RORContextUtils saveContext];
    }
    return YES;
}

+ (void) saveUserInfoToList:(User_Base *)user{
    NSMutableDictionary *userDict = [RORUserUtils getUserInfoPList];
    [userDict setValue:user.userId forKey:@"userId"];
    [userDict setValue:user.nickName forKey:@"nickName"];
    [userDict setValue:user.uuid forKey:@"uuid"];
    [RORUserUtils writeToUserInfoPList:userDict];
    
    NSMutableDictionary *settingDict = [RORUserUtils getUserSettingsPList];
    [settingDict setValue:user.sex forKey:@"sex"];
    [settingDict setValue:user.weight forKey:@"weight"];
    [settingDict setValue:user.height forKey:@"height"];
    [RORUserUtils writeToUserSettingsPList:settingDict];
}

+(User_Base *)syncUserFromResponse:(RORHttpResponse *)httpResponse{
    NSError *error;
    User_Base *user = nil;
    if ([httpResponse responseStatus] == 200){
        NSDictionary *userInfoDic = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
        
        NSNumber *userId = [userInfoDic valueForKey:@"userId"];
        if(userId.integerValue == [RORUserUtils getUserId].integerValue){
            User_Base *localUser = [self fetchUser:[RORUserUtils getUserId]];
            if(localUser !=nil && localUser.userDetail.updateTime == nil){
                return localUser;
            }
        }
        user = [self fetchUserBaseById:userId withContext:YES];
        User_Detail *userDetails = [self fetchUserDetailByUserId:userId withContext:YES];
        
        if(user == nil)
            user = [NSEntityDescription insertNewObjectForEntityForName:@"User_Base" inManagedObjectContext:[RORContextUtils getShareContext]];
        [user initWithDictionary:userInfoDic];
        
        if(userDetails == nil)
            userDetails = [NSEntityDescription insertNewObjectForEntityForName:@"User_Detail" inManagedObjectContext:[RORContextUtils getShareContext]];
        [userDetails initWithDictionary:userInfoDic];
        
        [RORContextUtils saveContext];
        user.userDetail = userDetails;
    }
    else if([httpResponse responseStatus] == 406 && [[httpResponse errorMessage] isEqualToString:@"LOGIN_CHECK_FAIL"]){
        [RORUserUtils logout];
    }else {
        NSLog(@"sync with host error: can't get user's info. Status Code: %d", [httpResponse responseStatus]);
        return user;
    }
    return [User_Base removeAssociateForEntity:user];
}

//open out
+(NSArray *)searchFriend:(NSString *) nickName {
    if(nickName != nil && nickName.length>0)
    {
        NSError *error = nil;
        RORHttpResponse *httpResponse =[RORUserClientHandler searchFriendInfo:nickName];
        if ([httpResponse responseStatus]  == 200){
            NSArray *searchFriendList = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
            NSMutableArray *friendList = [[NSMutableArray alloc] init];
            for (NSDictionary *searchDict in searchFriendList){
                Search_Friend * searchFriend = [[Search_Friend alloc] init];
                [searchFriend initWithDictionary:searchDict];
                [friendList addObject:searchFriend];
            }
            return friendList;
        }
    }
    return nil;
}

+(void)clearUserData{
    NSArray *tables = [NSArray arrayWithObjects:@"User_Base",@"User_Detail",@"Action",@"Friend",@"Friend_Sort",@"User_Running_History",@"User_Mission_History", nil];
    [RORContextUtils clearTableData:tables];
}

@end
