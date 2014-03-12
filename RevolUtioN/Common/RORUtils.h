//
//  RORUtils.h
//  RevolUtioN
//
//  Created by leon on 13-7-7.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "zlib.h" 
#import "RORAppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import "RORConstant.h"
#import "RORSystemService.h"
#import "RORDBCommon.h"
#import "RORShareCoverViewController.h"
#import "RORSystemService.h"


#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

@interface RORUtils : NSObject

+ (NSString *)transSecondToStandardFormat:(double) seconds;

+ (NSDate *)getDateFromString:(NSString *) date;

+ (NSString *)getStringFromDate:(NSDate *) date;

+ (NSString *)md5:(NSString *)str;

+ (NSString *)uuidString;

+ (NSData *)gzipCompressData:(NSData *)uncompressedData;

+ (NSString *)toJsonFormObject:(NSObject *)object;

+ (NSString*)getCityCodeJSon;

+ (NSString *)getCitycodeByCityname:(NSString *)cityName withProvince:(NSString *)provinceName;

+ (NSString*)outputDistance:(double)distance;

+ (NSString *)formattedSteps:(NSInteger)stepCount;

+(void)setFontFamily:(NSString*)fontFamily forView:(UIView*)view andSubViews:(BOOL)isSubViews;

+(void)setSystemFontSize:(double)fontSize forView:(UIView*)view andSubViews:(BOOL)isSubViews;

//help finding out new added fonts
+(void)listFontFamilies;

+(double)randomBetween:(NSInteger)x1 and:(NSInteger)x2;

+ (int)convertToInt:(NSString*)strtemp;

+(NSString *)addEggache:(NSNumber *)userID;

+(NSNumber *)removeEggache:(NSString *)userID;

+(UIImage *)getImageFromView:(UIView *)thisView;
+(UIImage *) captureScreen;

+(UIViewController *)popShareCoverViewFor:(UIViewController *)delegate withImage:(UIImage *)image title:(NSString *)title andMessage:(NSString *)msg animated:(BOOL)animated;

//解析actio的definition 的effective rule
+(NSMutableDictionary *)explainActionEffetiveRule:(NSString *)effectiveRule;

//解析actio的definition 的action rule
+(NSMutableDictionary *)explainActionRule:(NSString *)actionRule;

//两个date之间相差多少天的字条串
+(NSInteger)daysBetweenDate1:(NSDate*)date1 andDate2:(NSDate*)date2;
@end
