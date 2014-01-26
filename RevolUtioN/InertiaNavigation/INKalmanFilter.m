//
//  INKalmanFilter.m
//  InertiaNavigation
//
//  Created by Bjorn on 13-7-27.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "INKalmanFilter.h"

@implementation INKalmanFilter

-(id)initWithCoordinate:(CLLocationCoordinate2D)coor{
    self.coordinate = coor;
    [self initPhi];
    [self initX_k];
    [self initP0];
    [self initQ0];
    [self initR0];
    [self initH];
    return self;
}

-(void)initX_k{
    self.X_k = [[INMatrix alloc] initWithRow:DIMENSION_OF_STATUS andColumn:1];
    for (int i=0; i<self.X_k.row; i++)
        [self.X_k setMatrixValue:0.0 atRow:i andColumn:0];
    self.X_kk1 = self.X_k;
    self.X_k1k1 = self.X_k;
//    [self.X_k1k1 copyFrom:self.X_k];
//    [self.X_kk1 copyFrom:self.X_k];
}

-(void)updateX_kk1{
    self.X_kk1 = [self.Phi leftMultiply:self.X_k1k1];
}

-(void)initPhi{
    self.Phi = [[INMatrix alloc]initWithRow:DIMENSION_OF_STATUS andColumn:DIMENSION_OF_STATUS];
    for (int i=0; i<self.Phi.row; i++)
        [self.Phi setMatrixValue:1.0 atRow:i andColumn:i];
//    [self.Phi setMatrixValue:0 atRow:3 andColumn:2];
//    [self.Phi setMatrixValue:0 atRow:4 andColumn:2];
//    [self.Phi setMatrixValue:-delta_T/earth_R atRow:5 andColumn:0];
    [self.Phi setMatrixValue:delta_T/earth_R atRow:6 andColumn:0];
    [self.Phi setMatrixValue:1 atRow:7 andColumn:7];
}

-(void)initP0{
//    p0=diag(0.09  0.09  0.09  (0.15*pi/180)^2   (0.15*pi/180)^2   (0.15*pi/180)^2  (0.0002*pi/180)^2  (0.0002*pi/180)^2);
    
    INMatrix * P0=[[INMatrix alloc]initWithRow:8 andColumn:8];
    double value = 0.09;
    [P0 setMatrixValue:value atRow:0 andColumn:0];
    [P0 setMatrixValue:value atRow:1 andColumn:1];
    [P0 setMatrixValue:value atRow:2 andColumn:2];
    
    double minAng2 = (0.15*M_PI/180) * (0.15*M_PI/180);
    [P0 setMatrixValue:minAng2 atRow:3 andColumn:3];
    [P0 setMatrixValue:minAng2 atRow:4 andColumn:4];
    [P0 setMatrixValue:minAng2 atRow:5 andColumn:5];
    
    minAng2 = (0.0002*M_PI/180) * (0.0002*M_PI/180);
    [P0 setMatrixValue:minAng2 atRow:6 andColumn:6];
    self.P_k = P0;
    self.P_k1k1 = P0;
    self.P_kk1 = P0;
}

-(void)initR0{
//    R0 = diag(2e-4 2e-4 0.0);

    INMatrix *R0=[[INMatrix alloc]initWithRow:3 andColumn:3];
    double value = 0.1;//[INConstant degree2Radians:2E-4];
    value = value * value;
    
    [R0 setMatrixValue:value atRow:0 andColumn:0];
    [R0 setMatrixValue:value atRow:1 andColumn:1];
    [R0 setMatrixValue:value atRow:2 andColumn:2];
    self.R_k = R0;
    self.R_k1 = R0;
}

