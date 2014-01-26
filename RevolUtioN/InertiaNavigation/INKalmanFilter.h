//
//  INKalmanFilter.h
//  InertiaNavigation
//
//  Created by Bjorn on 13-7-27.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "INMatrix.h"

#define DIMENSION_OF_STATUS 8
#define K1R -0.1
#define K2R 0.6
#define K1Q -0.1
#define K2Q 1.2
#define EPSILON 0.01
#define ETA 0.0025
#define SIZE_OF_N 7

@interface INKalmanFilter : NSObject {
    INMatrix *y[SIZE_OF_N];
    INMatrix *r[SIZE_OF_N];
    int count;
    int head;
}

@property (strong, nonatomic) INMatrix *Phi; //status trans for k|k-1

//status for k, k|k-1, k-1|k-1
@property (strong, nonatomic) INMatrix *X_k;
@property (strong, nonatomic) INMatrix *X_kk1;
@property (strong, nonatomic) INMatrix *X_k1k1;

@property (strong, nonatomic) INMatrix *P_k;
@property (strong, nonatomic) INMatrix *P_kk1;
@property (strong, nonatomic) INMatrix *P_k1k1;

@property (strong, nonatomic) INMatrix *Q_k;
@property (strong, nonatomic) INMatrix *Q_k1;

@property (strong, nonatomic) INMatrix *R_k;
@property (strong, nonatomic) INMatrix *R_k1;

@property (strong, nonatomic) INMatrix *Kk;
@property (strong, nonatomic) INMatrix *W_k;//status noise

@property (strong, nonatomic) INMatrix *H;
@property (strong, nonatomic) INMatrix *yk;

@property (nonatomic) CLLocationCoordinate2D coordinate;

-(id)initWithCoordinate:(CLLocationCoordinate2D)coor;
-(void)initPhi;
-(void)initP0;

-(void)updatePhiwithF:(vec_3)f andVe:(double)Ve;
-(BOOL)calculateKwithF:(vec_3)f deltaCoor:(vec_3) deltaV andVe:(double)Ve;
-(BOOL)pushYk:(INMatrix *)newYk;

@end
