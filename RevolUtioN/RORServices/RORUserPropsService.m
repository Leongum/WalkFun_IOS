//
//  RORUserPropsService.m
//  WalkFun
//
//  Created by leon on 14-2-16.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "RORUserPropsService.h"

@implementation RORUserPropsService

//open out
+(NSArray*)fetchUserProps:(NSNumber*)userId{
    return [self fetchUserProps:userId withContext:NO];
}

+(NSArray*)fetchUserProps:(NSNumber*)userId withContext:(BOOL) needContext{
    NSString *table=@"User_Prop";
    NSString *query = @"userId = %@";
    NSArray *params = [NSArray arrayWithObjects:userId, nil];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    if(!needContext){
        NSMutableArray *userProps = [[NSMutableArray alloc] init];
        for (User_Prop *userProp in fetchObject) {
            [userProps addObject:[User_Prop removeAssociateForEntity:userProp]];
        }
        return [userProps copy];
    }
    return fetchObject;
}

//open out
+(User_Prop *)fetchUserPropByPropId:(NSNumber *) userId withPropId:(NSNumber *) propId{
    return [self fetchUserPropByPropId:userId withPropId:propId withContext:NO];
}

+(User_Prop *)fetchUserPropByPropId:(NSNumber *) userId withPropId:(NSNumber *) propId withContext:(BOOL) needContext{
    NSString *table=@"User_Prop";
    NSString *query = @"userId = %@ and producId = %@";
    NSArray *params = [NSArray arrayWithObjects:userId,propId, nil];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    if (!needContext) {
        return[User_Prop removeAssociateForEntity:(User_Prop *) [fetchObject objectAtIndex:0]];
    }
    return (User_Prop *) [fetchObject objectAtIndex:0];
}

//open out
+ (BOOL)syncUserProps:(NSNumber *)userId{
    //if(![RORNetWorkUtils getDoUploadable])return NO;
    NSError *error = nil;
    NSString *lastUpdateTime = [RORUserUtils getLastUpdateTime:@"UserPropUpdateTime"];
    
    RORHttpResponse *httpResponse =[RORUserClientHandler getUserProps:userId withLastUpdateTime:lastUpdateTime];
    if ([httpResponse responseStatus]  == 200){
        NSArray *userPropsList = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
        for (NSDictionary *userPropDict in userPropsList){
            NSNumber *userId = [userPropDict valueForKey:@"userId"];
            NSNumber *propId = [userPropDict valueForKey:@"producId"];
            User_Prop *userPropEntity = [self fetchUserPropByPropId:userId withPropId:propId withContext:YES];
            //use local data insteade of service data when update in local.
            if(userPropEntity!= nil && userPropEntity.updateTime == nil){
                continue;
            }
            if(userPropEntity == nil)
                userPropEntity = [NSEntityDescription insertNewObjectForEntityForName:@"User_Prop" inManagedObjectContext:[RORContextUtils getShareContext]];
            
            [userPropEntity initWithDictionary:userPropDict];
        }
        [RORContextUtils saveContext];
        [RORUserUtils saveLastUpdateTime:@"UserPropUpdateTime"];
        return YES;
    } else {
        NSLog(@"sync with host error: can't get user prop. Status Code: %d", [httpResponse responseStatus]);
    }
    return NO;
}

//open out
+ (BOOL) saveUserPropInfoToDB:(User_Prop *)userProp{
    //check userid and productid
    if(userProp.userId != nil && userProp.producId != nil){
        NSNumber *userId = userProp.userId;
        NSNumber *propId = userProp.producId;
        User_Prop *currentUserProp = [self fetchUserPropByPropId:userId withPropId:propId withContext:YES];;
        if(currentUserProp == nil)
            currentUserProp = [NSEntityDescription insertNewObjectForEntityForName:@"User_Prop" inManagedObjectContext:[RORContextUtils getShareContext]];
        //loop through all attributes and assign then to the clone
        NSDictionary *attributes = [[NSEntityDescription
                                     entityForName:@"User_Prop"
                                     inManagedObjectContext:[RORContextUtils getShareContext]] attributesByName];
        
        for (NSString *attr in [attributes allKeys]) {
            [currentUserProp setValue:[userProp valueForKey:attr] forKey:attr];
        }
        currentUserProp.updateTime = nil;
        [RORContextUtils saveContext];
    }
    return YES;
}

//open out
+ (BOOL)uploadUserProps{
    //if(![RORNetWorkUtils getDoUploadable])return NO;
    NSNumber *userId = [RORUserUtils getUserId];
    if(userId.integerValue > 0){
        NSArray *dataList = [self fetchUnsyncedUserProps:NO];
        if([dataList count] > 0){
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (User_Prop *userProp in dataList) {
                userProp.updateTime = [RORUserUtils getSystemTime];
                [array addObject:userProp.transToDictionary];
            }
            RORHttpResponse *httpResponse = [RORUserClientHandler createOrUpdateUserProp:userId withUserProps:array];
            if ([httpResponse responseStatus] == 200){
                [self updateUnsyncedUserProps];
                return YES;
                
            } else {
                NSLog(@"error: statCode = %@", [httpResponse errorMessage]);
                return NO;
            }
        }
    }
    return YES;
}

+(NSArray *)fetchUnsyncedUserProps:(BOOL) needContext{
    
    NSNumber *userId = [RORUserUtils getUserId];
    NSString *table=@"User_Prop";
    NSString *query = @"userId = %@ and updateTime = nil";
    NSArray *params = [NSArray arrayWithObjects:userId, nil];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    if(!needContext){
        NSMutableArray *userProps = [[NSMutableArray alloc] init];
        for (User_Prop *userProp in fetchObject) {
            User_Prop *newUserProp = [User_Prop removeAssociateForEntity:userProp];
            [userProps addObject:newUserProp];
        }
        return [userProps copy];
    }
    return fetchObject;
}

+(void)updateUnsyncedUserProps{
    NSArray *fetchObject = [self fetchUnsyncedUserProps:YES];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return;
    }
    for (User_Prop *info in fetchObject) {
        info.updateTime = [RORUserUtils getSystemTime];
    }
    [RORContextUtils saveContext];
}

@end
