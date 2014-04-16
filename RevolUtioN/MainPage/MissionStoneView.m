//
//  MissionStoneView.m
//  WalkFun
//
//  Created by Bjorn on 14-4-16.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "MissionStoneView.h"
#import "Animations.h"
#import "FTAnimation.h"

@implementation MissionStoneView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self customInit];
    }
    return self;
}

-(void)customInit{
    //todo
    UIImageView *bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loginButton.png"]];
    bgImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    bgImageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [self addSubview:bgImageView];
    
    int uSpace = (self.frame.size.width-3*MISSION_STONE_WIDTH)/4;
    for (int i=0; i<3; i++){
        stoneImageView[i] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"contactUs_bg.png"]];
        stoneImageView[i].frame = CGRectMake(uSpace + (MISSION_STONE_WIDTH + uSpace)*i, MISSION_STONE_OFFSET_TOP, MISSION_STONE_WIDTH, MISSION_STONE_WIDTH);
        [self addSubview:stoneImageView[i]];
    }
    
    iterator = 0;
}

-(void)showStones:(int)quantity andAnimated:(BOOL)isAnimated{
    for (int i=0; i<3; i++){
        stoneImageView[i].alpha = (i<quantity);
    }
    if (quantity==3){
        lightUpImageView.alpha = 1;
        [lightUpImageView fadeIn:1 delegate:self];
    }
    if (isAnimated) {
        iterator = 0;
        [self stoneAnimation:self];
    }
}

-(IBAction)stoneAnimation:(id)sender{
    if (iterator<3) {
        [stoneImageView[iterator++] popIn:0.25 delegate:self startSelector:nil stopSelector:@selector(stoneAnimation:)];
    } else
        iterator = 0;
}

@end
