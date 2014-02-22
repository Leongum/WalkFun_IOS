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
	// Do any additional setup after loading the view.
    [self refreshView];
}

-(void)refreshView {
    self.userNameLabel.text = userBase.nickName;
}

-(void)viewDidAppear:(BOOL)animated{
    [self startIndicator:self];
    
    userBase = [RORUserServices syncUserInfoById:userBase.userId];
    [self refreshView];
    
    [self endIndicator:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
