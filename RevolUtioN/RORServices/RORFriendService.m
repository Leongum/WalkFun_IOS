//
//  RORFriendService.m
//  WalkFun
//
//  Created by leon on 14-1-26.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "RORFriendService.h"
#import "RORUserServices.h"
#import "RORUserPropsService.h"

@implementation RORFriendService

//open out
+(Friend *)fetchUserFriend:(NSNumber *) userId withFriendId:(NSNumber *) friendId{
    return [self fetchUserFriend:userId withFriendId:friendId withContext:nil];
}

+(Friend *)fetchUserFriend:(NSNumber *) userId withFriendId:(NSNumber *) friendId withContext:(NSManagedObjectContext *) context{
    NSString *table=@"Friend";
    NSString *query = @"userId = %@ and friendId = %@";
    NSArray *params = [NSArray arrayWithObjects:userId,friendId, nil];
    Boolean needContext = true;
    if (context == nil) {
        needContext = false;
        context = [RORContextUtils getPrivateContext];
    }
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query withContext:context];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    if (!needContext) {
        Friend *newFriend = [Friend removeAssociateForEntity:(Friend *) [fetchObject objectAtIndex:0] withContext:context];
        Friend_Sort * friendSort = [self fetchFriendSortDetails:friendId];
        if(friendSort != nil){
            newFriend.sex = friendSort.sex;
            newFriend.level = friendSort.level;
            newFriend.userName = friendSort.friendName;
            newFriend.fight = friendSort.fight;
            newFriend.fightPlus = friendSort.fightPlus;
            newFriend.power = friendSort.power;
            newFriend.totalFights = friendSort.totalFights;
            newFriend.fightsWin = friendSort.fightsWin;
            newFriend.totalFriendFights = friendSort.totalFriendFights;
            newFriend.friendFightWin = friendSort.friendFightWin;
        }

        return newFriend;
    }
    return (Friend *) [fetchObject objectAtIndex:0];
}

//open out
+(int)syncFriends:(NSNumber *) userId {
    if(userId.integerValue > 0)
    {
        NSError *error = nil;
        NSManagedObjectContext *context = [RORContextUtils getPrivateContext];
        NSString *lastUpdateTime = [RORUserUtils getLastUpdateTime:@"FriendsUpdateTime"];
        RORHttpResponse *httpResponse =[RORUserClientHandler getFriendsInfo:userId withLastUpdateTime:lastUpdateTime];
        
        if ([httpResponse responseStatus] == 200){
            NSArray *friendList = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
            int count = 0;
            for (NSDictionary *friendDict in friendList){
                NSNumber *userIdNum = [friendDict valueForKey:@"userId"];
                NSNumber *friendIdNum = [friendDict valueForKey:@"friendId"];
                Friend *friendEntity = [self fetchUserFriend:userIdNum withFriendId:friendIdNum withContext:context];
                if(friendEntity == nil)
                    friendEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Friend" inManagedObjectContext:context];
                [friendEntity initWithDictionary:friendDict];
                count ++;
            }
            
            [RORContextUtils saveContext:context];
            [RORUserUtils saveLastUpdateTime:@"FriendsUpdateTime"];
            return count;
        } else {
            NSLog(@"sync with host error: can't get user's friends list. Status Code: %d", [httpResponse responseStatus]);
            return -1;
        }
    }
    return 0;
}

+(BOOL)sycnCreateOrUpdateFriend:(Friend *) friend{
    NSNumber *userId = [RORUserUtils getUserId];
    if(userId.integerValue > 0)
    {
        NSDictionary *dict = friend.transToDictionary;
        [dict setValue:[RORUtils getStringFromDate:friend.lastWalkTime] forKey:@"lastWalkTime"];
        RORHttpResponse *httpResponse =[RORUserClientHandler createFriendInfo:userId withFriendInfo:dict];
        
        if ([httpResponse responseStatus] == 200){
            return YES;
        } else {
            NSLog(@"sync with host error: can't createOrUpdateFriend. Status Code: %d", [httpResponse responseStatus]);
        }
    }
    return NO;
}

