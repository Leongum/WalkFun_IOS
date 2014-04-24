//
//  RORShareCoverViewController.m
//  WalkFun
//
//  Created by Bjorn on 13-12-24.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORShareCoverViewController.h"
#import "FTAnimation.h"

@interface RORShareCoverViewController ()

@end

@implementation RORShareCoverViewController
@synthesize shareImage, shareMessage, shareImageView, shareTitle;

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
    parent = (RORViewController*)[self parentViewController];
    weixinSharing = NO;
    [RORUtils setFontFamily:APP_FONT forView:self.view andSubViews:YES];
}

-(void)setShareImage:(UIImage *)image{
    shareImage = image;
    shareImageView.image = shareImage;
    [shareImageView fadeIn:0.3 delegate:self];
}

-(void)setShareTitle:(NSString *)title{
    shareTitle = title;
    self.shareTitleView.text = title;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)hideCoverViewAction:(id)sender {
    self.shareImageView.image = nil;
    self.view.alpha = 0;
}

- (IBAction)btnShareToWeibo:(id)sender {
    [self shareToSNS:UMShareToSina];
}

- (IBAction)btnShareToRenren:(id)sender {
    [self shareToSNS:UMShareToRenren];
}

- (IBAction)btnShareToWeixin:(id)sender {
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    [[UMSocialControllerService defaultControllerService] setShareText:shareMessage shareImage:shareImage socialUIDelegate:nil];
    //设置分享内容和回调对象
    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatTimeline].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
}

- (IBAction)btnShareToWFriend:(id)sender {
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    [[UMSocialControllerService defaultControllerService] setShareText:shareMessage shareImage:shareImage socialUIDelegate:nil];
    //设置分享内容和回调对象
    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
}

- (IBAction)btnShareToTencentWeibo:(id)sender {
    [self shareToSNS:UMShareToTencent];
}

-(void)shareToSNS:(NSString *)platform {
    [[UMSocialControllerService defaultControllerService] setShareText:shareMessage shareImage:shareImage socialUIDelegate:nil];
    //设置分享内容和回调对象
    [UMSocialSnsPlatformManager getSocialPlatformWithName:platform].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
}
@end
