//
//  UIUtils.h
//  WalkFun
//
//  Created by Bjorn on 14-3-11.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIUtils : NSObject

+ (void**)getImageData:(UIImage *)image ;
+ (UIImage*) grayscale:(UIImage*)anImage type:(char)type;

@end
