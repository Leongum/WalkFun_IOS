//
//  RORVirtualProductService.h
//  WalkFun
//
//  Created by leon on 14-2-16.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Virtual_Product.h"
#import "RORAppDelegate.h"
#import "RORContextUtils.h"
#import "RORHttpResponse.h"
#import "RORVirtualProductClientHandler.h"

@interface RORVirtualProductService : NSObject

//根据道具ID获取道具的具体信息
+(Virtual_Product *)fetchVProduct:(NSNumber *) productId;

//同步虚拟道具信息
+ (BOOL)syncVProduct;

//查询本地所有道具的信息
+(NSArray *)fetchAllVProduct;

//返回item对应的图片，缓存到本地
+(UIImage *)getImageOf:(Virtual_Product *)item;
@end
