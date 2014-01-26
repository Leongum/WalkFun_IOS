//
//  RORViewController.h
//  RevolUtioN
//
//  Created by Bjorn on 13-8-20.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Animations.h"
#import "RORConstant.h"
#import "RORUtils.h"
#import "RORNormalButton.h"
#import "RORNotificationView.h"
#import "RORPlaySound.h"
#import "SVProgressHUD.h"
#import "RORIntroCoverView.h"
#import "RORNavigationButton.h"

#define BACKBUTTON_FRAME_TOP CGRectMake(0, 0, 70, 70)

@interface RORViewController : UIViewController <UIGestureRecognizerDelegate> {
    RORNotificationView *notificationView;
    UIPinchGestureRecognizer *pinchGesture;
    UIView *piece;
    UIViewController *captureBgView;
}
//-(void)addBackButton;
@property (strong, nonatomic) RORNavigationButton *backButton;

@property(retain,nonatomic) UIActivityIndicatorView *activityIndicator;
@property(retain,nonatomic) UIProgressView *progressView;
@property (nonatomic) BOOL needRefresh;

- (IBAction)backAction:(id)sender;

-(void)sendNotification:(NSString *)message;
-(void)sendSuccess:(NSString *)message;
-(void)sendAlart:(NSString *)message;

- (IBAction)startIndicator:(id)sender;
- (IBAction)endIndicator:(id)sender;
- (IBAction)startProgress:(id)sender;
- (IBAction)startNetWork:(id)sender;

@end
