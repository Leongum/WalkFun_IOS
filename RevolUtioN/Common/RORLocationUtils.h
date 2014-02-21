//
//  RORLocationUtils.h
//  WalkFun
//
//  Created by Bjorn on 14-2-18.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define pi M_PI
#define a 6378245.0
#define ee 0.00669342162296594323

@interface RORLocationUtils : NSObject{
}

+(CLLocationCoordinate2D)transformFromWGSToGCJ:(CLLocationCoordinate2D)wgsLoc;

@end
