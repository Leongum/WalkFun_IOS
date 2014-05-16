//
//  RORLoadingViewController.m
//  RevolUtioN
//
//  Created by leon on 13-8-6.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORLoadingViewController.h"
#import "RORMissionServices.h"
#import "RORUserServices.h"
#import "RORRunHistoryServices.h"
#import "RORSystemService.h"
#import "RORNetWorkUtils.h"
#import "MLNavigationController.h"

@interface RORLoadingViewController ()

@end

@implementation RORLoadingViewController

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
    
    [self.loadingLabel setSpotlightColor:[UIColor blackColor]];
    [self.loadingLabel setContentMode:UIViewContentModeBottom];

    [RORUtils setFontFamily:APP_FONT forView:self.view andSubViews:YES];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

-(void)viewDidAppear:(BOOL)animated{
    [RORNetWorkUtils initCheckNetWork];
    NSLog(@"%hhd",[RORNetWorkUtils getIsConnetioned]);

    [RORUserUtils syncSystemData];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:[NSBundle mainBundle]];
    UINavigationController *navigationController =  [storyboard instantiateViewControllerWithIdentifier:@"RORMainViewController"];

    [self presentViewController:navigationController animated:NO completion:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
