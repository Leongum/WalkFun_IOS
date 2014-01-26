//
//  RORFriendService.h
//  WalkFun
//
//  Created by leon on 14-1-26.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RORAppDelegate.h"
#import "RORContextUtils.h"
#import "RORHttpResponse.h"
#import "RORUserClientHandler.h"
#import "Friend.h"
#import "Friend_Sort.h"
#import "Action.h"

@interface RORFriendService : NSObject

//根据user id 和friend id来确定2者关注关系
+(Friend *)fetchUserFriend:(NSNumber *) userId withFriendId:(NSNumber *) friendId;

//同步获取关注列表
+(int)syncFriendFollows:(NSNumber *) userId;

//同步粉丝列表
+(int)syncFriendFans:(NSNumber *) userId;

//创建或者更新好友关系，必须同步完成，如果服务器同步失败，则失败
+(BOOL)createOrUpdateFriend:(Friend *)friend;

//获得好友排名
+(NSMutableArray *)fetchFriendSortList;

//获取好友初步信息
+(BOOL)syncFriendSort:(NSNumber *) userId;

//创建新的动作，必须同步完成，如果服务器同步失败，则失败
+(BOOL)createAction:(Action *)action;

//获得用户新增动作
+(int)syncActions:(NSNumber *) userId;

//获取本地用户动作
+(NSArray *)fetchUserAction:(NSNumber *) userId;
@end
