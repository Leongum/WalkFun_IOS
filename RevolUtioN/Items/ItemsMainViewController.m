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
    titleView = self.itemMainTitleView;
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.backButton.alpha = 0;
    self.userItemScrollView.delegate = self;
    
    [RORUtils setFontFamily:APP_FONT forView:self.view andSubViews:YES];

}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if ([RORUserUtils getUserId].integerValue>0){
        itemList = [RORUserPropsService fetchUserProps:[RORUserUtils getUserId]];
        
        user = [RORUserServices fetchUser:[RORUserUtils getUserId]];
        self.moneyLabel.text = [NSString stringWithFormat:@"%d", user.userDetail.goldCoin.integerValue];
    } else
        itemList = nil;
    
    if (itemList) {
        [self.userItemScrollView initContent:itemList];
    }
    
    [self refreshTitleLayout:currentOffset];
}


#pragma mark Actions

- (IBAction)mallAction:(id)sender {
    
    
    UIStoryboard *itemStoryboard = [UIStoryboard storyboardWithName:@"ItemsStoryboard" bundle:[NSBundle mainBundle]];
    UIViewController *itemViewController =  [itemStoryboard instantiateViewControllerWithIdentifier:@"mallCoverViewController"];
    mallCoverView = (CoverView *)itemViewController.view;
    //debug
//    [mallCoverView setBgImage:coverImage];
    
    UIButton *itemMallButton = (UIButton *)[mallCoverView viewWithTag:200];
    [itemMallButton addTarget:self action:@selector(itemMallAction:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *lingqingButton = (UIButton *)[mallCoverView viewWithTag:201];
    [lingqingButton addTarget:self action:@selector(lingqianAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [mallCoverView addCoverBgImage];
    [[self parentViewController].view addSubview:mallCoverView];
    [mallCoverView appear:self];
    
    [RORUtils setFontFamily:APP_FONT forView:mallCoverView andSubViews:YES];

}

- (IBAction)lingqianAction:(id)sender {
    //[LingQianSDK openRewardStore];
    
    [mallCoverView bgTap:self];
}

- (IBAction)itemMallAction:(id)sender {
    UIStoryboard *itemStoryboard = [UIStoryboard storyboardWithName:@"ItemsStoryboard" bundle:[NSBundle mainBundle]];
    UIViewController *itemViewController =  [itemStoryboard instantiateViewControllerWithIdentifier:@"ItemMallViewController"];
    if ([itemViewController respondsToSelector:@selector(setUserBase:)])
        [itemViewController setValue:user forKey:@"userBase"];
    [[self parentViewController] presentViewController:itemViewController animated:YES completion:^(){}];
    [mallCoverView bgTap:self];
    [self startIndicator:self];
}
@end
