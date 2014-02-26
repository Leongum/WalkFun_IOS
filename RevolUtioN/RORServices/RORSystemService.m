//
//  RORSystemService.m
//  RevolUtioN
//
//  Created by leon on 13-8-10.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORSystemService.h"

@implementation RORSystemService

//open out
+(Version_Control *)syncVersion:(NSString *)platform{
    NSError *error = nil;
    RORHttpResponse *httpResponse =[RORSystemClientHandler getVersionInfo:platform];
    
    if ([httpResponse responseStatus] == 200){
        NSDictionary *versionInfo = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
        Version_Control *versionEntity = [[Version_Control alloc] init];
        [versionEntity initWithDictionary:versionInfo];
        
        NSLog(@"%@",versionEntity.systemTime);
        [self saveSystimeTime:[RORUtils getStringFromDate:versionEntity.systemTime]];
        return versionEntity;
    } else {
        NSLog(@"sync with host error: can't get version info. Status Code: %d", [httpResponse responseStatus]);
    }
    return nil;
}

//open out
+ (BOOL)syncSystemMessage{
    NSError *error = nil;
    NSManagedObjectContext *context = [RORContextUtils getShareContext];
    NSString *lastUpdateTime = [RORUserUtils getLastUpdateTime:@"SystemMessageUpdateTime"];
    
    RORHttpResponse *httpResponse =[RORSystemClientHandler getSystemMessage:lastUpdateTime];
    
    if ([httpResponse responseStatus]  == 200){
        NSArray *messageList = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
        for (NSDictionary *messageDict in messageList){
            NSNumber *messageId = [messageDict valueForKey:@"messageId"];
            System_Message *messageEntity = [self fetchSystemMessageInfo:messageId withContext:YES];
            if(messageEntity == nil)
                messageEntity = [NSEntityDescription insertNewObjectForEntityForName:@"System_Message" inManagedObjectContext:context];
            [messageEntity initWithDictionary:messageDict];
        }
        
        [RORContextUtils saveContext];
        [RORUserUtils saveLastUpdateTime:@"SystemMessageUpdateTime"];
    } else {
        NSLog(@"sync with host error: can't get sync message list. Status Code: %d", [httpResponse responseStatus]);
        return NO;
    }
    return YES;
}

+ (System_Message *)fetchSystemMessageInfo:(NSNumber *) messageId{
    return [self fetchSystemMessageInfo:messageId withContext:NO];
}

+ (System_Message *)fetchSystemMessageInfo:(NSNumber *) messageId withContext:(BOOL) needContext{
    
    NSString *table=@"System_Message";
    NSString *query = @"messageId = %@";
    NSArray *params = [NSArray arrayWithObjects:messageId, nil];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    if(!needContext){
        return [System_Message removeAssociateForEntity:(System_Message *) [fetchObject objectAtIndex:0]];
    }
    return  (System_Message *) [fetchObject objectAtIndex:0];
}

+ (void) saveSystimeTime:(NSString *)systemTime{
    NSMutableDictionary *userDict = [RORUserUtils getUserInfoPList];
    [userDict setValue:systemTime forKey:@"systemTime"];
    [RORUserUtils writeToUserInfoPList:userDict];
}



//open out
+ (NSString *)getSystemMessage:(NSNumber *)messageId {
   return [self getSystemMessage:messageId withRegion:nil];
}

