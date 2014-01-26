//
//  INConstant.m
//  InertiaNavigation
//
//  Created by Bjorn on 13-7-19.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "INConstant.h"

@implementation INConstant

+ (double)round100:(double)x{
    x *= 10;
    x = round(x);
    return x / 10;
}

+ (double)degree2Radians:(double)degree{
    return degree/180*M_PI;
}

+ (double)earth_Rn:(double)L{
    return earth_R*(1 - 2*M_E + 3*M_E*sin([self degree2Radians:L]));
}

+ (double)earth_Re:(double)L{
    return earth_R*(1+M_E*sin(L)*sin([self degree2Radians:L]));
}

@end
