//
//  RORLoginViewController.h
//  RevolUtioN
//
//  Created by Beyond on 13-5-24.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User_Base.h"
#import "RORAppDelegate.h"
#import "RORUtils.h"
#import "RORHttpResponse.h"
#import "RORUserServices.h"
#import "RORViewController.h"
#import "RORPaperSegmentControl.h"
#import "RORCheckBox.h"

@interface RORLoginViewController : RORViewController
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) RORSegmentControl *switchButton;
@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;
@property (strong, nonatomic) IBOutlet RORCheckBox *showPWCheckBox;
@property (strong, nonatomic) IBOutlet UIView *snsContainerView;

@property (strong,nonatomic)NSManagedObjectContext *context;

@property (strong, nonatomic) UIViewController *delegate;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIButton *btnSinaLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnTencentLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnQQLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnRenRenLogin;


- (IBAction)loginAction:(id)sender;
- (IBAction)backgroundTap:(id)sender;
- (IBAction)visibilityOfPW:(id)sender;
- (IBAction)sinaWeiboLogin:(id)sender;
- (IBAction)tencentWeiboLogin:(id)sender;
- (IBAction)qqAccountLogin:(id)sender;
- (IBAction)renrenAccountLogin:(id)sender;


@end
