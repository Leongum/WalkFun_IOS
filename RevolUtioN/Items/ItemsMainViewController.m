//
//  ItemsMainViewController.m
//  WalkFun
//
//  Created by Bjorn on 14-2-14.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "ItemsMainViewController.h"
#import "FTAnimation.h"

@interface ItemsMainViewController ()

@end

@implementation ItemsMainViewController

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
    
    self.backButton.alpha = 0;
    
    self.userItemScrollView.delegate = self;
    if ([RORUserUtils getUserId].integerValue>0){
        [RORUserPropsService syncUserProps:[RORUserUtils getUserId]];
        itemList = [RORUserPropsService fetchUserProps:[RORUserUtils getUserId]];
    } else
        itemList = nil;
    
    if (itemList) {
        [self.userItemScrollView initContent:itemList];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)mallAction:(id)sender {
    UIStoryboard *itemStoryboard = [UIStoryboard storyboardWithName:@"ItemsStoryboard" bundle:[NSBundle mainBundle]];
    UIViewController *itemViewController =  [itemStoryboard instantiateViewControllerWithIdentifier:@"mallCoverViewController"];
    mallCoverView = (CoverView *)itemViewController.view;
    
    UIButton *itemMallButton = (UIButton *)[mallCoverView viewWithTag:200];
    [itemMallButton addTarget:self action:@selector(itemMallAction:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *lingqingButton = (UIButton *)[mallCoverView viewWithTag:201];
    [lingqingButton addTarget:self action:@selector(lingqianAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [[self parentViewController].view addSubview:mallCoverView];
    [mallCoverView appear:self];
}

- (IBAction)lingqianAction:(id)sender {
    [LingQianSDK openRewardStore];
    
    [mallCoverView bgTap:self];
}

- (IBAction)itemMallAction:(id)sender {
    UIStoryboard *itemStoryboard = [UIStoryboard storyboardWithName:@"ItemsStoryboard" bundle:[NSBundle mainBundle]];
    UIViewController *itemViewController =  [itemStoryboard instantiateViewControllerWithIdentifier:@"ItemMallViewController"];
    [[self parentViewController] presentViewController:itemViewController animated:YES completion:^(){}];
    
    [mallCoverView bgTap:self];
}
@end
