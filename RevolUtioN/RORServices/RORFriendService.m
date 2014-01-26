//
//  RORFriendService.m
//  WalkFun
//
//  Created by leon on 14-1-26.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "RORFriendService.h"

@implementation RORFriendService

//open out
+(Friend *)fetchUserFriend:(NSNumber *) userId withFriendId:(NSNumber *) friendId{
    return [self fetchUserFriend:userId withFriendId:friendId withContext:NO];
}

+(Friend *)fetchUserFriend:(NSNumber *) userId withFriendId:(NSNumber *) friendId withContext:(BOOL) needContext{
    NSString *table=@"Friend";
    NSString *query = @"userId = %@ and friendId = %@";
    NSArray *params = [NSArray arrayWithObjects:userId,friendId, nil];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    if (!needContext) {
        return[Friend removeAssociateForEntity:(Friend *) [fetchObject objectAtIndex:0]];
    }
    return (Friend *) [fetchObject objectAtIndex:0];
}

//open out
+(int)syncFriendFollows:(NSNumber *) userId {
    if(userId.integerValue > 0)
    {
        NSError *error = nil;
        NSManagedObjectContext *context = [RORContextUtils getShareContext];
        NSString *lastUpdateTime = [RORUserUtils getLastUpdateTime:@"FriendFollowsUpdateTime"];
        RORHttpResponse *httpResponse =[RORUserClientHandler getFriendFollowsInfo:userId withLastUpdateTime:lastUpdateTime];
        
        if ([httpResponse responseStatus] == 200){
            NSArray *friendList = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
            int count = 0;
            for (NSDictionary *friendDict in friendList){
                NSNumber *userIdNum = [friendDict valueForKey:@"userId"];
                NSNumber *friendIdNum = [friendDict valueForKey:@"friendId"];
                Friend *friendEntity = [self fetchUserFriend:userIdNum withFriendId:friendIdNum withContext:YES];
                if(friendEntity == nil)
                    friendEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Friend" inManagedObjectContext:context];
                [friendEntity initWithDictionary:friendDict];
                count ++;
            }
            
            [RORContextUtils saveContext];
            [RORUserUtils saveLastUpdateTime:@"FriendFollowsUpdateTime"];
            return count;
        } else {
            NSLog(@"sync with host error: can't get user's friends list. Status Code: %d", [httpResponse responseStatus]);
        }
    }
    return 0;
}

//open out
+(int)syncFriendFans:(NSNumber *) userId {
    if(userId.integerValue > 0)
    {
        NSError *error = nil;
        NSManagedObjectContext *context = [RORContextUtils getShareContext];
        NSString *lastUpdateTime = [RORUserUtils getLastUpdateTime:@"FriendFansUpdateTime"];
        RORHttpResponse *httpResponse =[RORUserClientHandler getFriendFansInfo:userId withLastUpdateTime:lastUpdateTime];
        
        if ([httpResponse responseStatus] == 200){
            NSArray *friendList = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
            int count = 0;
            for (NSDictionary *friendDict in friendList){
                NSNumber *userIdNum = [friendDict valueForKey:@"userId"];
                NSNumber *friendIdNum = [friendDict valueForKey:@"friendId"];
                Friend *friendEntity = [self fetchUserFriend:userIdNum withFriendId:friendIdNum withContext:YES];
                if(friendEntity == nil)
                    friendEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Friend" inManagedObjectContext:context];
                [friendEntity initWithDictionary:friendDict];
                count ++;
            }
            
            [RORContextUtils saveContext];
            [RORUserUtils saveLastUpdateTime:@"FriendFansUpdateTime"];
            return count;
        } else {
            NSLog(@"sync with host error: can't get user's friends list. Status Code: %d", [httpResponse responseStatus]);
        }
    }
    return 0;
}

