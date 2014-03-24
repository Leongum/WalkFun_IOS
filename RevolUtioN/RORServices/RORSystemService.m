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

+ (void) saveSystimeTime:(NSString *)systemTime{
    NSMutableDictionary *userDict = [RORUserUtils getUserInfoPList];
    [userDict setValue:systemTime forKey:@"systemTime"];
    [RORUserUtils writeToUserInfoPList:userDict];
}

//open out
+ (BOOL)syncFightDefine{
    NSError *error = nil;
    NSManagedObjectContext *context = [RORContextUtils getShareContext];
    NSString *lastUpdateTime = [RORUserUtils getLastUpdateTime:@"FightDefineLastUpdateTime"];
    
    RORHttpResponse *httpResponse =[RORSystemClientHandler getFightDefine:lastUpdateTime];
    
    if ([httpResponse responseStatus]  == 200){
        NSArray *fightDefineList = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
        for (NSDictionary *fightDict in fightDefineList){
            NSNumber *fightId = [fightDict valueForKey:@"id"];
            Fight_Define *fightEntity = [self fetchFightDefineInfo:fightId withContext:YES];
            if(fightEntity == nil)
                fightEntity = (Fight_Define *)[NSEntityDescription insertNewObjectForEntityForName:@"Fight_Define" inManagedObjectContext:context];
            [fightEntity initWithDictionary:fightDict];
        }
        
        [RORContextUtils saveContext];
        [RORUserUtils saveLastUpdateTime:@"FightDefineLastUpdateTime"];
    } else {
        NSLog(@"sync with host error: can't get sync fight define list. Status Code: %d", [httpResponse responseStatus]);
        return NO;
    }
    return YES;
}

//open out
+ (Fight_Define *)fetchFightDefineInfo:(NSNumber *) fightId {
    return [self fetchFightDefineInfo:fightId withContext:NO];
}

+ (Fight_Define *)fetchFightDefineInfo:(NSNumber *) appId withContext:(BOOL) needContext{
    NSString *table=@"Fight_Define";
    NSString *query = @"fightId = %@";
    NSArray *params = [NSArray arrayWithObjects:appId, nil];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    if (!needContext) {
        return [Fight_Define removeAssociateForEntity:(Fight_Define *) [fetchObject objectAtIndex:0]];
    }
    return  (Fight_Define *) [fetchObject objectAtIndex:0];
}

//open out
+ (NSArray *)fetchFightDefineByLevel:(NSNumber *) level{
    NSString *table=@"Fight_Define";
    NSString *query = @"maxLevelLimit <= %@ and minLevelLimit >= %@ and inUsing = 0";
    NSArray *params = [NSArray arrayWithObjects:level,level, nil];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"monsterMinFight" ascending:YES];
    NSArray *sortParams = [NSArray arrayWithObject:sortDescriptor];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query withOrderBy:sortParams];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    NSMutableArray *fightDefineList = [[NSMutableArray alloc] init];
    for (Fight_Define *fightDefine in fetchObject) {
        Fight_Define *newFight = [Fight_Define removeAssociateForEntity:fightDefine];
        [fightDefineList addObject:newFight];
    }
    return [fightDefineList copy];
}

//open out
+ (NSArray *)fetchFightDefineByLevel:(NSNumber *) level andStage:(NSNumber *) stage{
    NSString *table=@"Fight_Define";
    NSString *query = @"maxLevelLimit >= %@ and minLevelLimit <= %@ and inUsing = 0 and monsterLevel = %@";
    NSArray *params = [NSArray arrayWithObjects:level,level, stage, nil];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"monsterMinFight" ascending:YES];
    NSArray *sortParams = [NSArray arrayWithObject:sortDescriptor];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query withOrderBy:sortParams];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    NSMutableArray *fightDefineList = [[NSMutableArray alloc] init];
    for (Fight_Define *fightDefine in fetchObject) {
        Fight_Define *newFight = [Fight_Define removeAssociateForEntity:fightDefine];
        [fightDefineList addObject:newFight];
    }
    return [fightDefineList copy];
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

//open out
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
    NSMutableArray *eventLocationList = [[NSMutableArray alloc]init];
    NSArray *eventIdStringList = [eventString componentsSeparatedByString:@"|"];
    for (int i=0; i<eventIdStringList.count; i++){
        NSString *eventString = (NSString *)[eventIdStringList objectAtIndex:i];
        NSArray *eventStringSep = [eventString componentsSeparatedByString:@","];
        if (eventStringSep.count >= 2){
            NSNumber *eventTime = [RORDBCommon getNumberFromId:[eventStringSep objectAtIndex:0]];
            NSNumber *eventId = [RORDBCommon getNumberFromId:[eventStringSep objectAtIndex:1]];
            if (eventId) {
                [eventList addObject:[self fetchActionDefine:eventId]];
            }
            if (eventTime){
                [eventTimeList addObject:eventTime];
            }
            if (eventStringSep.count >=4){
                NSNumber *lati = [RORDBCommon getNumberFromId:[eventStringSep objectAtIndex:2]];
                NSNumber *longi = [RORDBCommon getNumberFromId: [eventStringSep objectAtIndex:3]];
                if (lati && longi){
                    [eventLocationList addObject:[[CLLocation alloc]initWithLatitude:lati.doubleValue longitude:longi.doubleValue]];
                }
            }
        }
    }
    return [NSArray arrayWithObjects:eventTimeList, eventList, eventLocationList, nil];
}