//open out
+ (BOOL) createOrUpdateFriend:(Friend *)friend{
    if (!friend)
        return NO;
    BOOL successed = [self sycnCreateOrUpdateFriend:friend];
    //check uuid
    if(successed){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_GetUserDetails" object:nil userInfo:nil];
        //[self syncFriends:[RORUserUtils getUserId]];
        //[self syncFriendSort:[RORUserUtils getUserId]];
        return YES;
    }
    return NO;
}

//open out
+(NSArray *)fetchFriendFansList{
    NSNumber *userId = [RORUserUtils getUserId];
    NSManagedObjectContext *context = [RORContextUtils getPrivateContext];
    NSString *table=@"Friend";
    NSString *query = @"friendId = %@ and friendEach != nil";
    NSArray *params = [NSArray arrayWithObjects:userId, nil];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"addTime" ascending:NO];
    NSArray *sortParams = [NSArray arrayWithObject:sortDescriptor];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query withOrderBy:sortParams withContext:context];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return [[NSArray alloc]init];
    }
    NSMutableArray *friendsDetails = [NSMutableArray arrayWithCapacity:10];
    for (Friend *friend in fetchObject) {
        Friend *newFriend =[Friend removeAssociateForEntity:friend withContext:context];
        Friend_Sort * friendSort = [self fetchFriendSortDetails:newFriend.userId];
        if(friendSort != nil){
            newFriend.sex = friendSort.sex;
            newFriend.level = friendSort.level;
            newFriend.userName = friendSort.friendName;
            newFriend.fight = friendSort.fight;
            newFriend.fightPlus = friendSort.fightPlus;
            newFriend.power = friendSort.power;
            newFriend.totalFights = friendSort.totalFights;
            newFriend.fightsWin = friendSort.fightsWin;
            newFriend.totalFriendFights = friendSort.totalFriendFights;
            newFriend.friendFightWin = friendSort.friendFightWin;
        }
        [friendsDetails addObject:newFriend];
    }
    return [(NSArray*)friendsDetails mutableCopy];
}

//open out
+(NSArray *)fetchFriendFollowsList{
    NSNumber *userId = [RORUserUtils getUserId];
    NSManagedObjectContext *context = [RORContextUtils getPrivateContext];
    NSString *table=@"Friend";
    NSString *query = @"userId = %@ and friendStatus = 0";
    NSArray *params = [NSArray arrayWithObjects:userId, nil];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"addTime" ascending:NO];
    NSArray *sortParams = [NSArray arrayWithObject:sortDescriptor];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query withOrderBy:sortParams withContext:context];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return [[NSArray alloc]init];
    }
    NSMutableArray *friendsDetails = [NSMutableArray arrayWithCapacity:10];
    for (Friend *friend in fetchObject) {
        Friend *newFriend =[Friend removeAssociateForEntity:friend withContext:context];
        Friend_Sort * friendSort = [self fetchFriendSortDetails:newFriend.friendId];
        if(friendSort != nil){
            newFriend.sex = friendSort.sex;
            newFriend.level = friendSort.level;
            newFriend.userName = friendSort.friendName;
            newFriend.fight = friendSort.fight;
            newFriend.fightPlus = friendSort.fightPlus;
            newFriend.power = friendSort.power;
            newFriend.totalFights = friendSort.totalFights;
            newFriend.fightsWin = friendSort.fightsWin;
            newFriend.totalFriendFights = friendSort.totalFriendFights;
            newFriend.friendFightWin = friendSort.friendFightWin;
        }
        [friendsDetails addObject:newFriend];
    }
    return [(NSArray*)friendsDetails mutableCopy];
}

