//
//  _qianSDK.h
//  0qianSDK
//
//  Created by Lorenz Cheung on 7/5/13.
//  Copyright (c) 2013 Jarkas Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LingQianSDK : NSObject

//Production Methods
+(void)didFinishLaunchingWithAppID:(NSString*)appID applicationSecret:(NSString*)appSecret;
+(void)trackActionWithName:(NSString*)actionName;
+(void)enable;
+(void)disable;
+(BOOL)isEnabled;
+(void)openRewardStore;

@end
