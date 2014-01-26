//
//  INVector.m
//  InertiaNavigation
//
//  Created by Bjorn on 13-7-23.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "INVector.h"

@implementation INVector

-(id)initWithRow:(NSInteger)input_row{
    self = [super initWithRow:input_row andColumn:1];
    return self;
}

-(double)modOfVector{
    double sum = 0.0;
    for (int i=0; i<self.row; i++){
        double value = [self getMatrixValueAtRow:i andColumn:0];
        sum+=value*value;
    }
    return sqrt(sum);
}

@end