+ (NSString *)getStringFromEventList:(NSArray *)eventList timeList:(NSArray *)timeList andLocationList:(NSArray *)locationList{
//    NSMutableString *eventString = [[NSMutableString alloc]init];
//    for (int i=0; i<eventList.count; i++){
//        Walk_Event *event = (Walk_Event *)[eventList objectAtIndex:i];
////        if ([[eventList objectAtIndex:i] isKindOfClass:[Action_Define class]]){
////            Action_Define *event = (Action_Define *)[eventList objectAtIndex:i];
//            NSNumber *happendTime = (NSNumber *)[timeList objectAtIndex:i];
//            NSString *locationString = (NSString *)[locationList objectAtIndex:i ];
//            [eventString appendString:[NSString stringWithFormat:@"%@,%@,%@,%@|",RULE_Type_Action, happendTime ,event.actionId, locationString]];
//        } else {
//            Fight_Define *event = (Fight_Define *)[eventList objectAtIndex:i];
//            NSNumber *happendTime = (NSNumber *)[timeList objectAtIndex:i];
//            NSString *locationString = (NSString *)[locationList objectAtIndex:i ];
////            [eventString appendString:[NSString stringWithFormat:@"%@,%@,%@,%@,%@|",RULE_Type_Fight, happendTime,event. ,event.fightId, locationString]];
//        }
//        [RORUtils toJsonFormObject:eventList];
//    }
    return [RORUtils toJsonFormObject:eventList];
}

+ (NSString *)getPropgetStringFromList:(NSArray *)eventList{
    NSMutableString *propgetString = [[NSMutableString alloc]init];
    NSMutableDictionary *itemDict = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *attrDict = [[NSMutableDictionary alloc]init];
    int winCount = 0, fightCount = 0;
    
    for (int i=0; i<eventList.count; i++){
        Walk_Event *we = (Walk_Event *)[eventList objectAtIndex:i];
        if ([we.eType isEqualToString:RULE_Type_Action]){//事件
            Action_Define *actionEvent = [RORSystemService fetchActionDefine:we.eId];
//            NSDictionary *effectDict = [RORUtils explainActionEffetiveRule:actionEvent.effectiveRule];
//            for (NSString *key in [effectDict allKeys]){
//                NSNumber *n = [RORDBCommon getNumberFromId:[effectDict objectForKey:key]];
//                NSNumber *current = [RORDBCommon getNumberFromId:[attrDict objectForKey:key]];
//                if (current) {
//                    [attrDict setObject:[NSNumber numberWithInteger:current.integerValue + n.integerValue] forKey:key];
//                } else {
//                    [attrDict setObject:n forKey:key];
//                }
//            }
            NSDictionary *actionDict = [RORUtils explainActionRule:actionEvent.actionRule];
            for (NSString *key in [actionDict allKeys]){
                NSNumber *n = [RORDBCommon getNumberFromId:[actionDict objectForKey:key]];
                NSNumber *current = [RORDBCommon getNumberFromId:[itemDict objectForKey:key]];
                if (current) {
                    [itemDict setObject:[NSNumber numberWithInteger:current.integerValue + n.integerValue] forKey:key];
                } else {
                    [itemDict setObject:n forKey:key];
                }
            }
        } else{ //战斗
            Fight_Define *fightEvent = [RORSystemService fetchFightDefineInfo:we.eId];
            NSDictionary *actionDict = [RORUtils explainActionRule:fightEvent.winGotRule];
            for (NSString *key in [actionDict allKeys]){
                NSNumber *n = [RORDBCommon getNumberFromId:[actionDict objectForKey:key]];
                NSNumber *current = [RORDBCommon getNumberFromId:[itemDict objectForKey:key]];
                if (current) {
                    [itemDict setObject:[NSNumber numberWithInteger:current.integerValue + n.integerValue] forKey:key];
                } else {
                    [itemDict setObject:n forKey:key];
                }
            }
            fightCount ++;
            winCount+=we.eWin.integerValue;
        }
    }
    [propgetString appendString:[NSString stringWithFormat:@"%d|", winCount]];
    for (NSString *key in [itemDict allKeys]){
        NSNumber *num = [itemDict objectForKey:key];
        Virtual_Product *item = [RORVirtualProductService fetchVProduct:[RORDBCommon getNumberFromId:key]];
        [propgetString appendString:[NSString stringWithFormat:@"%@x%@ ",item.productName, num]];
    }
//    [propgetString appendString:@"|"];
//    [propgetString appendString:[NSString stringWithFormat:@"%@",[attrDict objectForKey:RULE_Money]]];
    
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
