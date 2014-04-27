//
//  RORUtils.m
//  RevolUtioN
//
//  Created by leon on 13-7-7.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORUtils.h"
#import <CommonCrypto/CommonDigest.h>

@implementation RORUtils

+ (NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0],result[1],result[2],result[3],
            result[4],result[5],result[6],result[7],
            result[8],result[9],result[10],result[11],
            result[12],result[13],result[14],result[15]];
}

+ (NSString *)uuidString {
    // Returns a UUID
    
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidStr = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    CFRelease(uuid);
    
    return uuidStr;
}

+ (NSString *)transSecondToStandardFormat:(double) seconds {
    if (seconds <0)
        return @" -";
    int min=0, hour=0;
    min = seconds / 60;
    int intSeconds = (NSInteger)seconds % 60;
    hour = min / 60;
    min = min % 60;
    if (hour>0)
        return [NSString stringWithFormat:@"%d小时%d分%d秒",hour, min, intSeconds];
    if (min>0)
        return [NSString stringWithFormat:@"%d分%d秒", min, intSeconds];
    return [NSString stringWithFormat:@"%d秒", intSeconds];
}

+ (NSString *)toJsonFormObject:(NSObject *)object{
    NSError *writeError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&writeError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",jsonString);
    return jsonString;
}

+ (NSArray *)toArrayFromJson:(NSString *)json{
    NSData *aData = [json dataUsingEncoding: NSUTF8StringEncoding];
    NSError *error = nil;
    NSArray *objList = [NSJSONSerialization JSONObjectWithData:aData options:NSJSONReadingMutableLeaves error:&error];
    
    if (!error){
        return objList;
    }
    return nil;
}

+ (NSString*)getCityCodeJSon{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CityCode" ofType:@"geojson"];
    return path;
}

+(NSDate *)getDateFromString:(NSString *) date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateFormat = [dateFormatter dateFromString: date];
    return dateFormat;
}

+(NSString *)getStringFromDate:(NSDate *) date{
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *formatDateString = [formate stringFromDate:date];
    return formatDateString;
}

+ (NSData*) gzipCompressData:(NSData*)pUncompressedData
{
    
	if (!pUncompressedData || [pUncompressedData length] == 0)
	{
		NSLog(@"%s: Error: Can't compress an empty or null NSData object.", __func__);
		return nil;
	}
    
    z_stream zlibStreamStruct;
	zlibStreamStruct.zalloc    = Z_NULL; // Set zalloc, zfree, and opaque to Z_NULL so
	zlibStreamStruct.zfree     = Z_NULL; // that when we call deflateInit2 they will be
	zlibStreamStruct.opaque    = Z_NULL; // updated to use default allocation functions.
	zlibStreamStruct.total_out = 0; // Total number of output bytes produced so far
	zlibStreamStruct.next_in   = (Bytef*)[pUncompressedData bytes]; // Pointer to input bytes
	zlibStreamStruct.avail_in  = [pUncompressedData length]; // Number of input bytes left to process
    
    int initError = deflateInit2(&zlibStreamStruct, Z_DEFAULT_COMPRESSION, Z_DEFLATED, (15+16), 8, Z_DEFAULT_STRATEGY);
	if (initError != Z_OK)
	{
		NSString *errorMsg = nil;
		switch (initError)
		{
			case Z_STREAM_ERROR:
				errorMsg = @"Invalid parameter passed in to function.";
				break;
			case Z_MEM_ERROR:
				errorMsg = @"Insufficient memory.";
				break;
			case Z_VERSION_ERROR:
				errorMsg = @"The version of zlib.h and the version of the library linked do not match.";
				break;
			default:
				errorMsg = @"Unknown error code.";
				break;
		}
		NSLog(@"%s: deflateInit2() Error: \"%@\" Message: \"%s\"", __func__, errorMsg, zlibStreamStruct.msg);
		return nil;
	}
    
	NSMutableData *compressedData = [NSMutableData dataWithLength:[pUncompressedData length] * 1.01 + 12];
    
	int deflateStatus = 0;
	do
	{
        if ((deflateStatus == Z_BUF_ERROR) || (zlibStreamStruct.total_out == [compressedData length])) {
			[compressedData increaseLengthBy:1024];
		}
		zlibStreamStruct.next_out = [compressedData mutableBytes] + zlibStreamStruct.total_out;
		zlibStreamStruct.avail_out = (unsigned int)[compressedData length] - zlibStreamStruct.total_out;
		deflateStatus = deflate(&zlibStreamStruct, Z_FINISH);
        
	} while ( deflateStatus == Z_OK || deflateStatus == Z_BUF_ERROR );
    
	if (deflateStatus != Z_STREAM_END)
	{
		NSString *errorMsg = nil;
		switch (deflateStatus)
		{
			case Z_ERRNO:
				errorMsg = @"Error occured while reading file.";
				break;
			case Z_STREAM_ERROR:
				errorMsg = @"The stream state was inconsistent (e.g., next_in or next_out was NULL).";
				break;
			case Z_DATA_ERROR:
				errorMsg = @"The deflate data was invalid or incomplete.";
				break;
			case Z_MEM_ERROR:
				errorMsg = @"Memory could not be allocated for processing.";
				break;
			case Z_BUF_ERROR:
				errorMsg = @"Ran out of output buffer for writing compressed bytes.";
				break;
			case Z_VERSION_ERROR:
				errorMsg = @"The version of zlib.h and the version of the library linked do not match.";
				break;
			default:
				errorMsg = @"Unknown error code.";
				break;
		}
		NSLog(@"%s: zlib error while attempting compression: \"%@\" Message: \"%s\"", __func__, errorMsg, zlibStreamStruct.msg);
        
		// Free data structures that were dynamically created for the stream.
		deflateEnd(&zlibStreamStruct);
        
		return nil;
	}
	// Free data structures that were dynamically created for the stream.
	deflateEnd(&zlibStreamStruct);
	[compressedData setLength: zlibStreamStruct.total_out];
	NSLog(@"%s: Compressed file from %d KB to %d KB", __func__, [pUncompressedData length]/1024, [compressedData length]/1024);
    
	return compressedData;
}

