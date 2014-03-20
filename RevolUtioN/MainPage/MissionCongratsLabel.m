//
//  MissionCongratsLabel.m
//  WalkFun
//
//  Created by Bjorn on 14-3-20.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "MissionCongratsLabel.h"

@implementation MissionCongratsLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code]
        [self customInit];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self customInit];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)customInit{
    [self setDrawOutline:YES];
    [self setOutlineColor:[UIColor blackColor]];
    self.strokeWidth = 4;
    [self setDrawGradient:YES];
    CGFloat colors [] = {
        255.0f/255.0f, 193.0f / 255.0f, 127.0f/255.0f, 1.0,
        0.0f/255.0f, 163.0f/255.0f, 64.0f/255.0f, 1.0
    };
    [self setGradientColors:colors];
}

@end
