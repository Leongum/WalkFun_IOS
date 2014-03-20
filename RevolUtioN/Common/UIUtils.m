//
//  UIUtils.m
//  WalkFun
//
//  Created by Bjorn on 14-3-11.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "UIUtils.h"

@implementation UIUtils

+ (UIImage*) grayscale:(UIImage*)anImage type:(char)type {
    CGImageRef  imageRef;
    imageRef = anImage.CGImage;
    
    size_t width  = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    size_t                  bitsPerComponent;
    bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    
    size_t                  bitsPerPixel;
    bitsPerPixel = CGImageGetBitsPerPixel(imageRef);
    
    size_t                  bytesPerRow;
    bytesPerRow = CGImageGetBytesPerRow(imageRef);
    
    CGColorSpaceRef         colorSpace;
    colorSpace = CGImageGetColorSpace(imageRef);
    
    CGBitmapInfo            bitmapInfo;
    bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    bool                    shouldInterpolate;
    shouldInterpolate = CGImageGetShouldInterpolate(imageRef);
    
    CGColorRenderingIntent  intent;
    intent = CGImageGetRenderingIntent(imageRef);
    
    CGDataProviderRef   dataProvider;
    dataProvider = CGImageGetDataProvider(imageRef);
    
    CFDataRef   data;
    UInt8*      buffer;
    data = CGDataProviderCopyData(dataProvider);
    buffer = (UInt8*)CFDataGetBytePtr(data);
    for (int i=0; i<sizeof(buffer); i++){
        NSLog(@"%d ",buffer[i]);
    }
//    NSLog(@"%lu", sizeof(buffer));
    UInt8*newData = malloc(height*bytesPerRow + width*4);
    
    int x, y;
    
    for (y = 0; y < height; y++) {
        for (x = 0; x < width; x++) {
            UInt8 *tmp2;
            tmp2 = newData + y * bytesPerRow + x * 4;
            int tmpCount=0;
            NSInteger red=0,green=0,blue=0;
            int scale = 2;
            for (int i = (y-scale<0?0:y-scale); i <= (y+scale>height-1?height-1:y+scale); i++){
                for (int j = (x-scale<0?0:x-scale); j <= (x+scale>=width-1?width-1:x+scale); j++){
                    UInt8 *tmp1;
                    tmp1 = buffer + i * bytesPerRow + j * 4;
                    tmpCount++;
                    red+=*(tmp1 + 0);
                    green+=*(tmp1 + 1);
                    blue += *(tmp1 + 2);
                }
            }
            *(tmp2 + 0) = red/tmpCount;
            *(tmp2 + 1) = green/tmpCount;
            *(tmp2 + 2) = blue/tmpCount;
        }
    }

    for (y = 0; y < height; y++) {
        for (x = 0; x < width; x++) {
            UInt8 *tmp1,*tmp2;
            tmp1 = buffer + y * bytesPerRow + x * 4;
            tmp2 = newData + y * bytesPerRow + x * 4;
            
            UInt8 red,green,blue,alpha;
            red = *(tmp2 + 0);
            green = *(tmp2 + 1);
            blue = *(tmp2 + 2);
            alpha = *(tmp1 + 3);
            
            UInt8 brightness;
            
            switch (type) {
                case 1://モノクロ
                    // 輝度計算
                    brightness = (77 * red + 28 * green + 151 * blue) / 256;
                    *(tmp2 + 0) = brightness;
                    *(tmp2 + 1) = brightness;
                    *(tmp2 + 2) = brightness;
                    *(tmp2 + 3) = alpha;
                    break;
                    
                case 2://セピア
                    *(tmp2 + 0) = red;
                    *(tmp2 + 1) = green * 0.7;
                    *(tmp2 + 2) = blue * 0.4;
                    *(tmp2 + 3) = alpha;
                    break;
                    
                case 3://色反転
                    *(tmp2 + 0) = 255 - red;
                    *(tmp2 + 1) = 255 - green;
                    *(tmp2 + 2) = 255 - blue;
                    *(tmp2 + 3) = alpha;
                    break;
                    
                default:
                    *(tmp2 + 0) = red;
                    *(tmp2 + 1) = green;
                    *(tmp2 + 2) = blue;
                    *(tmp2 + 3) = alpha;
                    break;
            }
            
        }
    }
    
    // 効果を与えたデータ生成
    CFDataRef   effectedData;
    effectedData = CFDataCreate(NULL, newData, CFDataGetLength(data));

    // 効果を与えたデータプロバイダを生成
    CGDataProviderRef   effectedDataProvider;
    effectedDataProvider = CGDataProviderCreateWithCFData(effectedData);
    
    // 画像を生成
    CGImageRef  effectedCgImage;
    UIImage*    effectedImage;
    effectedCgImage = CGImageCreate(
                                    width, height,
                                    bitsPerComponent, bitsPerPixel, bytesPerRow,
                                    colorSpace, bitmapInfo, effectedDataProvider,
                                    NULL, shouldInterpolate, intent);
    effectedImage = [[UIImage alloc] initWithCGImage:effectedCgImage];
    
    // データの解放
    CGImageRelease(effectedCgImage);
    CFRelease(effectedDataProvider);
    CFRelease(effectedData);
    CFRelease(data);
    
    return effectedImage;
}
@end