//open out
+ (NSString *)getSystemMessage:(NSNumber *)messageId withRegion:(NSNumber *)region{
    NSString *result = @"";
    System_Message *message = [self fetchSystemMessageInfo:messageId];
    //if have no messages do sync
    if(message == nil){
        [self syncSystemMessage];
        message = [self fetchSystemMessageInfo:messageId];
    }
    //logic to return message
    if(message != nil){
        result = message.message;
        if(region != nil && [message.rule length] != 0){
            NSArray *messageArray = [message.message componentsSeparatedByString:@"|"];
            NSArray *ruleArray = [message.rule componentsSeparatedByString:@"|"];
            if([messageArray count] == [ruleArray count] && [ruleArray count] > 1){
                for (int i = 0; i< [ruleArray count]; i++)
                {
                    NSArray *ruleDetails = [(NSString *)[ruleArray objectAtIndex:i] componentsSeparatedByString:@","];
                    double left = ((NSNumber *)[ruleDetails objectAtIndex:0]).doubleValue;
                    double right = ((NSNumber *)[ruleDetails objectAtIndex:1]).doubleValue;
                    if(region.doubleValue <= right &&  region.doubleValue > left){
                        result = (NSString *)[messageArray objectAtIndex:i];
                    }
                }
            }
        }
    }
    //default value is empty
    return result;
}

//open out
+ (BOOL)syncRecommendApp{
    NSError *error = nil;
    NSManagedObjectContext *context = [RORContextUtils getShareContext];
    NSString *lastUpdateTime = [RORUserUtils getLastUpdateTime:@"RecommendLastUpdateTime"];
    
    RORHttpResponse *httpResponse =[RORSystemClientHandler getRecommendApp:lastUpdateTime];
    
    if ([httpResponse responseStatus]  == 200){
        NSArray *recommendList = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
        for (NSDictionary *recommendDict in recommendList){
            NSNumber *appId = [recommendDict valueForKey:@"appId"];
            Recommend_App *recommendEntity = [self fetchRecommedInfo:appId];
            if(recommendEntity == nil)
                recommendEntity = (Recommend_App *)[NSEntityDescription insertNewObjectForEntityForName:@"Recommend_App" inManagedObjectContext:context];
            [recommendEntity initWithDictionary:recommendDict];
        }
        
        [RORContextUtils saveContext];
        [RORUserUtils saveLastUpdateTime:@"RecommendLastUpdateTime"];
    } else {
        NSLog(@"sync with host error: can't get sync message list. Status Code: %d", [httpResponse responseStatus]);
        return NO;
    }
    return YES;
}

+ (Recommend_App *)fetchRecommedInfo:(NSNumber *) appId {
    NSString *table=@"Recommend_App";
    NSString *query = @"appId = %@";
    NSArray *params = [NSArray arrayWithObjects:appId, nil];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    return  (Recommend_App *) [fetchObject objectAtIndex:0];
}

//open out
+ (NSArray *)fetchAllRecommedInfo{
    
    NSString *table=@"Recommend_App";
    NSString *query = @"recommendStatus = %@";
    NSArray *params = [NSArray arrayWithObjects:[NSNumber numberWithInt:1], nil];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"sequence" ascending:YES];
    NSArray *sortParams = [NSArray arrayWithObject:sortDescriptor];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query withOrderBy:sortParams];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    NSMutableArray *recommendList = [[NSMutableArray alloc] init];
    for (Recommend_App *recommed in fetchObject) {
        Recommend_App *newrecommed = [Recommend_App removeAssociateForEntity:recommed];
        [recommendList addObject:newrecommed];
    }
    return [recommendList copy];
}

//open out
+ (BOOL)syncActionDefine{
    NSError *error = nil;
    NSManagedObjectContext *context = [RORContextUtils getShareContext];
    NSString *lastUpdateTime = [RORUserUtils getLastUpdateTime:@"ActionDefineLastUpdateTime"];
    
    RORHttpResponse *httpResponse =[RORSystemClientHandler getActionDefine:lastUpdateTime];
    
    if ([httpResponse responseStatus]  == 200){
        NSArray *actionList = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
        for (NSDictionary *actionDict in actionList){
            NSNumber *actionId = [actionDict valueForKey:@"actionId"];
            Action_Define *actionEntity = [self fetchActionDefine:actionId];
            if(actionEntity == nil)
                actionEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Action_Define" inManagedObjectContext:context];
            [actionEntity initWithDictionary:actionDict];
        }
        
        [RORContextUtils saveContext];
        [RORUserUtils saveLastUpdateTime:@"ActionDefineLastUpdateTime"];
    } else {
        NSLog(@"sync with host error: can't get sync action define. Status Code: %d", [httpResponse responseStatus]);
        return NO;
    }
    return YES;
}

