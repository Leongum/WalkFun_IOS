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
    //载入人物视图
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:[NSBundle mainBundle]];
    charatorViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"CharatorViewController"];
    UIView *charview = charatorViewController.view;
    CGRect charframe = self.charatorView.frame;
    charview.frame = charframe;
    //    if ([charatorViewController respondsToSelector:@selector(setUserBase:)]){
    //        [charatorViewController setValue:[RORUserServices fetchUser:[RORUserUtils getUserId]] forKey:@"userBase"];
    //    }
    [self addChildViewController:charatorViewController];
    [self.view addSubview:charview];
    [charatorViewController didMoveToParentViewController:self];
    
    [self refreshView];
}

-(void)refreshView {
    self.userNameLabel.text = userBase.nickName;
    if ([charatorViewController respondsToSelector:@selector(setUserBase:)]){
        [charatorViewController setValue:userBase forKey:@"userBase"];
    }
    [charatorViewController viewWillAppear:NO];
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