+(NSString *)getCitycodeByCityname:(NSString *)cityName withProvince:(NSString *)provinceName{
    if(cityName == nil)return nil;
    NSError *error;
    NSData *CityCodeJson = [NSData dataWithContentsOfFile:[RORUtils getCityCodeJSon]];
    NSDictionary *citycodeDic = [NSJSONSerialization JSONObjectWithData:CityCodeJson options:NSJSONReadingMutableLeaves error:&error];
    //    weatherDic字典中存放的数据也是字典型，从它里面通过键值取值
    NSArray *citycodeList = [citycodeDic objectForKey:@"城市代码"];
    NSString * defaultCityCode = nil;
    for (int i=0; i<citycodeList.count; i++){
        NSDictionary *prov = [citycodeList objectAtIndex:i];
        NSArray *cityList = [prov objectForKey:@"市"];
        for (int j=0; j<cityList.count; j++){
            NSDictionary *city = [cityList objectAtIndex:j];
            NSString *name = [city valueForKey:@"市名"];
            if ([cityName rangeOfString:name].location != NSNotFound){
                return [city valueForKey:@"编码"];
            }
            if ([provinceName rangeOfString:name].location != NSNotFound){
                defaultCityCode = [city valueForKey:@"编码"];
            }
        }
    }
    return defaultCityCode;
}

+(NSString*)outputDistance:(double)distance{
    if (distance<0)
        return @" -";
    if (distance<1000){
        return [NSString stringWithFormat:@"%.0f m", round(distance)];
    }
    return [NSString stringWithFormat:@"%.2f km", distance/1000];
}

+ (NSString *)formattedSteps:(NSInteger)stepCount{
    NSInteger outputStep;
    if (stepCount<1000)
        outputStep = round((double)stepCount/10.f)*10;
    else
        outputStep = round((double)stepCount/100.f)*100;

    return [NSString stringWithFormat:@"约%d步", outputStep];
}

