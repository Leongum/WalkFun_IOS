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

NSString *const loadingNote[] ={
    @"正在加载资源文件",
    @"正在努力加载资源文件",
    @"真的在努力加载资源文件",
    @"你的网速有点慢，但我还在努力",
    @"资源文件马上就要加载完毕",
};

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
    
//    [self.loadingLabel setSpotlightColor:[UIColor blackColor]];
//    [self.loadingLabel setContentMode:UIViewContentModeBottom];
    
    self.loadingLabel.text = loadingNote[timerCount];
    [RORUtils setFontFamily:APP_FONT forView:self.view andSubViews:YES];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

-(void)viewDidAppear:(BOOL)animated{
    [self.loadingLabel startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [RORNetWorkUtils initCheckNetWork];
        if([RORNetWorkUtils getIsConnetioned]){
            [RORUserUtils syncSystemData];
            [RORUserUtils syncUserData];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:[NSBundle mainBundle]];
            UINavigationController *navigationController =  [storyboard instantiateViewControllerWithIdentifier:@"RORMainViewController"];
            
            [self presentViewController:navigationController animated:NO completion:NULL];
        });
    });
    
    [NSThread detachNewThreadSelector:@selector(startTimer) toTarget:self withObject:nil];
}

-(void)startTimer{
    timerCount = 0;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerDot) userInfo:nil repeats:YES];
    repeatingTimer = timer;
    [[NSRunLoop currentRunLoop] run];
}

- (void)timerDot{
    timerCount++;
    if (timerCount>4)
        timerCount = 1;
    [self performSelectorOnMainThread:@selector(displayLoadingNote) withObject:nil waitUntilDone:YES];
}

-(void)displayLoadingNote{
    self.loadingLabel.text = loadingNote[timerCount];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
