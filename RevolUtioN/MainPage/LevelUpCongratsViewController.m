//
//  LevelUpCongratsViewController.m
//  WalkFun
//
//  Created by Bjorn on 14-3-4.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "LevelUpCongratsViewController.h"
#import "Animations.h"
#import "FTAnimation.h"

@interface LevelUpCongratsViewController ()

@end

@implementation LevelUpCongratsViewController
@synthesize levelLabe, fightLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
	self.titleLabel.alpha = 0;
    userBase = [RORUserServices fetchUser:[RORUserUtils getUserId]];
    
    NSMutableDictionary *userInfoList = [RORUserUtils getUserInfoPList];
    NSNumber *userFightNum = [userInfoList valueForKey:@"fightPower"];
    [self inputOldFight:userFightNum.intValue NewFight:userBase.userDetail.fight.intValue andLevel:userBase.userDetail.level.intValue];

    NSDictionary *saveDict = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithDouble:userBase.userDetail.fight.doubleValue], @"fightPower", userBase.userDetail.level, @"userLevel", nil];
    [RORUserUtils writeToUserInfoPList:saveDict];
    
    [RORUtils setFontFamily:APP_FONT forView:self.view andSubViews:YES];
    
    self.congratsBg.alpha =0;
    //背景光转动的动画
//    [self startBgAnimation];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"LevelUpCongratsViewController"];
     [MTA trackPageViewBegin:@"LevelUpCongratsViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"LevelUpCongratsViewController"];
}
-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [MTA trackPageViewEnd:@"LevelUpCongratsViewController"];
}


-(void)viewDidAppear:(BOOL)animated{
    self.titleLabel.alpha = 1;
    [Animations rotate:self.titleLabel andAnimationDuration:0 andWait:NO andAngle:-18];
    [self.congratsBg popIn:0.2 delegate:self];
}

-(void)startBgAnimation{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 4;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    
    [self.congratsBg.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void)inputOldFight:(int)oldfight NewFight:(int)newFight andLevel:(int)level{
    self.fightLabel.text = [NSString stringWithFormat:@"%d → %d",oldfight, newFight];
    self.levelLabe.text = [NSString stringWithFormat:@"%d → %d",level-1, level];
}

- (IBAction)bgTap:(id)sender {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

@end
