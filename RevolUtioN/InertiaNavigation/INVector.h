//
//  INVector.h
//  InertiaNavigation
//
//  Created by Bjorn on 13-7-23.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INMatrix.h"

@interface INVector : INMatrix

-(id)initWithRow:(NSInteger)input_row;
-(double)modOfVector;

@end
