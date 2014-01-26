//
//  INMatrix.h
//  InertiaNavigation
//
//  Created by Bjorn on 13-7-19.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import "INConstant.h"

typedef struct{
    double v1, v2, v3;
}vec_3;

@interface INMatrix : NSObject{
//    int n, m;// m:row, n:column
}
@property (strong, nonatomic) NSMutableArray *matrix;
@property (nonatomic) NSInteger row;
@property (nonatomic) NSInteger column;
@property (strong, nonatomic) INMatrix *transMatrix;
@property (strong, nonatomic) INMatrix *inversMatrix;

-(id)initWithRow:(NSInteger)input_row andColumn:(NSInteger)input_column;
-(BOOL)diagInitial;
-(INMatrix *)leftMultiply:(INMatrix *)rightMatrix;
-(INMatrix *)numberMultiply:(double)factor;
-(void)setMatrixValue:(double)value atRow:(NSInteger)r andColumn:(NSInteger)c;
-(double)getMatrixValueAtRow:(NSInteger)r andColumn:(NSInteger)c;
-(INMatrix *)addedByMatrix:(INMatrix *)rightMatrix;
-(INMatrix *)minusByMatrix:(INMatrix *)rightMatrix;
-(double)modOfVector;
-(double)matrix_det;
-(INMatrix *)getTransposition;
-(INMatrix *)getInverse;

-(void)copyFrom:(INMatrix*)orgMatrix;

+(vec_3)multiplyRotationMatrix:(CMRotationMatrix)rMatrix withVector:(vec_3)vec;
+(vec_3)round100Vec_3:(vec_3)vec;
+(double)modOfVec_3:(vec_3)vec;
@end
