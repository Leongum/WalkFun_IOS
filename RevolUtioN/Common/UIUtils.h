//
//  UIUtils.h
//  WalkFun
//
//  Created by Bjorn on 14-3-11.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct{
    UInt64 r, g, b;
}colorType;

colorType colorSum[640][1136];

@interface UIUtils : NSObject


+ (UIImage*) grayscale:(UIImage*)anImage type:(char)type;

+(UIImage *)getFightImageByStage:(NSNumber *)fightStage;

@end