-(void)initQ0{
//    Q = diag((0.01g)^2  (0.01g)^2  (0.01g)^2  (4*pi/(180*3600))  (4*pi/(180*3600))  (4*pi/(180*3600)) 0 0);

    INMatrix *Q0=[[INMatrix alloc]initWithRow:8 andColumn:8];
    double value = 0.01*earth_G * 0.01 * earth_G;
    [Q0 setMatrixValue:value atRow:0 andColumn:0];
    [Q0 setMatrixValue:value atRow:1 andColumn:1];
    [Q0 setMatrixValue:value atRow:2 andColumn:2];
    value = 4*M_PI/(180*3600);
    [Q0 setMatrixValue:value atRow:3 andColumn:3];
    [Q0 setMatrixValue:value atRow:4 andColumn:4];
    [Q0 setMatrixValue:value atRow:5 andColumn:5];
    [Q0 setMatrixValue:0 atRow:6 andColumn:6];
    [Q0 setMatrixValue:0 atRow:7 andColumn:7];
    self.Q_k = Q0;
    self.Q_k1 = Q0;
}

-(void)initH{
    self.H = [[INMatrix alloc]initWithRow:3 andColumn:8];
    [self.H setMatrixValue:1 atRow:0 andColumn:0];
    [self.H setMatrixValue:1 atRow:1 andColumn:1];
    [self.H setMatrixValue:1 atRow:2 andColumn:2];
    return;
}

-(INMatrix*)getR{
//    INMatrix *temp = [self.H leftMultiply:self.X_kk1];
    INMatrix *sum = [[INMatrix alloc]initWithRow:3 andColumn:1];
    if (count>=SIZE_OF_N)
        for (int i=0; i<SIZE_OF_N; i++)
            sum = [sum addedByMatrix:[y[i] minusByMatrix:[self.H leftMultiply:self.X_kk1]]];
    return [sum numberMultiply:(1/SIZE_OF_N)];
}

-(INMatrix*)getPr{
    INMatrix *sum = [[INMatrix alloc]initWithRow:3 andColumn:1];
    for (int i=0; i<SIZE_OF_N; i++)
        sum = [sum leftMultiply:[r[i] leftMultiply:[r[i] getTransposition]]];
    return [sum numberMultiply:(1/SIZE_OF_N)];
}

-(INMatrix*)getLambda{
    INMatrix *rk = [self getR];
    INMatrix *Pr = [self getPr];
    INMatrix *I = [[INMatrix alloc] initWithRow:3 andColumn:3];
    [I diagInitial];
    if ([rk modOfVector]>EPSILON && [Pr matrix_det]-[self.P_kk1 modOfVector] < ETA){
        return [[Pr numberMultiply:K1R] addedByMatrix:[I numberMultiply:K2R]];
    } else
        return I;
}

//need to be modified
-(INMatrix*)getGama{
    INMatrix *rk = [self getR];
    INMatrix *Pr = [self getPr];
    INMatrix *I = [[INMatrix alloc] initWithRow:3 andColumn:3];
    [I diagInitial];
    if ([rk modOfVector]>EPSILON && [Pr matrix_det]-[self.P_kk1 modOfVector] < ETA){
        return [[Pr numberMultiply:K1Q] addedByMatrix:[I numberMultiply:K2Q*[rk modOfVector]]];
    } else
        return I;
}

-(void)updateQ{
    self.Q_k = [[self getGama] leftMultiply:self.Q_k1];
    self.Q_k1 = self.Q_k;
}

-(void)updateR{
    self.R_k = [[self getLambda] leftMultiply:self.R_k1];
    self.R_k1 = self.R_k;
}

-(void)updatePkk1{
    self.P_kk1 = [[[self.Phi leftMultiply:self.P_k1k1] leftMultiply:[self.Phi getTransposition]] addedByMatrix:self.Q_k];
}

-(void)updateKk{
    INMatrix *temp = [[[self.H leftMultiply:self.P_kk1] leftMultiply:[self.H getTransposition]] addedByMatrix:self.R_k];
    temp = [temp getInverse];
    self.Kk = [[self.P_kk1 leftMultiply:[self.H getTransposition]] leftMultiply:temp];
}

