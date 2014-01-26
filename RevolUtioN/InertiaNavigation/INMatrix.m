//
//  INMatrix.m
//  InertiaNavigation
//
//  Created by Bjorn on 13-7-19.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "INMatrix.h"

@implementation INMatrix
@synthesize matrix, row, column;

-(void)copyFrom:(INMatrix*)orgMatrix{
    self.matrix = [orgMatrix.matrix copy];
    self.row = orgMatrix.row;
    self.column = orgMatrix.column;
}

-(id)initWithRow:(NSInteger)input_row andColumn:(NSInteger)input_column{
    self = [super init];
    row = input_row;
    column = input_column;
    matrix = [[NSMutableArray alloc] init];
    for (int i=0; i<row; i++)
        for (int j=0; j<column; j++)
            [matrix addObject:[NSNumber numberWithDouble:0.0]];
    self.transMatrix = nil;
    self.inversMatrix = nil;
    return self;
}

-(BOOL)diagInitial{
    if (row!=column)
        return NO;
    for (int i=0; i<row; i++)
        [self setMatrixValue:1.0 atRow:i andColumn:i];
    return YES;
}

-(INMatrix *)leftMultiply:(INMatrix *)rightMatrix{
    if (self.column!= rightMatrix.row){
        NSLog(@"Matrix multiplication error: left one's column doesn't equal to right one's row.");
        return nil;
    }
    INMatrix *returnMatrix = [[INMatrix alloc] initWithRow:self.row andColumn:rightMatrix.column];
    for (int k=0; k<rightMatrix.column; k++){
        //cal each column of new matrix;
        
        for (int i=0; i<row; i++){
            //cal each row of new matrix;
            double sum=0.0;
            for (int j=0; j<column; j++){
                NSNumber *leftNum = [matrix objectAtIndex:(i*column + j)];
                NSNumber *rightNum = [rightMatrix.matrix objectAtIndex:(j*rightMatrix.column + k)];
                sum += leftNum.doubleValue * rightNum.doubleValue;
            }
            [returnMatrix setMatrixValue:sum atRow:i andColumn:k];
        }
    }
    return returnMatrix;
}

-(void)setMatrixValue:(double)value atRow:(NSInteger)r andColumn:(NSInteger)c{
    [matrix setObject:[NSNumber numberWithDouble:value] atIndexedSubscript:(r * column + c)];
}

-(double)getMatrixValueAtRow:(NSInteger)r andColumn:(NSInteger)c{
    return ((NSNumber*)[self.matrix objectAtIndex:(r*column + c)]).doubleValue;
}

-(INMatrix *)getTransposition{
    if (self.transMatrix == nil){
    self.transMatrix = [[INMatrix alloc]initWithRow:self.column andColumn:self.row];
    for (int i=0; i<self.row; i++)
        for (int j=0; j<self.column; j++)
            [self.transMatrix setMatrixValue:[self getMatrixValueAtRow:i andColumn:j] atRow:j andColumn:i];
    }
    return self.transMatrix;
}