+(void)setFontFamily:(NSString*)fontFamily forView:(UIView*)view andSubViews:(BOOL)isSubViews
{
    if ([view isKindOfClass:[UILabel class]])
    {
        UILabel *lbl = (UILabel *)view;
        [lbl setFont:[UIFont fontWithName:fontFamily size:[[lbl font] pointSize]]];
    }
    
    if ([view isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)view;
        [btn.titleLabel setFont:[UIFont fontWithName:fontFamily size:[[btn.titleLabel font] pointSize]]];
    }
    
    if (isSubViews)
    {
        for (UIView *sview in view.subviews)
        {
            [self setFontFamily:fontFamily forView:sview andSubViews:YES];
        }
    }
}

+(void)setSystemFontSize:(double)fontSize forView:(UIView*)view andSubViews:(BOOL)isSubViews
{
    if ([view isKindOfClass:[UILabel class]])
    {
        UILabel *lbl = (UILabel *)view;
        [lbl setFont:[UIFont systemFontOfSize:fontSize]];
    }
    
    if ([view isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)view;
        [btn.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
    }
    
    if (isSubViews)
    {
        for (UIView *sview in view.subviews)
        {
            [self setSystemFontSize:fontSize forView:sview andSubViews:YES];
        }
    }
}

+(void)listFontFamilies
{
    NSArray* familys = [UIFont familyNames];
    
    for (int i = 0; i<[familys count]; i++) {
        
        NSString* family = [familys objectAtIndex:i];
        
        NSLog(@"Fontfamily:%@=====",family);
        
        NSArray* fonts = [UIFont fontNamesForFamilyName:family];
        
        for (int j = 0; j<[fonts count]; j++) {
            
            NSLog(@"FontName:%@",[fonts objectAtIndex:j]);
            
        }
        
    }
}

+(double)randomBetween:(NSInteger)x1 and:(NSInteger)x2{
    return rand()%(x2-x1)+x1;
}

+ (int)convertToInt:(NSString*)strtemp
{
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return (strlength+1)/2;
}


+(UIImage *)getImageFromView:(UIView *)thisView{
    if(UIGraphicsBeginImageContextWithOptions != NULL)
    {
        UIGraphicsBeginImageContextWithOptions(thisView.frame.size, NO, 0.0);
    } else {
        UIGraphicsBeginImageContext(thisView.frame.size);
    }
    //获取图像
    [thisView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *) captureScreen {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect rect = [keyWindow bounds];
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [keyWindow.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGRect contentRectToCrop = CGRectMake(0, 0, image.size.width, image.size.height);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], contentRectToCrop);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return croppedImage;
}

+(UIViewController *)popShareCoverViewFor:(UIViewController *)delegate withImage:(UIImage *)image title:(NSString *)title andMessage:(NSString *)msg animated:(BOOL)animated{
    UIViewController *viewController = nil;
    
    for (UIViewController *vc in [delegate childViewControllers]){
        if ([vc isKindOfClass:[RORShareCoverViewController class]]) {
            viewController = vc;
            break;
        }
    }
    if (!viewController){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:[NSBundle mainBundle]];
        viewController =  [storyboard instantiateViewControllerWithIdentifier:@"shareCoverViewController"];
        UIImageView *bgImageView = (UIImageView *)[viewController.view viewWithTag:2];
        bgImageView.image = [UIUtils grayscale:[RORUtils captureScreen] type:1];
        CGRect frame = delegate.view.frame;
        frame.origin.x = 0;
        frame.origin.y = 0;
        viewController.view.frame = frame;
        [delegate addChildViewController:viewController];
        [delegate.view addSubview:viewController.view];
        [viewController didMoveToParentViewController:delegate];
    }
    [viewController setValue:image forKey:@"shareImage"];
    [viewController setValue:msg forKey:@"shareMessage"];
    [viewController setValue:title forKey:@"shareTitle"];
    
    viewController.view.alpha = 1;
    return viewController;
}

+(NSMutableDictionary *)explainActionEffetiveRule:(NSString *)effectiveRule{
    NSMutableDictionary * userStatusMap = [[NSMutableDictionary alloc] init];
    if(effectiveRule != nil && [effectiveRule length] != 0 ){
        NSArray *ruleArray = [effectiveRule componentsSeparatedByString:@"|"];
        if([ruleArray count] > 0){
            for (int i = 0; i< [ruleArray count]; i++)
            {
                NSArray *ruleDetails = [(NSString *)[ruleArray objectAtIndex:i] componentsSeparatedByString:@","];
                if(ruleDetails != nil && [ruleDetails count] == 2){
                    NSString *effectiveName = (NSString *)[ruleDetails objectAtIndex:0];
                    NSNumber *numb = (NSNumber *)[ruleDetails objectAtIndex:1];
                    [userStatusMap setValue:numb forKey:effectiveName];
                }
            }
        }
    }
    return userStatusMap;
}

