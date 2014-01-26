//
//  RORImageView.m
//  WalkFun
//
//  Created by Bjorn on 13-9-29.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORImageView.h"

@implementation RORImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 */
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextRotateCTM(context, M_PI/6);
    [super drawRect:rect];
}


@end
