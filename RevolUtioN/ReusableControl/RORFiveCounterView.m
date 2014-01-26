//
//  RORFiveCounterView.m
//  WalkFun
//
//  Created by Bjorn on 13-10-16.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORFiveCounterView.h"

@implementation RORFiveCounterView

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initLayout];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initLayout];
    }
    return self;
}

-(void)initLayout{
    self.backgroundColor = [UIColor clearColor];
    CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    imageView = [[UIImageView alloc]initWithFrame:newFrame];
    imageView.alpha = 0;
    [self addSubview:imageView];
    
    labelView = [[UILabel alloc]initWithFrame:newFrame];
    labelView.font = [UIFont fontWithName:ENG_WRITTEN_FONT size:15];
    labelView.backgroundColor = [UIColor clearColor];
    labelView.textColor = [UIColor grayColor];
    labelView.alpha = 0;
    [self addSubview:labelView];
}

- (id)initWithFrame:(CGRect)frame andNumber:(NSInteger)number
{
    self = [self initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setNewNumber:number];
    }
    return self;
}

-(void)setNewNumber:(NSInteger)number{
    if (number <=0) {
        imageView.alpha = 0;
        labelView.alpha = 0;
        return;
    }
    if (number<=5){
        [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",number]]];
        imageView.alpha = 1;
        labelView.alpha = 0;
        return;
    }
    labelView.text = [NSString stringWithFormat:@"%d", number];
    labelView.alpha = 1;
    imageView.alpha = 0;
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
