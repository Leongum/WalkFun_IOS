//
//  INDeviceStatus.h
//  InertiaNavigation
//
//  Created by Bjorn on 13-7-19.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>
#import "INConstant.h"
#import "INMatrix.h"

@interface INDeviceStatus : NSObject

@property (strong, nonatomic) CMDeviceMotion *deviceMotion;
@property (nonatomic) vec_3 Vn;
@property (nonatomic) vec_3 an;
@property (nonatomic) double V_sca;
@property (nonatomic) vec_3 Dist;
@property (strong, nonatomic) CMAccelerometerData *accData;
@property (nonatomic) NSInteger timeTag;
@property (nonatomic) double ab_mod;
@property (nonatomic) double rb_mod;
@property (nonatomic) BOOL isStill;

-(id)initWithDeviceMotion:(CMDeviceMotion *)dMotion;
-(id)initWithDeviceMotion:(CMDeviceMotion *)dMotion OldVn:(vec_3)oldVn;
-(CLLocationCoordinate2D)getNewLocation:(CLLocationCoordinate2D )oldLocation;
-(BOOL)checkIsStill;//:(double)a_variance;
-(void)updateWithVn:(vec_3)oldVn;
+ (vec_3) getDistanceVectorBetweenLocation1:(CLLocation *)loc1 andLocation2:(CLLocation *)loc2;
+ (vec_3) getSpeedVectorBetweenLocation1:(CLLocation *)loc1 andLocation2:(CLLocation *)loc2 deltaTime:(double)t;
@end
