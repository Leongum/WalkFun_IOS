//
//  CoverView.m
//  WalkFun
//
//  Created by Bjorn on 14-2-15.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "CoverView.h"
#import "FTAnimation.h"
@implementation CoverView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addTarget:self action:@selector(bgTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addTarget:self action:@selector(bgTap:) forControlEvents:UIControlEventTouchUpInside];
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

-(IBAction)bgTap:(id)sender{
    [self fadeOut:0.2 delegate:self];
//    self.alpha = 0;
}

@end