+(BOOL)sycnCreateOrUpdateFriend:(Friend *) friend{
    NSNumber *userId = [RORUserUtils getUserId];
    if(userId.integerValue > 0)
    {
        RORHttpResponse *httpResponse =[RORUserClientHandler createFriendInfo:userId withFriendInfo:friend.transToDictionary];
        
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
    BOOL successed = [self sycnCreateOrUpdateFriend:friend];
    //check uuid
    if(successed){
        [self syncFriendFans:[RORUserUtils getUserId]];
        [self syncFriendFollows:[RORUserUtils getUserId]];
        return YES;
    }
    return NO;
}

//open out
+(NSMutableArray *)fetchFriendSortList{
    NSString *table=@"Friend_Sort";
    NSString *query = @"friendStatus = %@";
    NSArray *params = [NSArray arrayWithObjects:[NSNumber numberWithInt:0], nil];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"totalDistance" ascending:NO];
    NSArray *sortParams = [NSArray arrayWithObject:sortDescriptor];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query withOrderBy:sortParams];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    NSMutableArray *followerDetails = [NSMutableArray arrayWithCapacity:10];
    for (Friend_Sort *friendSort in fetchObject) {
        Friend_Sort *newfriendSort = [Friend_Sort removeAssociateForEntity:friendSort];
        [followerDetails addObject:newfriendSort];
    }
    return followerDetails;
}

//open out
+(BOOL)syncFriendSort:(NSNumber *) userId{
    if(userId.integerValue > 0){
        NSError *error = nil;
        NSManagedObjectContext *context = [RORContextUtils getShareContext];
        NSString *lastUpdateTime = [RORUserUtils getLastUpdateTime:@"FriendSortUpdateTime"];
        RORHttpResponse *httpResponse =[RORUserClientHandler getFriendSortInfo:userId withLastUpdateTime:lastUpdateTime];
        
        if ([httpResponse responseStatus] == 200){
            NSArray *friendSortList = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
            for (NSDictionary *friendDict in friendSortList){
                NSNumber *friendIdNum = [friendDict valueForKey:@"friendId"];
                Friend_Sort *friendEntity = [self fetchFriendSortDetails:friendIdNum];
                if(friendEntity == nil)
                    friendEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Friend_Sort" inManagedObjectContext:context];
                [friendEntity initWithDictionary:friendDict];
            }
            [RORContextUtils saveContext];
            [RORUserUtils saveLastUpdateTime:@"FriendSortUpdateTime"];
            return YES;
        } else {
            NSLog(@"sync with host error: can't get user's friends list. Status Code: %d", [httpResponse responseStatus]);
        }
    }
    return NO;
}

+(Friend_Sort *)fetchFriendSortDetails:(NSNumber *) friendId{
    NSString *table=@"Friend_Sort";
    NSString *query = @"friendId = %@";
    NSArray *params = [NSArray arrayWithObjects:friendId, nil];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
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
+ (BOOL) createAction:(Action *)action{
    BOOL successed = [self sycnCreateAction:action];
    //check uuid
    if(successed){
        Action *newAction = [NSEntityDescription insertNewObjectForEntityForName:@"Action" inManagedObjectContext:[RORContextUtils getShareContext]];
        //loop through all attributes and assign then to the clone
        NSDictionary *attributes = [[NSEntityDescription
                                     entityForName:@"Action"
                                     inManagedObjectContext:[RORContextUtils getShareContext]] attributesByName];
        
        for (NSString *attr in [attributes allKeys]) {
            [newAction setValue:[action valueForKey:attr] forKey:attr];
        }
        [RORContextUtils saveContext];
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
        
        if ([httpResponse responseStatus] == 200){
            NSArray *actionList = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
            int count = 0;
            for (NSDictionary *actionDict in actionList){
                Action *newAction = [NSEntityDescription insertNewObjectForEntityForName:@"Action" inManagedObjectContext:[RORContextUtils getShareContext]];
                [newAction initWithDictionary:actionDict];
                count ++;
            }
            [RORContextUtils saveContext];
            return count;
        } else {
            NSLog(@"sync with host error: can't get user's action list. Status Code: %d", [httpResponse responseStatus]);
        }
    }
    return 0;
}

//open out
+(NSArray *)fetchUserAction:(NSNumber *) userId{
    NSString *table=@"Action";
    NSString *query = @"actionFromId = %@ or actionToId = %@";
    NSArray *params = [NSArray arrayWithObjects:userId,userId, nil];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"updateTime" ascending:NO];
    NSArray *sortParams = [NSArray arrayWithObject:sortDescriptor];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query withOrderBy:sortParams];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    NSMutableArray *actionList = [NSMutableArray arrayWithCapacity:10];
    for (Action *action in fetchObject) {
        Action *newAction = [Action removeAssociateForEntity:action];
        [actionList addObject:newAction];
    }
    return actionList;
}

@end
