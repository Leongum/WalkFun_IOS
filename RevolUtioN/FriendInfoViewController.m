//
//  FriendInfoViewController.m
//  WalkFun
//
//  Created by Bjorn on 14-2-21.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "FriendInfoViewController.h"

@interface FriendInfoViewController ()

@end

@implementation FriendInfoViewController
@synthesize userBase;

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
    self.backButton.alpha = 0;
	// Do any additional setup after loading the view.
    //载入人物视图
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:[NSBundle mainBundle]];
    charatorViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"CharatorViewController"];
    UIView *charview = charatorViewController.view;
    CGRect charframe = self.charatorView.frame;
    if (charframe.size.height<568){
        double nw = charframe.size.height * 320 / 568;
        charframe = CGRectMake(0, 0, nw, charframe.size.height);
    }
    charview.frame = charframe;
    charview.center = self.charatorView.center;
    [self addChildViewController:charatorViewController];
    [self.charatorView addSubview:charview];
//    [self.view sendSubviewToBack:charview];
    [charatorViewController didMoveToParentViewController:self];
    
    [self.latestWorkoutDateLabel setDrawOutline:YES];
    [self.latestWorkoutDateLabel setOutlineColor:[UIColor blackColor]];
    self.latestWorkoutDateLabel.strokeWidth = 4;
    [self.latestWorkoutDateLabel setDrawGradient:YES];
    CGFloat colors [] = {
        255.0f/255.0f, 193.0f / 255.0f, 127.0f/255.0f, 1.0,
        0.0f/255.0f, 163.0f/255.0f, 64.0f/255.0f, 1.0
    };
    [self.latestWorkoutDateLabel setGradientColors:colors];
    
    [self.latestFriendActionDateLabel setDrawOutline:YES];
    [self.latestFriendActionDateLabel setOutlineColor:[UIColor blackColor]];
    self.latestFriendActionDateLabel.strokeWidth = 4;
    [self.latestFriendActionDateLabel setDrawGradient:YES];
    [self.latestFriendActionDateLabel setGradientColors:colors];

    [self.loadingLabel setSpotlightColor:[UIColor whiteColor]];
    [self.loadingLabel setContentMode:UIViewContentModeBottom];
    [self.loadingLabel startAnimating];
    
    [RORUtils setFontFamily:APP_FONT forView:self.view andSubViews:YES];
}

-(void)refreshView {
    self.userNameLabel.text = userBase.nickName;
    self.badgeImageView.image = [RORUserUtils getImageForUserBadge:userBase.userDetail.friendFightWin];
    self.badgeLabel.text = [NSString stringWithFormat:@"%d", userBase.userDetail.friendFightWin.intValue%20];
    
    if ([charatorViewController respondsToSelector:@selector(setUserBase:)]){
        [charatorViewController setValue:userBase forKey:@"userBase"];
    }
    
    [charatorViewController viewWillAppear:NO];
    if (latestFriendAction){
        int days = [RORUtils daysBetweenDate1:latestFriendAction.updateTime andDate2:[NSDate date]];
        self.latestFriendActionDateLabel.text = days>0?[NSString stringWithFormat:@"%d天前",days]:@"今天";
        NSMutableString *actDesString = [[NSMutableString alloc]initWithString:latestFriendAction.actionName];
        if ([userBase.sex isEqualToString:@"男"]){
            [actDesString replaceCharactersInRange:[actDesString rangeOfString:@"你"] withString:@"他"];
        } else {
            [actDesString replaceCharactersInRange:[actDesString rangeOfString:@"你"] withString:@"她"];
        }
        self.latestFriendActionDescriptionLabel.text = [NSString stringWithFormat:@"%@%@", latestFriendAction.actionFromName, actDesString];
    } else {
        self.latestFriendActionDateLabel.text = @"";
        self.latestFriendActionDescriptionLabel.text = @"最近没什么人理这吃货";
    }
    if (latestWorkout){
        int days = [RORUtils daysBetweenDate1:latestWorkout.missionEndTime andDate2:[NSDate date]];
        self.latestWorkoutDateLabel.text = days>0?[NSString stringWithFormat:@"%d天前",days]:@"今天";
    } else {
        self.latestWorkoutDateLabel.text = @"上辈子";
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshView];
}

-(void)viewDidAppear:(BOOL)animated{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        userBase = [RORUserServices syncUserInfoById:userBase.userId];
        NSArray *latestFriendActionList = [RORFriendService fetchUserActionsById:userBase.userId];
        NSArray *latestWorkoutList = [RORRunHistoryServices getSimpleRunningHistories:userBase.userId];
        if (latestFriendActionList && latestFriendActionList.count>0){
            latestFriendAction = [latestFriendActionList objectAtIndex:0];
        }
        if (latestWorkoutList && latestWorkoutList.count >0){
            latestWorkout = [latestWorkoutList objectAtIndex:0];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self refreshView];
            self.loadingLabel.alpha = 0;
        });
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

-(IBAction)backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
