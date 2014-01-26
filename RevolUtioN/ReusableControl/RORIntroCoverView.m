//
//  RORIntroCoverView.m
//  WalkFun
//
//  Created by Bjorn on 13-12-19.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORIntroCoverView.h"

@implementation RORIntroCoverView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        [self addTarget:self action:@selector(bgTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}


-(id)initWithFrame:(CGRect)frame andImage:(UIImage*)image{
    self = [self initWithFrame:frame];
    if (self) {
        coverImageView = [[UIImageView alloc]initWithImage:image];
        coverImageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:coverImageView];
    }
    return self;
}

-(IBAction)bgTap:(id)sender{
    [self removeFromSuperview];
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