//open out
+(NSArray *)fetchFriendEachFansList{
    NSNumber *userId = [RORUserUtils getUserId];
    NSManagedObjectContext *context = [RORContextUtils getPrivateContext];
    NSString *table=@"Friend";
    NSString *query = @"userId = %@ and friendEach = 1";
    NSArray *params = [NSArray arrayWithObjects:userId, nil];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"addTime" ascending:NO];
    NSArray *sortParams = [NSArray arrayWithObject:sortDescriptor];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query withOrderBy:sortParams withContext:context];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return [[NSArray alloc ]init];
    }
    NSMutableArray *friendsDetails = [NSMutableArray arrayWithCapacity:10];
    for (Friend *friend in fetchObject) {
        Friend *newFriend =[Friend removeAssociateForEntity:friend withContext:context];
        Friend_Sort * friendSort = [self fetchFriendSortDetails:newFriend.friendId];
        if(friendSort != nil){
            newFriend.sex = friendSort.sex;
            newFriend.level = friendSort.level;
            newFriend.userName = friendSort.friendName;
            newFriend.fight = friendSort.fight;
            newFriend.fightPlus = friendSort.fightPlus;
            newFriend.power = friendSort.power;
            newFriend.totalFights = friendSort.totalFights;
            newFriend.fightsWin = friendSort.fightsWin;
            newFriend.totalFriendFights = friendSort.totalFriendFights;
            newFriend.friendFightWin = friendSort.friendFightWin;
        }
        [friendsDetails addObject:newFriend];
    }
    return [(NSArray*)friendsDetails mutableCopy];
}

//open out
+(BOOL)syncFriendSort:(NSNumber *) userId{
    if(userId.integerValue > 0){
        NSError *error = nil;
        NSManagedObjectContext *context = [RORContextUtils getPrivateContext];
        NSString *lastUpdateTime = [RORUserUtils getLastUpdateTime:@"FriendSortUpdateTime"];
        RORHttpResponse *httpResponse =[RORUserClientHandler getFriendSortInfo:userId withLastUpdateTime:lastUpdateTime];
        
        if ([httpResponse responseStatus] == 200){
            NSArray *friendSortList = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
            for (NSDictionary *friendDict in friendSortList){
                NSNumber *friendIdNum = [friendDict valueForKey:@"friendId"];
                Friend_Sort *friendEntity = [self fetchFriendSortDetails:friendIdNum withContext:context];
                if(friendEntity == nil)
                    friendEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Friend_Sort" inManagedObjectContext:context];
                [friendEntity initWithDictionary:friendDict];
            }
            [RORContextUtils saveContext:context];
            [RORUserUtils saveLastUpdateTime:@"FriendSortUpdateTime"];
            return YES;
        } else {
            NSLog(@"sync with host error: can't get user's friends list. Status Code: %d", [httpResponse responseStatus]);
        }
    }
    return NO;
}

+(Friend_Sort *)fetchFriendSortDetails:(NSNumber *) friendId{
    return [self fetchFriendSortDetails:friendId withContext:nil];
}

+(Friend_Sort *)fetchFriendSortDetails:(NSNumber *) friendId withContext:(NSManagedObjectContext *) context{
    NSString *table=@"Friend_Sort";
    NSString *query = @"friendId = %@";
    NSArray *params = [NSArray arrayWithObjects:friendId, nil];
    Boolean needContext = true;
    if (context == nil) {
        needContext = false;
        context = [RORContextUtils getPrivateContext];
    }

    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query withContext:context];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    if (!needContext) {
        return[Friend_Sort removeAssociateForEntity:(Friend_Sort *) [fetchObject objectAtIndex:0] withContext:context];
    }
    return (Friend_Sort *) [fetchObject objectAtIndex:0];
}

+(BOOL)sycnCreateAction:(Action *) action{
    NSNumber *userId = [RORUserUtils getUserId];
    if(userId.integerValue > 0)
    {
        RORHttpResponse *httpResponse =[RORUserClientHandler createActionInfo:userId withActionInfo:action.transToDictionary];
        
        if ([httpResponse responseStatus] == 200){
            return YES;
        } else {
            NSLog(@"sync with host error: can't createOrUpdateFriend. Status Code: %d", [httpResponse responseStatus]);
        }
    }
    return NO;
}