+(NSMutableDictionary *)explainActionRule:(NSString *)actionRule{
    NSMutableDictionary * vProductIds = [[NSMutableDictionary alloc] init];
    if(actionRule != nil && [actionRule length] != 0 ){
        NSArray *ruleArray = [actionRule componentsSeparatedByString:@"|"];
        if([ruleArray count] > 0){
            for (int i = 0; i< [ruleArray count]; i++)
            {
                NSArray *ruleDetails = [(NSString *)[ruleArray objectAtIndex:i] componentsSeparatedByString:@","];
                if(ruleDetails != nil && [ruleDetails count] >= 3){
                    NSString *productId = (NSString *)[ruleDetails objectAtIndex:0];
                    NSNumber *numb = (NSNumber *)[ruleDetails objectAtIndex:1];
                    NSString *propFlag = (NSString *)[ruleDetails objectAtIndex:2];
                    if([propFlag isEqualToString:RULE_Prop_Yes]){
                        [vProductIds setValue:numb forKey:productId];
                    }
                }
            }
        }
    }
    return vProductIds;
}

+(NSInteger)daysBetweenDate1:(NSDate*)date1 andDate2:(NSDate*)date2{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *components = [gregorian components:unitFlags fromDate:date1 toDate:date2 options:0];
    NSInteger months = [components month];
    NSInteger days = [components day];
    if (months<1){
        return days;
    }
    return [date2 timeIntervalSinceDate:date1]/86400;
}

+(BOOL)isTheDay:(NSDate *)day1 equalTo:(NSDate *)day2{
    NSDateFormatter *formattter = [[NSDateFormatter alloc] init];
    [formattter setDateFormat:@"yyyyMMdd"];
    NSString *day1String = [formattter stringFromDate:day1];
    NSString *day2String = [formattter stringFromDate:day2];
    return [day1String isEqualToString:day2String];
}

+(NSString *)explainItemEffectString:(NSString *)originalString{
    NSMutableString *tmp = [[NSMutableString alloc]initWithString:originalString];
    [tmp replaceOccurrencesOfString:@"，" withString:@"\n" options:NSRegularExpressionSearch range:NSMakeRange(0, [tmp length])];
    return tmp;
}

+(UIImage *)getImageNamed:(NSString *)fileName{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    // If you go to the folder below, you will find those pictures
    NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@",docDir, fileName];
    
    UIImage *theImage = [UIImage imageNamed:fileName];
    if (!theImage){
        theImage = [UIImage imageWithContentsOfFile:pngFilePath];
    }
    if (!theImage) {
        NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICTURE_HOST_URL,fileName]];
        theImage = [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:imageUrl]];
        if (theImage){
            NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(theImage)];
            [data1 writeToFile:pngFilePath atomically:YES];
        }
    }
    return theImage;
}

+(NSString *)getRandomStringFromAllstrings:(NSString *)allString{
    NSArray *stringList = [allString componentsSeparatedByString:@"|"];
    return [stringList objectAtIndex:(arc4random() % stringList.count)];
}

+(NSString *)getSentencebyRule:(NSString *)rule eId10:(int)eId10 andSentence:(NSString *)allSentence{
    if ([rule isEqualToString:RULE_Type_Start]){
        NSArray *sentenceList = [allSentence componentsSeparatedByString:@"|"];
        NSString *theSentence = (NSString *)[sentenceList objectAtIndex:eId10];
        return theSentence;
    }
    return nil;
}

+(int)geteId10byRule:(NSString *)rule andSentence:(NSString *)allSentence{
    if ([rule isEqualToString:RULE_Type_Start]){
        NSArray *sentenceList = [allSentence componentsSeparatedByString:@"|"];
        return arc4random()%sentenceList.count;
    }
    return -1;
}

@end
