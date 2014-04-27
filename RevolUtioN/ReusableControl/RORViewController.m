//
//  RORViewController.m
//  RevolUtioN
//
//  Created by Bjorn on 13-8-20.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORViewController.h"
#import "FTAnimation.h"

@interface RORViewController ()

@end

@implementation RORViewController
@synthesize backButton;
@synthesize activityIndicator = _activityIndicator;
@synthesize progressView = _progressView;


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
    [self.view setAutoresizesSubviews:YES];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self addBackButton];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(didAppearNotification:)
//                                                 name:SVProgressHUDDidAppearNotification
//                                               object:nil];
    
    //初始化cover view队列
    coverViewQueue = [[NSMutableArray alloc]init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:SVProgressHUDWillAppearNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:SVProgressHUDDidAppearNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:SVProgressHUDWillDisappearNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:SVProgressHUDDidDisappearNotification
                                               object:nil];
    
    //add pinch gesture
    pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scalePiece:)];
    [self.view addGestureRecognizer:pinchGesture];
}

-(void)viewDidUnload{
    [self setBackButton:nil];
    [self setActivityIndicator:nil];
    [self setProgressView:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self endIndicator:self];
    [self dequeueCoverView];
}

-(void)dequeueCoverView{
    for (id obj in coverViewQueue){
        if ([obj isKindOfClass:[UIViewController class]]){
            UIViewController *viewController = (UIViewController *)obj;
            CoverView *congratsCoverView = (CoverView *)viewController.view;
            congratsCoverView.delegate = self;
            [congratsCoverView addCoverBgImage:[RORUtils captureScreen] grayed:YES];
            [congratsCoverView appear:self];
            
            [self addChildViewController:viewController];
            [self.view addSubview:congratsCoverView];
            [self didMoveToParentViewController:viewController];
            
            [coverViewQueue removeObject:viewController];
            break;
        } else if ([obj isKindOfClass:[CoverView class]]){
            CoverView *congratsCoverView = (CoverView *)obj;
            congratsCoverView.delegate = self;
            [congratsCoverView appear:self];
            
            [self.view addSubview:congratsCoverView];
            
            [coverViewQueue removeObject:obj];
            break;
        }
    }
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

-(void)addBackButton{
    backButton = [[RORNormalButton alloc]initWithFrame:BACKBUTTON_FRAME_TOP ];
    backButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;

    UIImage *image = [UIImage imageNamed:@"back_bg.png"];
    [backButton setBackgroundImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}

//gesture methods
//- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
//{
//    
//}

- (IBAction)scalePiece:(UIPinchGestureRecognizer *)gestureRecognizer
{
    UIViewController *rootViewController = self;
    while ([rootViewController parentViewController]) {
        rootViewController = [rootViewController parentViewController];
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIImage *image = [RORUtils captureScreen];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        piece = imageView;

        captureBgView = [RORUtils popShareCoverViewFor:rootViewController withImage:nil title:@"继续“捏”分享这个页面" andMessage:@"我在玩 @报告村长App " animated:YES];

//        [gestureRecognizer.view addSubview:captureBgView];
        [rootViewController.view addSubview:piece];
        
        CGPoint locationInView = [gestureRecognizer locationInView:piece];
        CGPoint locationInSuperview = [gestureRecognizer locationInView:piece.superview];
        piece.layer.anchorPoint = CGPointMake(locationInView.x / piece.bounds.size.width, locationInView.y / piece.bounds.size.height);
        piece.center = locationInSuperview;
    }
    if ([gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        if (piece.frame.size.width < gestureRecognizer.view.frame.size.width*0.8){
            [captureBgView setValue:@"松开分享这个页面" forKey:@"shareTitle"];
        } else {
            [captureBgView setValue:@"继续“捏”分享这个页面" forKey:@"shareTitle"];
        }
    }
    if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
        if (piece.frame.size.width < gestureRecognizer.view.frame.size.width*0.8){
            UIImageView *imageView = (UIImageView *)piece;
            [captureBgView setValue:imageView.image forKey:@"shareImage"];
            [captureBgView setValue:@"分享这个页面" forKey:@"shareTitle"];
            [piece fadeOut:0.3 delegate:self startSelector:nil stopSelector:@selector(pieceFadeOutStop:)];
        } else {
            captureBgView.view.alpha = 0;
            [piece removeFromSuperview];
        }
    }
    
//    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        piece.transform = CGAffineTransformScale([piece transform], [gestureRecognizer scale], [gestureRecognizer scale]);
        [gestureRecognizer setScale:1];
    }
    
}

-(IBAction)pieceFadeOutStop:(id)sender{
    [piece removeFromSuperview];
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)sendNotification:(NSString *)message{
    if ([message rangeOfString:@"失败"].location != NSNotFound ||
        [message rangeOfString:@"无法"].location != NSNotFound ||
        [message rangeOfString:@"错误"].location != NSNotFound){
        [SVProgressHUD showErrorWithStatus:message];
    } else if ([message rangeOfString:@"成功"].location != NSNotFound){
        [SVProgressHUD showSuccessWithStatus:message];
    } else
        [SVProgressHUD showImage:nil status:message];
}

-(void)sendSuccess:(NSString *)message{
    [SVProgressHUD showSuccessWithStatus:message];
}

-(void)sendAlart:(NSString *)message{
//    if (notificationView == nil){
//        notificationView = [[RORNotificationView alloc]init];
//        [self.view addSubview:notificationView];
//    }
//    [notificationView popNotification:self Message:message andType:RORNOTIFICATION_TYPE_IMPORTANT];
    [SVProgressHUD showErrorWithStatus:message];
}

-(IBAction)didAppearNotification:(id)sender{
//    [SVProgressHUD dismiss];
}

- (void)handleNotification:(NSNotification *)notif
{
}

/**
activity indicator
*/

- (IBAction)startIndicator:(id)sender
{
    [SVProgressHUD showWithStatus:nil maskType:SVProgressHUDMaskTypeClear];
}

- (IBAction)endIndicator:(id)sender{
//    [self.activityIndicator stopAnimating];
    [SVProgressHUD dismiss];
}

- (IBAction)startProgress:(id)sender
{
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(70, 260, 180, 20)];
    /*
     设置风格属性
     有两种风格属性：
     UIProgressViewStyleDefault
     UIProgressViewStyleBar
     */
    self.progressView.progressViewStyle = UIProgressViewStyleDefault;
    
    //设置进度，值为0——1.0的浮点数
    //    self.progressView.progress = .5;
    [self.view addSubview:self.progressView];
    
    //设定计时器，每隔1s调用一次runProgress方法
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runProgress)   userInfo:nil repeats:YES];
}

//在状态栏显示有网络请求的提示器
- (IBAction)startNetWork:(id)sender
{
    UIApplication *app = [UIApplication sharedApplication];
    if (app.isNetworkActivityIndicatorVisible) {
        app.networkActivityIndicatorVisible = NO;
    }else {
        app.networkActivityIndicatorVisible = YES;
    }
}

-(void)runIndicator
{
    //开启线程并睡眠三秒钟
    [NSThread sleepForTimeInterval:3];
    //停止UIActivityIndicatorView
    [self.activityIndicator stopAnimating];
}

//增加progressView的进度
-(void)runProgress
{
    self.progressView.progress += .1;
}

#pragma mark - Cover View Delegate

-(void)coverViewDidDismissed:(id)view{
    [self dequeueCoverView];
}
@end