//open out
+ (BOOL) createAction:(NSNumber *) actionToId withActionToUserName:(NSString *) actionToUserName withActionId:(NSNumber *) actionId{
    NSManagedObjectContext *context = [RORContextUtils getPrivateContext];
    Action *action = [Action initUnassociateEntity:context];
    action.actionFromId = [RORUserUtils getUserId];
    action.actionFromName = [RORUserUtils getUserName];
    action.actionId = actionId;
    action.actionToId = actionToId;
    action.actionToName = actionToUserName;
    action.updateTime = [NSDate date];
    Action_Define *ad = [RORSystemService fetchActionDefine:action.actionId];
    action.actionName = ad.actionName;
    
    NSDictionary *effectDict = [RORUtils explainActionEffetiveRule:ad.effectiveRule];
    if ([[effectDict allKeys] containsObject:RULE_Physical_Power_Add]){
        NSNumber *value = [effectDict valueForKey:RULE_Physical_Power_Add];
        [RORUserUtils saveUserPowerLeft:[RORUserUtils getUserPowerLeft] + value.integerValue];
    }
    if ([[effectDict allKeys] containsObject:RULE_Physical_Power_Percent]){
        NSNumber *value = [effectDict valueForKey:RULE_Physical_Power_Percent];
        User_Base *userBase = [RORUserServices fetchUser:[RORUserUtils getUserId]];
        int addValue = userBase.userDetail.power.intValue * value.intValue / 100;
        [RORUserUtils saveUserPowerLeft:[RORUserUtils getUserPowerLeft] + addValue];
    }
    
    BOOL successed = [self sycnCreateAction:action];
    //check uuid
    if(successed){
        Action *newAction = [NSEntityDescription insertNewObjectForEntityForName:@"Action" inManagedObjectContext:context];
        //loop through all attributes and assign then to the clone
        NSDictionary *attributes = [[NSEntityDescription
                                     entityForName:@"Action"
                                     inManagedObjectContext:context] attributesByName];
        
        for (NSString *attr in [attributes allKeys]) {
            [newAction setValue:[action valueForKey:attr] forKey:attr];
        }
        [RORContextUtils saveContext:context];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_GetUserDetails" object:nil userInfo:nil];
//        [RORUserServices syncUserInfoById:[RORUserUtils getUserId]];
//        [self syncActions:[RORUserUtils getUserId]];
//        [RORUserPropsService syncUserProps:[RORUserUtils getUserId]];
        return YES;
    }
    return NO;
}

//open out
+(int)syncActions:(NSNumber *) userId {
    if(userId.integerValue > 0)
    {
        NSError *error = nil;
        RORHttpResponse *httpResponse =[RORUserClientHandler getActionInfo:userId];
        NSManagedObjectContext *context = [RORContextUtils getPrivateContext];
        if ([httpResponse responseStatus] == 200){
            NSArray *actionList = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
            int count = 0;
            for (NSDictionary *actionDict in actionList){
                NSNumber *actionFromId = [actionDict valueForKey:@"actionFromId"];
                NSNumber *actionToId = [actionDict valueForKey:@"actionToId"];
                if(actionFromId.integerValue != actionToId.integerValue){
                    Action *newAction = [NSEntityDescription insertNewObjectForEntityForName:@"Action" inManagedObjectContext:context];
                    [newAction initWithDictionary:actionDict];
                    Action_Define *ad = [RORSystemService fetchActionDefine:newAction.actionId];
                    NSDictionary *effectDict = [RORUtils explainActionEffetiveRule:ad.effectiveRule];
                    if ([[effectDict allKeys] containsObject:RULE_Physical_Power_Add]){
                        NSNumber *value = [effectDict valueForKey:RULE_Physical_Power_Add];
                        [RORUserUtils saveUserPowerLeft:[RORUserUtils getUserPowerLeft] + value.integerValue];
                    }
                    if ([[effectDict allKeys] containsObject:RULE_Physical_Power_Percent]){
                        NSNumber *value = [effectDict valueForKey:RULE_Physical_Power_Percent];
                        User_Base *userBase = [RORUserServices fetchUser:[RORUserUtils getUserId]];
                        int addValue = userBase.userDetail.power.intValue * value.intValue / 100;
                        [RORUserUtils saveUserPowerLeft:[RORUserUtils getUserPowerLeft] + addValue];
                    }
                    count ++;
                }
            }
            [RORContextUtils saveContext:context];
            return count;
        } else {
            NSLog(@"sync with host error: can't get user's action list. Status Code: %d", [httpResponse responseStatus]);
        }
    }
    return 0;
}

