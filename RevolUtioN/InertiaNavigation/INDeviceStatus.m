//
//  INDeviceStatus.m
//  InertiaNavigation
//
//  Created by Bjorn on 13-7-19.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "INDeviceStatus.h"

@implementation INDeviceStatus
@synthesize deviceMotion, Vn, an, Dist, V_sca, accData, isStill;
@synthesize timeTag, ab_mod, rb_mod;

-(id)initWithDeviceMotion:(CMDeviceMotion *)dMotion{
    deviceMotion = dMotion;
    [self initial];
    return self;
}

-(id)initWithDeviceMotion:(CMDeviceMotion *)dMotion OldVn:(vec_3)oldVn{
    deviceMotion = dMotion;
    [self initial];
    [self updateWithVn:oldVn];
    return self;
}

-(void)initial{
    isStill = NO;
    timeTag = 0;
    
    CMRotationMatrix R = deviceMotion.attitude.rotationMatrix;
//    NSLog(@"\n%.2f, %.2f, %.2f\n%.2f, %.2f, %.2f\n%.2f, %.2f, %.2f", R.m11, R.m12, R.m13, R.m21, R.m22, R.m23, R.m31, R.m32, R.m33);
    
    vec_3 ab;
    //    ab.v1 = accData.acceleration.x;
    //    ab.v2 = accData.acceleration.y;
    //    ab.v3 = accData.acceleration.z;
    
    ab.v1 = -deviceMotion.userAcceleration.x * earth_G;
    ab.v2 = -deviceMotion.userAcceleration.y * earth_G;
    ab.v3 = deviceMotion.userAcceleration.z * earth_G;
    ab_mod = [INMatrix modOfVec_3:ab];
    
    vec_3 rb;
    
    rb.v1 = deviceMotion.rotationRate.x ;
    rb.v2 = deviceMotion.rotationRate.y;
    rb.v3 = deviceMotion.rotationRate.z;
    rb_mod = [INMatrix modOfVec_3:rb];
    //    ab = [INMatrix round100Vec_3:ab];
    //    if (abs(ab.v1)>0.2)
    //        NSLog(@"\n%.2f, %.2f, %.2f", ab.v1, ab.v2, ab.v3);
    an = [INMatrix multiplyRotationMatrix:R withVector:ab];
    //    an = [INMatrix round100Vec_3:an];
    //    if (abs(an.v1)>0.2)
//    NSLog(@"\n%.2f, %.2f, %.2f\n%.2f, %.2f, %.2f", ab.v1, ab.v2, ab.v3, an.v1, an.v2, an.v3);
}

-(void)updateWithVn:(vec_3)oldVn{
    if (!isStill){
        Vn.v1 = an.v1 * delta_T + oldVn.v1;
        Vn.v2 = an.v2 * delta_T + oldVn.v2;
        Vn.v3 = an.v3 * delta_T + oldVn.v3;
    //    Vn = [INMatrix round100Vec_3:Vn];
        //init distance
    } else {
        Vn.v1 = 0;
        Vn.v2 = 0;
        Vn.v3 = 0;
    }

    Dist.v1 = Vn.v1 *delta_T;
    Dist.v2 = Vn.v2 *delta_T;
    Dist.v3 = Vn.v3 *delta_T;
    
    V_sca = sqrt(Vn.v1 * Vn.v1 + Vn.v2 * Vn.v2);
//    Dist = V_sca * delta_T;
}

-(BOOL)checkIsStill{//:(double)a_variance{
    if (ab_mod < MIN_An && rb_mod < [INConstant degree2Radians:MIN_Rn]
//        && a_variance < MIN_AnVar
        ){
        isStill = YES;
        return YES;
    }
    else {
        isStill = NO;
        return NO;
    }
}

-(CLLocationCoordinate2D)getNewLocation:(CLLocationCoordinate2D )oldLocation{
    double lati, longi;
    double Rn = [INConstant earth_Rn:oldLocation.latitude];//(earth_Rn + oldLocation.altitude);
    double Re = [INConstant earth_Re:oldLocation.latitude];
    
    lati = oldLocation.latitude +
        (Vn.v1 * delta_T * 180) / (Rn * M_PI);
//    NSLog(@"\n,%f, %f",(Vn.v1 * delta_T * 180) / (Rn * M_PI), (Vn.v2 * delta_T * 180) / (Re * cos([INConstant degree2Radians:lati]) * M_PI));
    longi = oldLocation.longitude +
        (Vn.v2 * delta_T * 180) / (Re * cos([INConstant degree2Radians:lati]) * M_PI);
    CLLocationCoordinate2D result;
    result.latitude = lati;
    result.longitude = longi;
    
    return result;
}

+ (vec_3) getDistanceVectorBetweenLocation1:(CLLocation *)loc1 andLocation2:(CLLocation *)loc2{
    vec_3 deltaDistance;
    double Rn = [INConstant earth_Rn:loc2.coordinate.latitude];//(earth_Rn + oldLocation.altitude);
    double Re = [INConstant earth_Re:loc2.coordinate.latitude];
    
//    NSLog(@"(%f, %f), (%f, %f)", loc1.coordinate.latitude, loc1.coordinate.longitude, loc2.coordinate.latitude, loc2.coordinate.longitude);
    deltaDistance.v1 = (loc2.coordinate.latitude - loc1.coordinate.latitude) * (Rn * M_PI) / 180;
    deltaDistance.v2 = (loc2.coordinate.longitude - loc1.coordinate.longitude) * (Re * cos([INConstant degree2Radians:loc2.coordinate.latitude]) * M_PI) / 180;
    return deltaDistance;
}

+ (vec_3) getSpeedVectorBetweenLocation1:(CLLocation *)loc1 andLocation2:(CLLocation *)loc2 deltaTime:(double)t{
    vec_3 deltaSpeed;
    vec_3 deltaDistance = [self getDistanceVectorBetweenLocation1:loc1 andLocation2:loc2];
    deltaSpeed.v1 = deltaDistance.v1 / t;
    deltaSpeed.v2 = deltaDistance.v2 / t;
    return deltaSpeed;
}


@end
