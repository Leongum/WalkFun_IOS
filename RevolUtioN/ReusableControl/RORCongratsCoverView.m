//
//  RORCongratsCoverView.m
//  RevolUtioN
//
//  Created by Bjorn on 13-9-26.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORCongratsCoverView.h"
#import "RORUtils.h"
#import "FTAnimation.h"
#import "Animations.h"
#import "RORPlaySound.h"

@implementation RORCongratsCoverView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        bgView = [[UIImageView alloc] initWithFrame:frame];
        [self doInit];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self doInit];
    }
    return self;
}

-(void)doInit{
    [self setBackgroundColor:[UIColor clearColor]];
    self.alpha = 0;
    [bgView setAutoresizingMask:UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin];
    [bgView setImage:[UIImage imageNamed:@"coverview_bg.png"]];
    //        bgView.alpha = 0.5;
    [self addSubview:bgView];
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, 320, 30)];
    titleLabel.backgroundColor = [UIColor darkGrayColor];
    titleLabel.font = [UIFont fontWithName:CHN_PRINT_FONT size:18];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];

    awardTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 90, 320, 30)];
    awardTitleLabel.backgroundColor = [UIColor darkGrayColor];
    awardTitleLabel.textColor = [UIColor whiteColor];
    awardTitleLabel.font = [UIFont fontWithName:CHN_PRINT_FONT size:18];
    awardTitleLabel.text = @"获得额外的经验奖励";
    awardTitleLabel.textAlignment = NSTextAlignmentCenter;
    awardTitleLabel.alpha = 0;
    [self addSubview:awardTitleLabel];
    
    extraAwardLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 60, 320, 30)];
    extraAwardLabel.backgroundColor = [UIColor clearColor];
    extraAwardLabel.font = [UIFont fontWithName:ENG_GAME_FONT size:22];
    extraAwardLabel.textColor = [UIColor yellowColor];
    extraAwardLabel.textAlignment = NSTextAlignmentCenter;
    
    extraAwardLabel.alpha = 0;
    [self addSubview:extraAwardLabel];
}



-(IBAction)show:(id)sender{
    [self setEnabled:NO];
    self.alpha = 1;
    [self setEnabled:YES];
}

-(IBAction)hide:(id)sender{
    [Animations fadeOut:self andAnimationDuration:0.3 fromAlpha:1 andWait:NO];
    self.alpha = 0;
    
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
