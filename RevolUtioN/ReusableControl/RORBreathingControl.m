//
//  RORBreathingControl.m
//  RevolUtioN
//
//  Created by Bjorn on 13-9-20.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORBreathingControl.h"

@implementation RORBreathingControl

- (id)initWithFrame:(CGRect)frame andImage:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundImage:image forState:UIControlStateNormal];
    }
    return self;
}

-(void)startAnimation{
//    [Animations fadeIn:self andAnimationDuration:2 toAlpha:0.9 andWait:YES];
    [Animations fadeOut:self andAnimationDuration:2 fromAlpha:0.9 andWait:NO];
}

-(void)setAlpha:(CGFloat)alpha{
    if (alpha == 1){
        [self startAnimation];
    } else
        [super setAlpha:alpha];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/



@end
