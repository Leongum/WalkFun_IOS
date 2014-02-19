//
//  CoverView.m
//  WalkFun
//
//  Created by Bjorn on 14-2-15.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "CoverView.h"
#import "FTAnimation.h"
#import "Animations.h"

@implementation CoverView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addCoverBgImage];
        [self addTarget:self action:@selector(bgTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addCoverBgImage];
        [self addTarget:self action:@selector(bgTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)addCoverBgImage{
    bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"coverview_bg.png"]];
    bgImageView.frame = self.frame;
    bgImageView.center = CGPointMake(bgImageView.frame.size.width/2, bgImageView.frame.size.height/2);
    bgImageView.alpha = 1;
    [self addSubview:bgImageView];
    [self sendSubviewToBack:bgImageView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(IBAction)appear:(id)sender{
    self.alpha = 1;
    [Animations fadeIn:self andAnimationDuration:0.2 toAlpha:1 andWait:0];
    [bgImageView fadeIn:0.3 delegate:self];
}

-(IBAction)bgTap:(id)sender{
    [self fadeOut:0.2 delegate:self startSelector:nil stopSelector:@selector(removeFromSuperview)];
//    [Animations fadeOut:self andAnimationDuration:0.2 fromAlpha:1 andWait:0];
}


@end
