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
    NSString *query = @"userId = %@ and productId = %@";
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
            NSNumber *propId = [userPropDict valueForKey:@"productId"];
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

//open out 购买道具
+ (BOOL)buyUserProps:(NSNumber *)propId withBuyNumbers:(NSNumber *) numbers{
    Virtual_Product_Buy * buyEnity = [[Virtual_Product_Buy alloc] init];
    buyEnity.userId = [RORUserUtils getUserId];
    buyEnity.productId = propId;
    buyEnity.numbers = numbers;
//    buyEnity.buyTime = [RORUserUtils getSystemTime];
    
    RORHttpResponse *httpResponse = [RORVirtualProductClientHandler createVProductBuyInfo:[RORUserUtils getUserId] withBuyInfo: buyEnity.transToDictionary];
    if ([httpResponse responseStatus] == 200){
        [self syncUserProps:[RORUserUtils getUserId]];
        [RORUserServices syncUserInfoById:[RORUserUtils getUserId]];
        return YES;
    } else {
        NSLog(@"error: statCode = %@", [httpResponse errorMessage]);
        return NO;
    }
}
@end
