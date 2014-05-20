//
//  RORUserServices.m
//  RevolUtioN
//
//  Created by leon on 13-7-14.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORUserServices.h"
#import "RORNetWorkUtils.h"
#import "RORUserPropsService.h"

@implementation RORUserServices

//open out
+ (User_Base *)fetchUser:(NSNumber *) userId{
    User_Base *user = [self fetchUserBaseById:userId];
    if (user)
        user.userDetail = [self fetchUserDetailByUserId:userId];
    return user;
}

//open out
+ (User_Base *)fetchUserBaseById:(NSNumber *) userId{
    return  [self fetchUserBaseById:userId withContext:nil];
}

+ (User_Base *)fetchUserBaseById:(NSNumber *) userId withContext:(NSManagedObjectContext *) context{
    NSString *table=@"User_Base";
    NSString *query = @"userId = %@";
    NSArray *params = [NSArray arrayWithObjects:userId, nil];
    Boolean needContext =true;
    if(context == nil){
        context = [RORContextUtils getPrivateContext];
        needContext = false;
    }
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query withContext:context];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    User_Base *userInfo = (User_Base *) [fetchObject objectAtIndex:0];
    if (!needContext) {
        return [User_Base removeAssociateForEntity:userInfo withContext:context];
    }
    return userInfo;
}

//open out
+(User_Detail *)fetchUserDetailByUserId:(NSNumber *) userId{
    return [self fetchUserDetailByUserId:userId withContext:nil];
}

+(User_Detail *)fetchUserDetailByUserId:(NSNumber *) userId withContext:(NSManagedObjectContext *) context{
    NSString *table=@"User_Detail";
    NSString *query = @"userId = %@";
    NSArray *params = [NSArray arrayWithObjects:userId, nil];
    Boolean needContext =true;
    if(context == nil){
        context = [RORContextUtils getPrivateContext];
        needContext = false;
    }
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query withContext:context];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    User_Detail *userDetails = (User_Detail *) [fetchObject objectAtIndex:0];
    if (!needContext) {
        return[User_Detail removeAssociateForEntity:userDetails withContext:context];
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
    NSString *lastUpdateTime = @"2000-01-01 00:00:00";
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
    [self updateUserDeviceToken];
    return userBase;
}

//open out
+(BOOL)updateUserBase:(User_Base *)userBase{
    NSNumber *userId = [RORUserUtils getUserId];
    if(userId.integerValue > 0){
        if(userBase!= nil)
        {
            NSDictionary *updateDic = userBase.transToDictionary;
            RORHttpResponse *httpResponse = [RORUserClientHandler updateUserBaseInfo:userId withUserInfo:updateDic];
            if ([httpResponse responseStatus] == 200){
                [self syncUserInfoById:userId];
                return YES;
                
            } else {
                NSLog(@"error: statCode = %@", [httpResponse errorMessage]);
            }
        }
    }
    return NO;
}

+ (void) saveUserInfoToList:(User_Base *)user{
    NSMutableDictionary *userDict = [RORUserUtils getUserInfoPList];
    [userDict setValue:user.userId forKey:@"userId"];
    [userDict setValue:user.nickName forKey:@"nickName"];
    [userDict setValue:user.uuid forKey:@"uuid"];
    [RORUserUtils writeToUserInfoPList:userDict];
    
    NSMutableDictionary *settingDict = [RORUserUtils getUserSettingsPList];
    [settingDict setValue:user.sex forKey:@"sex"];
    [RORUserUtils writeToUserSettingsPList:settingDict];
}

+(User_Base *)syncUserFromResponse:(RORHttpResponse *)httpResponse{
    NSError *error;
    User_Base *user = nil;
    NSManagedObjectContext *context = [RORContextUtils getPrivateContext];
    if ([httpResponse responseStatus] == 200){

        NSDictionary *userInfoDic = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
        
        NSNumber *userId = [userInfoDic valueForKey:@"userId"];
        if(userId.integerValue == [RORUserUtils getUserId].integerValue){
            User_Base *localUser = [self fetchUser:[RORUserUtils getUserId]];
            if(localUser !=nil && localUser.userDetail.updateTime == nil){
                return localUser;
            }
        }
        user = [self fetchUserBaseById:userId withContext:context];
        User_Detail *userDetails = [self fetchUserDetailByUserId:userId withContext:context];
        
        if(user == nil)
            user = [NSEntityDescription insertNewObjectForEntityForName:@"User_Base" inManagedObjectContext:context];
        [user initWithDictionary:userInfoDic];
        
        if(userDetails == nil)
            userDetails = [NSEntityDescription insertNewObjectForEntityForName:@"User_Detail" inManagedObjectContext:context];
        [userDetails initWithDictionary:userInfoDic];
        
        [RORContextUtils saveContext:context];
        user.userDetail = userDetails;
    }
    else if([httpResponse responseStatus] == 406 && [[httpResponse errorMessage] isEqualToString:@"LOGIN_CHECK_FAIL"]){
        [RORUserUtils logout];
        return user;
    }else {
        NSLog(@"sync with host error: can't get user's info. Status Code: %d", [httpResponse responseStatus]);
        return user;
    }
    return [User_Base removeAssociateForEntity:user withContext:context];
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

//open out
+(Reward_Details *) getRandomReward:(NSNumber *)userId {
    if(userId.integerValue>0)
    {
        NSError *error = nil;
        RORHttpResponse *httpResponse =[RORUserClientHandler getRandomReward:userId];
        if ([httpResponse responseStatus]  == 200){
            NSDictionary *rewaredDict = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
            Reward_Details * rewardDetails = [[Reward_Details alloc] init];
            [rewardDetails initWithDictionary:rewaredDict];
            [self syncUserInfoById:userId];
            [RORUserPropsService syncUserProps:userId];
            return rewardDetails;
        }
    }
    return nil;
}

//open out
+ (void)updateUserDeviceToken{
    NSNumber *userId = [RORUserUtils getUserId];
    if(userId.integerValue > 0){
        User_Base *userBase = [RORUserServices fetchUserBaseById:userId];
        if(![userBase.deviceId isEqualToString:[RORUserUtils getDeviceToken]])
        {
            userBase.deviceId = [RORUserUtils getDeviceToken];
            userBase.platformInfo = @"ios";
            [RORUserServices updateUserBase:userBase];
        }
    }
}

+(UIImage *)getCharactorImageNamed:(NSString *)fileName{
    return [RORUtils getImageNamed:fileName];
}


@end
