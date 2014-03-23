//
//  LevelUpCongratsViewController.m
//  WalkFun
//
//  Created by Bjorn on 14-3-4.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "LevelUpCongratsViewController.h"

@interface LevelUpCongratsViewController ()

@end

@implementation LevelUpCongratsViewController
@synthesize levelLabe, oldGoldLabel, nExtraGoldLabel;

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
	
//	// Cells spawn in the bottom, moving up
//	CAEmitterLayer *fireworksEmitter = [CAEmitterLayer layer];
//	CGRect viewBounds = self.view.layer.bounds;
//	fireworksEmitter.emitterPosition = CGPointMake(viewBounds.size.width/2.0, viewBounds.size.height);
//	fireworksEmitter.emitterSize	= CGSizeMake(viewBounds.size.width/2.0, 0.0);
//	fireworksEmitter.emitterMode	= kCAEmitterLayerOutline;
//	fireworksEmitter.emitterShape	= kCAEmitterLayerLine;
//	fireworksEmitter.renderMode		= kCAEmitterLayerAdditive;
//	fireworksEmitter.seed = (arc4random()%100)+1;
//	
//	// Create the rocket
//	CAEmitterCell* rocket = [CAEmitterCell emitterCell];
//	
//	rocket.birthRate		= 0.5;
//	rocket.emissionRange	= 0.25 * M_PI;  // some variation in angle
//	rocket.velocity			= 380;
//	rocket.velocityRange	= 100;
//	rocket.yAcceleration	= 75;
//	rocket.lifetime			= 1.02;	// we cannot set the birthrate < 1.0 for the burst
//	
//	rocket.contents			= (id) [[UIImage imageNamed:@"DazRing"] CGImage];
//	rocket.scale			= 0.2;
//	rocket.color			= [[UIColor yellowColor] CGColor];
//	rocket.greenRange		= 1.0;		// different colors
//	rocket.redRange			= 1.0;
//	rocket.blueRange		= 1.0;
//	rocket.spinRange		= M_PI;		// slow spin
//	
//    
//	
//	// the burst object cannot be seen, but will spawn the sparks
//	// we change the color here, since the sparks inherit its value
//	CAEmitterCell* burst = [CAEmitterCell emitterCell];
//	
//	burst.birthRate			= 1.0;		// at the end of travel
//	burst.velocity			= 0;
//	burst.scale				= 2.5;
//	burst.redSpeed			=+1.5;		// shifting
//	burst.blueSpeed			=-1.5;		// shifting
//	burst.greenSpeed		=+1.0;		// shifting
//	burst.lifetime			= 0.15;
//	
//	// and finally, the sparks
//	CAEmitterCell* spark = [CAEmitterCell emitterCell];
//	
//	spark.birthRate			= 300;
//	spark.velocity			= 150;
//	spark.emissionRange		= 2* M_PI;	// 360 deg
//	spark.yAcceleration		= 75;		// gravity
//	spark.lifetime			= 3;
//    
//	spark.contents			= (id) [[UIImage imageNamed:@"DazStarOutline"] CGImage];
//	spark.scaleSpeed		=-0.2;
//	spark.greenSpeed		= 0.4;
//	spark.redSpeed			= 0.1;
//	spark.blueSpeed			=-0.4;
//	spark.alphaSpeed		=-0.25;
//	spark.spin				= 2* M_PI;
//	spark.spinRange			= 2* M_PI;
//	
//	// putting it together
//	fireworksEmitter.emitterCells	= [NSArray arrayWithObject:rocket];
//	rocket.emitterCells				= [NSArray arrayWithObject:burst];
//	burst.emitterCells				= [NSArray arrayWithObject:spark];
//	[self.view.layer addSublayer:fireworksEmitter];
    
    userBase = [RORUserServices fetchUser:[RORUserUtils getUserId]];
    
    NSMutableDictionary *userInfoList = [RORUserUtils getUserInfoPList];
    NSNumber *userExtraGold = [userInfoList valueForKey:@"fightPower"];
    [self inputOldGold:userExtraGold.doubleValue NewGold:2.5*userBase.userDetail.fight.doubleValue andLevel:userBase.userDetail.level.integerValue];
    NSDictionary *saveDict = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithDouble:userBase.userDetail.fight.doubleValue*2.5], @"fightPower", userBase.userDetail.level, @"userLevel", nil];
    [RORUserUtils writeToUserInfoPList:saveDict];
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void)inputOldGold:(double)oldGold NewGold:(double)newGold andLevel:(NSInteger)level{
    self.oldGoldLabel.text = [NSString stringWithFormat:@"%.3f%%", oldGold];
    self.nExtraGoldLabel.text = [NSString stringWithFormat:@"%.3f%%", newGold];
    self.levelLabe.text = [NSString stringWithFormat:@"%d",level];
}

- (IBAction)bgTap:(id)sender {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

@end
