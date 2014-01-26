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
}

-(void)setShareImage:(UIImage *)image{
//    CGSize imageSize = image.size;
//    imageSize = imageSize.height/shareImageView.frame.size.height
    shareImage = image;
    shareImageView.image = shareImage;
//    if (shareImage.size.height<shareImageView.frame.size.height){
//        shareImageView.frame = CGRectMake(shareImageView.frame.origin.x, shareImageView.frame.origin.y, shareImageView.frame.size.width, shareImage.size.height);
//    } else {
//        shareImageView.frame = CGRectMake(shareImageView.frame.origin.x, shareImageView.frame.origin.y, shareImage.size.width, shareImageView.frame.size.height);
//    }
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

- (IBAction)oneButtonShareAction:(id)sender {
    [RORShareCoverViewController present2SharePagefrom:[self parentViewController] withImage:shareImage andMessage:shareMessage];
//    [self removeFromParentViewController];
    [self hideCoverViewAction:self];
}

- (IBAction)shareToWeixin:(id)sender {
    //发送内容给微信
//    weixinSharing = YES;
    [self hideCoverViewAction:self];
    id<ISSContent> content = [ShareSDK content:nil
                                defaultContent:nil
                                         image:[ShareSDK jpegImageWithImage:shareImage quality:1]
                                         title:nil
                                           url:nil
                                   description:nil
                                     mediaType:SSPublishContentMediaTypeImage];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    
    [ShareSDK shareContent:content
                      type:ShareTypeWeixiTimeline
               authOptions:authOptions
             statusBarTips:YES
                    result:^(ShareType type, SSPublishContentState state, id<ISSStatusInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        if (state == SSPublishContentStateSuccess)
                        {
                            NSLog(@"success");
                        }
                        else if (state == SSPublishContentStateFail)
                        {
                            if ([error errorCode] == -22003)
                            {
                                if ([parent respondsToSelector:@selector(sendAlart:)])
                                    [parent sendAlart:[error errorDescription]];
                            }
                        }
//                        weixinSharing = NO;
//                        [self removeFromParentViewController];
//                         self.view.alpha = 0;
                    }];
}

- (IBAction)hideCoverViewAction:(id)sender {
//    if (!weixinSharing)
//        [self removeFromParentViewController];
    self.shareImageView.image = nil;
    self.view.alpha = 0;
}

+(void)present2SharePagefrom:(UIViewController*)delegate withImage:(UIImage *)image andMessage:(NSString *)msg{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:[NSBundle mainBundle]];
    UIViewController *viewController =  [storyboard instantiateViewControllerWithIdentifier:@"customShareViewController"];
    if (viewController){
        [viewController setValue:image forKey:@"shareImage"];
        [viewController setValue:msg forKey:@"shareMessage"];
        [delegate presentViewController:viewController animated:YES completion:^{}];
    }
}


@end
