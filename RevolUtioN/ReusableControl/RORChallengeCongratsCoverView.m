//
//  RORChallengeCongratsCoverView.m
//  WalkFun
//
//  Created by Bjorn on 13-11-25.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORChallengeCongratsCoverView.h"
#import "FTAnimation.h"
#import "Animations.h"
#import "RORPlaySound.h"

@implementation RORChallengeCongratsCoverView
@synthesize bestRecord;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self fillContent];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andLevel:(User_Running_History*)record
{
    self = [super initWithFrame:frame];
    if (self) {
        bestRecord = record;
        [self fillContent];
    }
    return self;
}

-(void)fillContent{
    
    titleLabel.text = @"你这次跑步得了个";
    
    grade = bestRecord.missionGrade.integerValue;
    
//    if (grade == GRADE_A || grade == GRADE_S)
//    {
//        levelBgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"congrats_bg.png"]];
//        levelBgImageView.frame = self.frame;
//        levelBgImageView.alpha = 0;
//        [self addSubview:levelBgImageView];
//        
//        levelImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:MissionGradeCongratsImageEnum_toString[grade]]];
//        levelImageView.frame = self.frame;
//        levelImageView.alpha = 0;
//        [self addSubview:levelImageView];
//    } else {
//        levelLabel = [[UILabel alloc]initWithFrame:self.frame];
//        levelLabel.backgroundColor = [UIColor clearColor];
//        levelLabel.font = [UIFont fontWithName:ENG_GAME_FONT size:200];
//        levelLabel.textColor = [UIColor yellowColor];
//        levelLabel.textAlignment = NSTextAlignmentCenter;
//        levelLabel.text = MissionGradeEnum_toString[bestRecord.missionGrade.integerValue];
//        levelLabel.alpha = 0;
//        [self addSubview:levelLabel];
//    }
    
    extraAwardLabel.text = [NSString stringWithFormat:@"exp: %d", bestRecord.experience.integerValue];
    
    [self addTarget:self action:@selector(hide:) forControlEvents:UIControlEventTouchUpInside];
}


-(void)doAnimation{
//    [titleLabel fallIn:2 delegate:self];
//    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:3]];
//    
//    if (grade == GRADE_S || grade == GRADE_A) {
//        levelImageView.alpha = 1;
//        [levelImageView fallIn:0.3 delegate:self];
//        //        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
//        levelBgImageView.alpha = 1;
//        [levelBgImageView fadeIn:0.1 delegate:self];
//    } else {
//        levelLabel.alpha = 1;
//        [levelLabel fallIn:0.3 delegate:self];
//    }
//    
//    awardTitleLabel.alpha = 1;
//    [awardTitleLabel backInFrom:kFTAnimationLeft withFade:YES duration:0.5 delegate:self];
//    extraAwardLabel.alpha = 1;
//    [extraAwardLabel backInFrom:kFTAnimationRight withFade:YES duration:0.5 delegate:self];
//    
//    RORPlaySound *sound = [[RORPlaySound alloc] initForPlayingSoundEffectWith:[RORConstant SoundNameForSpecificGrade:grade]];
//    [sound play];
//    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:4]];
}


-(IBAction)show:(id)sender{
    [super show:sender];    
    [self doAnimation];
}

-(IBAction)hide:(id)sender{
    [super hide:sender];
    [RORShareService LQ_Runreward:bestRecord];
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