-(INMatrix *)getInverse{
    if (self.inversMatrix == nil){
        int i = 0;
        int j = 0;
        int k = 0;
        //    struct _Matrix m;
        double temp = 0;
        double b = 0;
        
        if (row != column)
        {
            return nil;
        }
        /*
         //如果是2维或者3维求行列式判断是否可逆
         if (A->m == 2 || A->m == 3)
         {
         if (det(A) == 0)
         {
         return -1;
         }
         }
         */
        
        //增广矩阵m = A | B初始化
        INMatrix *augmented = [[INMatrix alloc]initWithRow:row andColumn:2*row];
        //    matrix_set_m(&m,A->m);
        //    matrix_set_n(&m,2 * A->m);
        //    matrix_init(&m);
        for (i = 0;i < augmented.row;i++)
        {
            for (j = 0;j < augmented.column;j++)
            {
                if (j <= column - 1)
                {
                    [augmented setMatrixValue:[self getMatrixValueAtRow:i andColumn:j] atRow:i andColumn:j];
                    //                matrix_write(&m,i,j,matrix_read(A,i,j));
                }
                else
                {
                    if (i == j - column)
                    {
                        [augmented setMatrixValue:1 atRow:i andColumn:j];
                        //                    matrix_write(&m,i,j,1);
                    }
                    else
                    {
                        [augmented setMatrixValue:0 atRow:i andColumn:j];
                        //                    matrix_write(&m,i,j,0);
                    }
                }
            }
        }
        
        //高斯消元
        //变换下三角
        for (k = 0;k < augmented.row - 1;k++)
        {
            //如果坐标为k,k的数为0,则行变换
            if ([augmented getMatrixValueAtRow:k andColumn:k] < 0)
            {
                for (i = k + 1;i < augmented.row ;i++)
                {
                    if ([augmented getMatrixValueAtRow:i andColumn:k] != 0)
                    {
                        break;
                    }
                }
                if (i >= augmented.row)
                {
                    //                return -1;
                    return nil;
                }
                else
                {
                    //交换行
                    for (j = 0;j < augmented.column;j++)
                    {
                        temp = [augmented getMatrixValueAtRow:k andColumn:j];// matrix_read(&m,k,j);
                        [augmented setMatrixValue:[augmented getMatrixValueAtRow:k+1 andColumn:j] atRow:k andColumn:j];
                        [augmented setMatrixValue:temp atRow:k+1 andColumn:j];
                        //                    matrix_write(&m,k,j,matrix_read(&m,k + 1,j));
                        //                    matrix_write(&m,k + 1,j,temp);
                    }
                }
            }
            
            //消元
            for (i = k + 1;i < augmented.row;i++)
            {
                //获得倍数
                b = [augmented getMatrixValueAtRow:i andColumn:k]/ [augmented getMatrixValueAtRow:k andColumn:k]; //matrix_read(&m,i,k) / matrix_read(&m,k,k);
                //行变换
                for (j = 0;j < augmented.column;j++)
                {
                    temp = [augmented getMatrixValueAtRow:i andColumn:j] - b * [augmented getMatrixValueAtRow:k andColumn:j]; //matrix_read(&m,i,j) - b * matrix_read(&m,k,j);
                    [augmented setMatrixValue:temp atRow:i andColumn:j];
                    //                matrix_write(&m,i,j,temp);
                }
            }
        }
        //变换上三角
        for (k = augmented.row - 1;k > 0;k--)
        {
            //如果坐标为k,k的数为0,则行变换
            if ([augmented getMatrixValueAtRow:k andColumn:k] == 0)
            {
                for (i = k + 1;i < augmented.row;i++)
                {
                    if ([augmented getMatrixValueAtRow:i andColumn:k] != 0)
                    {
                        break;
                    }
                }
                if (i >= augmented.row)
                {
                    return nil;
                }
                else
                {
                    //交换行
                    for (j = 0;j < augmented.column;j++)
                    {
                        temp = [augmented getMatrixValueAtRow:k andColumn:j];//matrix_read(&m,k,j);
                        [augmented setMatrixValue:[augmented getMatrixValueAtRow:k+1 andColumn:j] atRow:k andColumn:j];
                        [augmented setMatrixValue:temp atRow:k+1 andColumn:j];
                        //                    matrix_write(&m,k,j,matrix_read(&m,k + 1,j));
                        //                    matrix_write(&m,k + 1,j,temp);
                    }
                }
            }
            
            //消元
            for (i = k - 1;i >= 0;i--)
            {
                //获得倍数
                b = [augmented getMatrixValueAtRow:i andColumn:k]/[augmented getMatrixValueAtRow:k andColumn:k];//matrix_read(&m,i,k) / matrix_read(&m,k,k);
                //行变换
                for (j = 0;j < augmented.column;j++)
                {
                    temp = [augmented getMatrixValueAtRow:i andColumn:j] - b * [augmented getMatrixValueAtRow:k andColumn:j];//matrix_read(&m,i,j) - b * matrix_read(&m,k,j);
                    [augmented setMatrixValue:temp atRow:i andColumn:j];
                    //                matrix_write(&m,i,j,temp);
                }
            }
        }
        //将左边方阵化为单位矩阵
        for (i = 0;i < augmented.row;i++)
        {
            if ([augmented getMatrixValueAtRow:i andColumn:i] != 1)
            {
                //获得倍数
                b = 1 / [augmented getMatrixValueAtRow:i andColumn:i];//matrix_read(&m,i,i);
                //行变换
                for (j = 0;j < augmented.column;j++)
                {
                    temp = [augmented getMatrixValueAtRow:i andColumn:j] * b;
                    [augmented setMatrixValue:temp atRow:i andColumn:j];
                    //                matrix_write(&m,i,j,temp);
                }
            }
        }
        self.inversMatrix = [[INMatrix alloc]initWithRow:self.row andColumn:self.row];
        //求得逆矩阵
        for (i = 0;i < self.inversMatrix.row;i++)
        {
            for (j = 0;j < self.inversMatrix.column;j++)
            {
                [self.inversMatrix setMatrixValue:[augmented getMatrixValueAtRow:i andColumn:j+augmented.row] atRow:i andColumn:j];
                //            matrix_write(B,i,j,matrix_read(&m,i,j + m.m));
            }
        }
    }
    return self.inversMatrix;
}