+ (Action_Define *)fetchActionDefine:(NSNumber *) actionId {
    NSString *table=@"Action_Define";
    NSString *query = @"actionId = %@";
    NSArray *params = [NSArray arrayWithObjects:actionId, nil];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    return  (Action_Define *) [fetchObject objectAtIndex:0];
}

//open out
+ (NSArray *)fetchAllActionDefine:(ActionDefineEnum) actionType{
    NSString *table=@"Action_Define";
    NSString *query = @"actionType = %@ and inUsing = 0";
    NSArray *params = [NSArray arrayWithObjects:[NSNumber numberWithInteger:(NSInteger)actionType], nil];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"triggerProbability" ascending:YES];
    NSArray *sortParams = [NSArray arrayWithObject:sortDescriptor];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query withOrderBy:sortParams];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    NSMutableArray *actionList = [[NSMutableArray alloc] init];
    for (Action_Define *actionDefine in fetchObject) {
        Action_Define *newAction = [Action_Define removeAssociateForEntity:actionDefine];
        [actionList addObject:newAction];
    }
    return [actionList copy];
}

//open out
+(Action_Define *)fetchActionDefineByPropId:(NSNumber *)propId{
    NSArray *actionList = [self fetchAllActionDefine:ActionDefineUse];
    NSMutableArray * findActionList = [[NSMutableArray alloc] init];
    for (Action_Define *action in actionList) {
        NSMutableDictionary *actionDic = [RORUtils explainActionRule:action.actionRule];
        for (NSString *key in [actionDic allKeys]) {
            if([RORDBCommon getNumberFromId:key].integerValue == propId.integerValue){
                [findActionList addObject: action];
            }
        }
    }
    srand(time(NULL));
    int randomValue = rand();
    if ([findActionList count]>0){
        int index = randomValue%[findActionList count];
        return [findActionList objectAtIndex:index];
    }
    return nil;
}

+(NSArray *)getEventListFromString:(NSString *)eventString{
    NSMutableArray *eventList = [[NSMutableArray alloc]init];
    NSMutableArray *eventTimeList = [[NSMutableArray alloc]init];
    NSArray *eventIdStringList = [eventString componentsSeparatedByString:@"|"];
    for (int i=0; i<eventIdStringList.count; i++){
        NSString *eventString = (NSString *)[eventIdStringList objectAtIndex:i];
        NSArray *eventStringSep = [eventString componentsSeparatedByString:@","];
        if (eventStringSep.count == 2){
            NSNumber *eventTime = [RORDBCommon getNumberFromId:[eventStringSep objectAtIndex:0]];
            NSNumber *eventId = [RORDBCommon getNumberFromId:[eventStringSep objectAtIndex:1]];
            if (eventId) {
                [eventList addObject:[self fetchActionDefine:eventId]];
            }
            if (eventTime){
                [eventTimeList addObject:eventTime];
            }
        }
    }
    return [NSArray arrayWithObjects:eventTimeList, eventList, nil];
}

+ (NSString *)getStringFromEventList:(NSArray *)eventList andTimeList:(NSArray *)timeList{
    NSMutableString *eventString = [[NSMutableString alloc]init];
    for (int i=0; i<eventList.count; i++){
        Action_Define *event = (Action_Define *)[eventList objectAtIndex:i];
        NSNumber *happendTime = (NSNumber *)[timeList objectAtIndex:i];
        [eventString appendString:[NSString stringWithFormat:@"%@,%@|", happendTime ,event.actionId]];
    }
    return eventString;
}

