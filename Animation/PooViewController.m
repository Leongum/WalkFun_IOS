//
//  PooViewController.m
//  heart
//
//  Created by crazypoo on 14-2-14.
//  Copyright (c) 2014年 crazypoo. All rights reserved.
//

#import "PooViewController.h"

@implementation PooViewController
@synthesize heartsEmitter;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
	self.heartsEmitter = [CAEmitterLayer layer];
	self.heartsEmitter.emitterPosition = CGPointMake(self.view.frame.origin.x + self.view.frame.size.width/2.0,
													 self.view.frame.origin.y + self.view.frame.size.height/2.0);
	self.heartsEmitter.emitterSize = CGSizeMake(self.view.frame.size.width, 20);
	self.heartsEmitter.emitterMode = kCAEmitterLayerVolume;
	self.heartsEmitter.emitterShape = kCAEmitterLayerRectangle;
	self.heartsEmitter.renderMode = kCAEmitterLayerAdditive;
	
	CAEmitterCell *heart = [CAEmitterCell emitterCell];
	heart.name = @"heart";
	heart.emissionLongitude = M_PI/2.0;
	heart.emissionRange = 0.55 * M_PI;
	heart.birthRate		= 1.5;
	heart.lifetime		= 3.0;
	heart.velocity		= -120;
	heart.velocityRange = 60;
	heart.yAcceleration = 20;
	heart.contents		= (id) [[UIImage imageNamed:@"PooHeart"] CGImage];
	heart.color			= [[UIColor colorWithRed:0.8 green:0.8 blue:0.2 alpha:1] CGColor];
	heart.redRange		= 0.5;
	heart.greenRange	= 0.5;
    heart.blueRange     = 0.5;
	heart.alphaSpeed	= -1 / heart.lifetime;
	heart.scale			= 0.15;
	heart.scaleSpeed	= 0.5;
	heart.spinRange		= 2.0 * M_PI;
	
	self.heartsEmitter.emitterCells = [NSArray arrayWithObject:heart];
	[self.view.layer addSublayer:heartsEmitter];
}

- (void)viewWillUnload
{
	[super viewWillUnload];
	[self.heartsEmitter removeFromSuperlayer];
	self.heartsEmitter = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
