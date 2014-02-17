//
//  ItemQuantityPicker.m
//  WalkFun
//
//  Created by Bjorn on 14-2-16.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "ItemQuantityPicker.h"
#import "Animations.h"

@implementation ItemQuantityPicker

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
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(IBAction)bgTap:(id)sender{
    [Animations fadeOut:self andAnimationDuration:0.2 fromAlpha:1 andWait:0];
}
@end