+ (NSString *)getPropgetStringFromList:(NSArray *)eventList{
    NSMutableString *propgetString = [[NSMutableString alloc]init];
    NSMutableDictionary *itemDict = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *attrDict = [[NSMutableDictionary alloc]init];
    
    for (int i=0; i<eventList.count; i++){
        Action_Define *event = (Action_Define *)[eventList objectAtIndex:i];
        NSDictionary *effectDict = [RORUtils explainActionEffetiveRule:event.effectiveRule];
        for (NSString *key in [effectDict allKeys]){
            NSNumber *n = [RORDBCommon getNumberFromId:[effectDict objectForKey:key]];
            NSNumber *current = [RORDBCommon getNumberFromId:[attrDict objectForKey:key]];
            if (current) {
                [attrDict setObject:[NSNumber numberWithInteger:current.integerValue + n.integerValue] forKey:key];
            } else {
                [attrDict setObject:n forKey:key];
            }
        }
        NSDictionary *actionDict = [RORUtils explainActionRule:event.actionRule];
        for (NSString *key in [actionDict allKeys]){
            NSNumber *n = [RORDBCommon getNumberFromId:[effectDict objectForKey:key]];
            NSNumber *current = [RORDBCommon getNumberFromId:[itemDict objectForKey:key]];
            if (current) {
                [itemDict setObject:[NSNumber numberWithInteger:current.integerValue + n.integerValue] forKey:key];
            } else {
                [itemDict setObject:n forKey:key];
            }
        }
    }
    [propgetString appendString:@"属性变化："];
    NSDictionary *attrNameDict = [NSDictionary dictionaryWithObjectsAndKeys:@"肥肉", @"F", @"健康", @"H", nil];
    for (NSString *key in [attrDict allKeys]){
        if (![[attrNameDict allKeys] containsObject:key])
            continue;
        NSNumber *num = [attrDict objectForKey:key];
        if (num>0){
            [propgetString appendString:[NSString stringWithFormat:@"%@ +%@  ",[attrNameDict objectForKey:key] ,num]];
        } else {
            [propgetString appendString:[NSString stringWithFormat:@"%@ %@  ",[attrNameDict objectForKey:key] ,num]];
        }
    }
    [propgetString appendString:@"|获得道具："];
    for (NSString *key in [itemDict allKeys]){
        NSNumber *num = [itemDict objectForKey:key];
        Virtual_Product *item = [RORVirtualProductService fetchVProduct:[RORDBCommon getNumberFromId:key]];
        [propgetString appendString:[NSString stringWithFormat:@"%@ x%@ ",item.productName, num]];
    }
    [propgetString appendString:@"|获得金币："];
    [propgetString appendString:[NSString stringWithFormat:@"%@",[attrDict objectForKey:ACTION_RULE_MONEY]]];
    
    return propgetString;
}

+ (NSArray *)getPropgetListFromString:(NSString *)propgetString{
    NSArray *propgetStringList = [propgetString componentsSeparatedByString:@"|"];
    NSMutableDictionary *itemDict = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *attrDict = [[NSMutableDictionary alloc]init];
    NSArray *attrStringList = [((NSString *)[propgetStringList objectAtIndex:0]) componentsSeparatedByString:@" "];
    for (NSString *attrPairStringList in attrStringList){
        NSArray *attrPairList = [attrPairStringList componentsSeparatedByString:@","];
        NSString *key = [attrPairList objectAtIndex:0];
        NSString *value = [attrPairList objectAtIndex:1];
        [attrDict setObject:value forKey:key];
    }
    NSArray *itemStringList = [((NSString *)[propgetStringList objectAtIndex:1]) componentsSeparatedByString:@" "];
    for (NSString *attrPairStringList in itemStringList){
        NSArray *attrPairList = [attrPairStringList componentsSeparatedByString:@","];
        NSString *key = [attrPairList objectAtIndex:0];
        NSString *value = [attrPairList objectAtIndex:1];
        [itemDict setObject:value forKey:key];
    }
    
    return [NSArray arrayWithObjects:attrDict, itemDict, nil];
}
@end
