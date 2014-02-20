//
//  RORMessages.h
//  RevolUtioN
//
//  Created by leon on 13-9-11.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RORSystemService.h"

#ifndef messages

#define CONNECTION_ERROR [RORSystemService getSystemMessage:[NSNumber numberWithDouble:1]]
#define LOGIN_ERROR [RORSystemService getSystemMessage:[NSNumber numberWithDouble:2]]
#define REGISTER_SUCCESS [RORSystemService getSystemMessage:[NSNumber numberWithDouble:3]]
#define REGISTER_FAIL [RORSystemService getSystemMessage:[NSNumber numberWithDouble:4]]
#define LOGIN_INPUT_CHECK [RORSystemService getSystemMessage:[NSNumber numberWithDouble:5]]
#define REGISTER_INPUT_CHECK [RORSystemService getSystemMessage:[NSNumber numberWithDouble:6]]
#define CONNECTION_ERROR_CONTECT [RORSystemService getSystemMessage:[NSNumber numberWithDouble:7]]
#define SYNC_DATA_SUCCESS [RORSystemService getSystemMessage:[NSNumber numberWithDouble:8]]
#define SYNC_DATA_FAIL [RORSystemService getSystemMessage:[NSNumber numberWithDouble:9]]
#define SYNC_MODE_ALL [RORSystemService getSystemMessage:[NSNumber numberWithDouble:10]]
#define SYNC_MODE_WIFI [RORSystemService getSystemMessage:[NSNumber numberWithDouble:11]]
#define SHARE_TO_PLATFORM_LIST [RORSystemService getSystemMessage:[NSNumber numberWithDouble:12]]
#define SNS_BIND_ERROR [RORSystemService getSystemMessage:[NSNumber numberWithDouble:13]]
#define SELECT_SHARE_PLATFORM_ERROR [RORSystemService getSystemMessage:[NSNumber numberWithDouble:14]]
#define SHARE_DEFAULT_CONTENT [RORSystemService getSystemMessage:[NSNumber numberWithDouble:15]]
#define SHARE_DEFAULT_TITLE [RORSystemService getSystemMessage:[NSNumber numberWithDouble:16]]
#define SHARE_DEFAULT_URL [RORSystemService getSystemMessage:[NSNumber numberWithDouble:17]]
#define SHARE_DEFAULT_DESCRIPTION [RORSystemService getSystemMessage:[NSNumber numberWithDouble:18]]
#define SHARE_SUBMITTED [RORSystemService getSystemMessage:[NSNumber numberWithDouble:19]]
#define NO_HISTORY [RORSystemService getSystemMessage:[NSNumber numberWithDouble:20]]
#define GPS_SETTING_ERROR [RORSystemService getSystemMessage:[NSNumber numberWithDouble:21]]
#define STATISTICS_DISTANCE_MESSAGE(region) [RORSystemService getSystemMessage:[NSNumber numberWithDouble:22] withRegion:(region)]
#define STATISTICS_SPEED_MESSAGE(region) [RORSystemService getSystemMessage:[NSNumber numberWithDouble:23] withRegion:(region)]
#define STATISTICS_CALORIE_MESSAGE(region) [RORSystemService getSystemMessage:[NSNumber numberWithDouble:24] withRegion:(region)]

#define CANCEL_BUTTON @"知道啦！"
#define SEARCHING_LOCATION @"定位中..."
#define START_RUNNING_BUTTON @"开始"
#define CANCEL_RUNNING_BUTTON @"放弃"
#define FINISH_RUNNING_BUTTON @"完成"
#define PAUSSE_RUNNING_BUTTON @"歇会儿"
#define CONTINUE_RUNNING_BUTTON @"继续"
#define ALERT_VIEW_TITEL @"提示"
#define LOGOUT_ALERT_TITLE @"注销"
#define LOGOUT_ALERT_CONTENT @"确定要注销吗？"
#define CANCEL_BUTTON_CANCEL @"取消"
#define OK_BUTTON_OK @"确定"

#endif

@interface RORMessages : NSObject

@end
