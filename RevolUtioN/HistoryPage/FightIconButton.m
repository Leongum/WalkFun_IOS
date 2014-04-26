//
//  FightIconButton.m
//  WalkFun
//
//  Created by Bjorn on 14-4-27.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "FightIconButton.h"

@implementation FightIconButton
@synthesize fightStage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setFightStage:(int)fs{
    fightStage = fs;
    [self setImage:[UIUtils getFightImageByStage:[NSNumber numberWithInt:fightStage]] forState:UIControlStateNormal];
}

@end
