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
    self.mallCoverView.alpha = 0;
    self.backButton.alpha = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)mallAction:(id)sender {
    [self.mallCoverView fadeIn:0.2 delegate:self];
    self.mallCoverView.alpha = 1;
}

- (IBAction)lingqianAction:(id)sender {
    //[LingQianSDK openRewardStore];
    
    [self.mallCoverView bgTap:self];
}

- (IBAction)itemMallAction:(id)sender {
    UIViewController *parentController = [self parentViewController];
    UIStoryboard *itemStoryboard = [UIStoryboard storyboardWithName:@"ItemsStoryboard" bundle:[NSBundle mainBundle]];
    UIViewController *itemViewController =  [itemStoryboard instantiateViewControllerWithIdentifier:@"ItemMallViewController"];
    [parentController presentViewController:itemViewController animated:YES completion:^(){}];
    
    [self.mallCoverView bgTap:self];
}
@end
