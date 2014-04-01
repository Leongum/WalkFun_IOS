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
    
    //用来存处理后图片像素的数组
    UInt8*newData = malloc(height*bytesPerRow + width*4);
    
    int x, y;
    
    colorSum[0][0].r = *(buffer+0);//red
    colorSum[0][0].g = *(buffer+1);//green
    colorSum[0][0].b = *(buffer+2);//blue
    for (y=1; y<height; y++) {
        UInt8 *tmp1 = buffer + y * bytesPerRow;
        colorSum[0][y].r = colorSum[0][y-1].r + *(tmp1+0);
        colorSum[0][y].g = colorSum[0][y-1].g + *(tmp1+1);
        colorSum[0][y].b = colorSum[0][y-1].b + *(tmp1+2);
    }
    for (x=1; x<width; x++) {
        UInt8 *tmp1 = buffer + x * 4;
        colorSum[x][0].r = colorSum[x-1][0].r + *(tmp1+0);
        colorSum[x][0].g = colorSum[x-1][0].g + *(tmp1+1);
        colorSum[x][0].b = colorSum[x-1][0].b + *(tmp1+2);
    }
    for (y = 1; y < height; y++) {
        for (x = 1; x < width; x++) {
            UInt8 *tmp1 = buffer + y * bytesPerRow + x * 4;
            colorSum[x][y].r = colorSum[x-1][y].r + colorSum[x][y-1].r + *(tmp1+0) - colorSum[x-1][y-1].r;
            colorSum[x][y].g = colorSum[x-1][y].g + colorSum[x][y-1].g + *(tmp1+1) - colorSum[x-1][y-1].g;
            colorSum[x][y].b = colorSum[x-1][y].b + colorSum[x][y-1].b + *(tmp1+2) - colorSum[x-1][y-1].b;
        }
    }
    for (y = 0; y < height; y++) {
        for (x = 0; x < width; x++) {
            UInt8 *tmp2;
            tmp2 = newData + y * bytesPerRow + x * 4;
            int tmpCount=0;
            NSInteger red=0,green=0,blue=0;
            int s = 3;//scale， 区域大小为(2*s+1)^2
            
            //计算区域内r,g,b各值总和
            int rightBottomX = ((x+s>=width)?width-1:x+s);
            int rightBottomY = ((y+s>=height)?height-1:y+s);
            red = colorSum[rightBottomX][rightBottomY].r +
                ((x-s-1<0 || y-s-1<0)?0:colorSum[x-s-1][y-s-1].r) -
                ((x-s-1<0)?0:colorSum[x-s-1][rightBottomY].r) -
                ((y-s-1<0)?0:colorSum[rightBottomX][y-s-1].r);
            green = colorSum[rightBottomX][rightBottomY].g +
                ((x-s-1<0 || y-s-1<0)?0:colorSum[x-s-1][y-s-1].g) -
                ((x-s-1<0)?0:colorSum[x-s-1][rightBottomY].g) -
                ((y-s-1<0)?0:colorSum[rightBottomX][y-s-1].g);
            blue = colorSum[rightBottomX][rightBottomY].b +
                ((x-s-1<0 || y-s-1<0)?0:colorSum[x-s-1][y-s-1].b) -
                ((x-s-1<0)?0:colorSum[x-s-1][rightBottomY].b) -
                ((y-s-1<0)?0:colorSum[rightBottomX][y-s-1].b);
            
            //计算区域内像素个数
            tmpCount = (2*s+1)*(2*s+1);
            int ofX=0, ofY=0;
            if (x+s>=width)
                ofX = x+s-width+1;
            if (x-s<0)
                ofX = 0-x+s;
            if (y+s>=height)
                ofY = y+s-height+1;
            if (y-s<0)
                ofY = 0-y+s;
            tmpCount = tmpCount - (2*s+1)*(ofX+ofY) + ofX*ofY;

            //算平均值
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