-(INMatrix *)addedByMatrix:(INMatrix *)rightMatrix{
    if (self.row != rightMatrix.row || self.column != rightMatrix.column){
        NSLog(@"matrix add operation error");
        return nil;
    } else {
        INMatrix *result = [[INMatrix alloc]initWithRow:self.row andColumn:self.column];
        for (int i=0; i<self.row; i++)
            for (int j=0; j<self.column; j++)
                [result setMatrixValue:[self getMatrixValueAtRow:i andColumn:j]+[rightMatrix getMatrixValueAtRow:i andColumn:j] atRow:i andColumn:j];
        return result;
    }
}

-(INMatrix *)minusByMatrix:(INMatrix *)rightMatrix{
    if (self.row != rightMatrix.row || self.column != rightMatrix.column){
        NSLog(@"matrix add operation error");
        return nil;
    } else {
        INMatrix *result = [[INMatrix alloc]initWithRow:self.row andColumn:self.column];
        for (int i=0; i<self.row; i++)
            for (int j=0; j<self.column; j++)
                [result setMatrixValue:[self getMatrixValueAtRow:i andColumn:j]-[rightMatrix getMatrixValueAtRow:i andColumn:j] atRow:i andColumn:j];
        return result;
    }
}

-(INMatrix *)numberMultiply:(double)factor{
    INMatrix *result = [[INMatrix alloc]initWithRow:row andColumn:column];
    for (int i=0; i<row; i++)
        for (int j=0; j<column; j++)
            [result setMatrixValue:[self getMatrixValueAtRow:i andColumn:j]*factor atRow:i andColumn:j];
    return result;
}

-(double)modOfVector{
    double sum = 0.0;
    for (int i=0; i<self.row; i++){
        double value = [self getMatrixValueAtRow:i andColumn:0];
        sum+=value*value;
    }
    return sqrt(sum);
}

//行列式的值,只能计算3 * 3
//失败返回-31415,成功返回值
-(double) matrix_det{
    if (row !=3 || column!=3)
        return -31415;
    double value =
    [self getMatrixValueAtRow:0 andColumn:0] * [self getMatrixValueAtRow:1 andColumn:1] * [self getMatrixValueAtRow:2 andColumn:2] +
    [self getMatrixValueAtRow:0 andColumn:1] * [self getMatrixValueAtRow:1 andColumn:2] * [self getMatrixValueAtRow:2 andColumn:0] +
    [self getMatrixValueAtRow:0 andColumn:2] * [self getMatrixValueAtRow:1 andColumn:0] * [self getMatrixValueAtRow:2 andColumn:1] -
    [self getMatrixValueAtRow:0 andColumn:0] * [self getMatrixValueAtRow:1 andColumn:2] * [self getMatrixValueAtRow:2 andColumn:1] -
    [self getMatrixValueAtRow:0 andColumn:1] * [self getMatrixValueAtRow:1 andColumn:0] * [self getMatrixValueAtRow:2 andColumn:2] -
    [self getMatrixValueAtRow:0 andColumn:2] * [self getMatrixValueAtRow:1 andColumn:1] * [self getMatrixValueAtRow:2 andColumn:0];
    return value;
}

+(vec_3)multiplyRotationMatrix:(CMRotationMatrix)rMatrix withVector:(vec_3)vec{
    vec_3 newVec;
    newVec.v1 = rMatrix.m11 * vec.v1 + rMatrix.m12 * vec.v2 + rMatrix.m13 * vec.v3;
    newVec.v2 = rMatrix.m21 * vec.v1 + rMatrix.m22 * vec.v2 + rMatrix.m23 * vec.v3;
    newVec.v3 = rMatrix.m31 * vec.v1 + rMatrix.m32 * vec.v2 + rMatrix.m33 * vec.v3;
    return newVec;
}

+(vec_3)round100Vec_3:(vec_3)vec{
    vec_3 outv;
    outv.v1 = [INConstant round100:vec.v1];
    outv.v2 = [INConstant round100:vec.v2];
    outv.v3 = [INConstant round100:vec.v3];
    return outv;
}

+(double)modOfVec_3:(vec_3)vec{
    return sqrt(vec.v1*vec.v1 + vec.v2*vec.v2);
}

@end