//open out
+(NSMutableArray *)fetchUserActionsById:(NSNumber *) userId{
    NSMutableArray * actions = [[NSMutableArray alloc] init];
    if(userId.integerValue > 0)
    {
        NSError *error = nil;
        RORHttpResponse *httpResponse =[RORUserClientHandler getUserActionInfoById:userId];
        
        if ([httpResponse responseStatus] == 200){
            NSArray *actionList = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
            NSManagedObjectContext *context = [RORContextUtils getPrivateContext];
            for (NSDictionary *actionDict in actionList){
                Action *newAction = [Action initUnassociateEntity:context];
                [newAction initWithDictionary:actionDict];
                [actions addObject:newAction];
            }
            return actions;
        } else {
            NSLog(@"sync with host error: can't get user's action list. Status Code: %d", [httpResponse responseStatus]);
        }
    }
    return actions;
}

//open out
+(NSArray *)fetchUserAction:(NSNumber *) userId{
    NSString *table=@"Action";
    NSString *query = @"actionToId = %@";
    NSArray *params = [NSArray arrayWithObjects:userId, nil];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"updateTime" ascending:NO];
    NSArray *sortParams = [NSArray arrayWithObject:sortDescriptor];
    NSManagedObjectContext *context = [RORContextUtils getPrivateContext];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query withOrderBy:sortParams withContext:context];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    NSMutableArray *actionList = [NSMutableArray arrayWithCapacity:10];
    for (Action *action in fetchObject) {
        Action *newAction = [Action removeAssociateForEntity:action withContext:context];
        [actionList addObject:newAction];
    }
    return actionList;
}

//open out
+(NSArray *)fetchRecommendFriends:(NSNumber *) pageNo {
    if(pageNo == nil){
        pageNo = [NSNumber numberWithInt:0];
    }
    NSError *error = nil;
    RORHttpResponse *httpResponse =[RORUserClientHandler getRecommendFriends:pageNo];
    if ([httpResponse responseStatus]  == 200){
        NSArray *searchFriendList = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
        NSMutableArray *friendList = [[NSMutableArray alloc] init];
        for (NSDictionary *searchDict in searchFriendList){
            Search_Friend * searchFriend = [[Search_Friend alloc] init];
            [searchFriend initWithDictionary:searchDict];
            if (searchFriend.userId.integerValue != [RORUserUtils getUserId].integerValue){
                [friendList addObject:searchFriend];
            }
        }
        return friendList;
    }
    return nil;
}

+ (FollowStatusEnum)getFollowStatus:(NSNumber *)friendId{
    Friend *friend = [RORFriendService fetchUserFriend:[RORUserUtils getUserId] withFriendId:friendId];
    if (!friend || friend.friendStatus.integerValue == FollowStatusNotFollowed){
        return FollowStatusNotFollowed;
    }
    return FollowStatusFollowed;
}

+ (BOOL)followFriend:(NSNumber *)friendId{
    NSManagedObjectContext *context = [RORContextUtils getPrivateContext];
    if (friendId.integerValue == [RORUserUtils getUserId].integerValue)
        return NO;
    Friend *friend = [RORFriendService fetchUserFriend:[RORUserUtils getUserId] withFriendId:friendId];
    if (friend){
        friend.friendStatus = [NSNumber numberWithInteger:FollowStatusFollowed];
    } else {
        friend = [Friend intiUnassociateEntity:context];
        friend.userId = [RORUserUtils getUserId];
        friend.friendId = friendId;
        friend.friendStatus = [NSNumber numberWithInteger:FollowStatusFollowed];
    }
    
    return [RORFriendService createOrUpdateFriend:friend];
}

+(BOOL)deFollowFriend:(NSNumber *)friendId{
    if (friendId.integerValue == [RORUserUtils getUserId].integerValue)
        return NO;
    Friend *friend = [RORFriendService fetchUserFriend:[RORUserUtils getUserId] withFriendId:friendId];
    if (friend){
        friend.friendStatus = [NSNumber numberWithInteger:FollowStatusNotFollowed];
    }
    return [RORFriendService createOrUpdateFriend:friend];
}

@end