-(void)updateXk{
    self.X_k = [self.X_kk1 addedByMatrix:[self.Kk leftMultiply:[self.yk minusByMatrix:[self.H leftMultiply:self.X_kk1]]]];
    self.X_k1k1 = self.X_k;
    self.X_kk1 = self.X_k;
}

-(void)updatePkk{
    INMatrix *I = [[INMatrix alloc] initWithRow:8 andColumn:8];
    [I diagInitial];
    INMatrix *temp = [I minusByMatrix:[self.Kk leftMultiply:self.H]];
    temp = [[temp leftMultiply:self.P_kk1] leftMultiply:[temp getTransposition]];
    self.P_k = temp;
    self.P_k = [temp addedByMatrix:[[self.Kk leftMultiply:self.R_k] leftMultiply:[self.Kk getTransposition]]];
    self.P_k1k1 = self.P_k;
    self.P_kk1 = self.P_k;
    
//    self.P_k = [temp leftMultiply:self.P_kk1];
}

-(BOOL)pushYk:(INMatrix *)newYk{
    self.yk = newYk;
    if (count<SIZE_OF_N)
        count++;
    y[head] = newYk;
    r[head] = [self getR];
    head = (head+1)%SIZE_OF_N;
    return count >= SIZE_OF_N;
}

-(void)updatePhiwithF:(vec_3)f andVe:(double)Ve{
    
    double lati = [INConstant degree2Radians:self.coordinate.latitude];
    double tmpSin = earth_RAV*sin(lati)*delta_T;
    double tmpCos = earth_RAV*cos(lati)*delta_T;
    
    [self.Phi setMatrixValue:-2*tmpSin atRow:0 andColumn:2];
    [self.Phi setMatrixValue:f.v2*delta_T atRow:0 andColumn:4];
    [self.Phi setMatrixValue:f.v3*delta_T atRow:0 andColumn:5];
    
    [self.Phi setMatrixValue:2*tmpCos atRow:1 andColumn:2];
    [self.Phi setMatrixValue:-f.v2*delta_T atRow:1 andColumn:3];
    [self.Phi setMatrixValue:-f.v1*delta_T atRow:1 andColumn:4];
    
    [self.Phi setMatrixValue:2*tmpSin atRow:2 andColumn:0];
    [self.Phi setMatrixValue:-2*tmpCos atRow:2 andColumn:1];
    [self.Phi setMatrixValue:-f.v3*delta_T atRow:2 andColumn:3];
    [self.Phi setMatrixValue:f.v1*delta_T atRow:2 andColumn:4];
    
    [self.Phi setMatrixValue:-tmpSin atRow:3 andColumn:5];
    [self.Phi setMatrixValue:-tmpSin atRow:3 andColumn:6];
    
    [self.Phi setMatrixValue:tmpCos atRow:4 andColumn:5];
//    [self.Phi setMatrixValue:tmpCos atRow:4 andColumn:6];
    
    [self.Phi setMatrixValue:tmpSin atRow:5 andColumn:3];
    [self.Phi setMatrixValue:-tmpCos atRow:5 andColumn:4];
    
    [self.Phi setMatrixValue:delta_T/(earth_R*cos(lati)) atRow:7 andColumn:2];
    [self.Phi setMatrixValue:Ve * sin(lati) * delta_T/(earth_R * cos(lati) * cos(lati)) atRow:7 andColumn:6];
    
}

-(BOOL)calculateKwithF:(vec_3)f deltaCoor:(vec_3) deltaV andVe:(double)Ve{
    INMatrix *newYk = [[INMatrix alloc] initWithRow:3 andColumn:1];
    [newYk setMatrixValue:deltaV.v1 atRow:0 andColumn:0];
    [newYk setMatrixValue:deltaV.v2 atRow:2 andColumn:0];
    if ([self pushYk:newYk]){
        [self updatePhiwithF:f andVe:Ve];
        [self updateX_kk1];
//        [self updateQ];
//        [self updateR];
        [self updatePkk1];
        [self updateKk];
        [self updateXk];
        [self updatePkk];
        return YES;
    } else
        return NO;
}

@end
