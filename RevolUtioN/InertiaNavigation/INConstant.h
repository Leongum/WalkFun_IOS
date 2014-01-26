//
//  INConstant.h
//  InertiaNavigation
//
//  Created by Bjorn on 13-7-19.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>

#define delta_T 0.05
#define MIN_STEP_TIME 0.2
#define THRESHOLD_GACC -1

#define earth_R 6378137.0
#define earth_Rn(L) earth_R*(1 - 2*M_E + 3*M_E*sin(L))
#define earth_Re(L) earth_R*(1+M_E*sin(L)*sin(L))
#define earth_G 9.81
#define earth_RAV 7.292115E-5

#define MIN_An 1
#define MIN_Rn 35
#define MIN_AnVar 0.1

@interface INConstant : NSObject

+ (double)degree2Radians:(double)degree;
+ (double)round100:(double)x;
+ (double)earth_Rn:(double)L;
+ (double)earth_Re:(double)L;
@end
