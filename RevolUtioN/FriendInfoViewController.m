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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        userBase = [RORUserServices syncUserInfoById:userBase.userId];
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

@end
