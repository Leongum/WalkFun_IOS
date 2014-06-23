//
//  MissionDoneCongratsViewController.m
//  WalkFun
//
//  Created by Bjorn on 14-4-3.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "MissionDoneCongratsViewController.h"
#import "Animations.h"
#import "FTAnimation.h"

@interface MissionDoneCongratsViewController ()

@end

@implementation MissionDoneCongratsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    titleView = [self.view viewWithTag:1];
    [self.missionNameLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.missionNameLabel.numberOfLines = 2;
    [RORUtils setFontFamily:APP_FONT forView:self.view andSubViews:YES];
    self.missionStoneImageView.alpha = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [Animations rotate:titleView andAnimationDuration:0 andWait:NO andAngle:-18];
    
    self.missionStoneImageView.alpha = 1;
    [self.missionStoneImageView popIn:0.5 delegate:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MissionDoneCongratsViewController"];
    [MTA trackPageViewBegin:@"MissionDoneCongratsViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MissionDoneCongratsViewController"];
}
-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [MTA trackPageViewEnd:@"MissionDoneCongratsViewController"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
