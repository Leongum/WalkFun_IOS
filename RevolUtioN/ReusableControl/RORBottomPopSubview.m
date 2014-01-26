//
//  RORBottomPopSubview.m
//  RevolUtioN
//
//  Created by Bjorn on 13-8-21.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORBottomPopSubview.h"
#import "Animations.h"

@implementation RORBottomPopSubview

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    UIControl *bg = (UIControl*)[self viewWithTag:POPVIEW_BG_TAG];
    [self addTarget:bg action:@selector(hideView:) forControlEvents:UIControlEventTouchUpInside];
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

-(IBAction)popView:(id)sender{
    [Animations fadeIn:self andAnimationDuration:0.3 toAlpha:1 andWait:YES];
}

-(IBAction)hideView:(id)sender{
//    UIView *popView = [self viewWithTag:POPVIEW_TAG];
    [Animations fadeOut:self andAnimationDuration:0.3 fromAlpha:1 andWait:YES];
}

@end
