//
//  RORLoginViewController.m
//  RevolUtioN
//
//  Created by Beyond on 13-5-24.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORLoginViewController.h"
#import "RORRunHistoryServices.h"
#import "RORShareService.h"
#import "RORNetWorkUtils.h"
#import <AGCommon/UIImage+Common.h>

#define SEGMENT_FRAME CGRectMake(95, 370, 150, 30)
@interface RORLoginViewController ()

@end

@implementation RORLoginViewController
@synthesize usernameTextField;
@synthesize passwordTextField;
@synthesize nicknameTextField;
@synthesize switchButton;
@synthesize context;
@synthesize delegate;

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
//    [self endIndicator:self];
    self.backButton.alpha = 0;
    
    switchButton = [[RORPaperSegmentControl alloc]initWithFrame:SEGMENT_FRAME andSegmentNumber:2];
    switchButton.delegate = self;
    [switchButton setSegmentTitle:@"登录" withIndex:0];
    [switchButton setSegmentTitle:@"注册" withIndex:1];
    [self.view addSubview:switchButton];
    
    self.showPWCheckBox.isChecked = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.nicknameTextField.alpha = 0;
}

//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//
//{
//    
//    if([keyPath isEqualToString:@"selectionIndex"])
//        
//    {
//        
//        NSLog(@"%@",change);
//        
//    }  
//    
//}

#pragma RORSegmentControl-Delegate======

-(void)SegmentValueChanged:(NSInteger)segmentIndex{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.2];
    
    nicknameTextField.alpha = segmentIndex;
    self.snsContainerView.alpha = 1-segmentIndex;
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationFinished)];
    [UIView commitAnimations];
}
//=======

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *destination = segue.destinationViewController;
    if ([destination respondsToSelector:@selector(setDelegate:)]){
        [destination setValue:self forKey:@"delegate"];
    }
}

-(IBAction)nickNameTapped:(id)sender{
//    nicknameTextField.backgroundColor = [UIColor lightGrayColor];
    CGRect rx = [ UIScreen mainScreen ].applicationFrame;
    if (rx.size.height-nicknameTextField.frame.origin.y + nicknameTextField.frame.size.height<=260)
        [Animations moveUp:self.view andAnimationDuration:0.3 andWait:NO andLength:75];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

//提交用户名密码之后的操作
- (IBAction)loginAction:(id)sender {
    
    if(![RORNetWorkUtils getIsConnetioned]){
        [self sendAlart:CONNECTION_ERROR];
        return;
    }
    if (![self isLegalInput]) {
        return;
    }
    if (switchButton.selectionIndex == 0){ //登录
        NSString *userName = usernameTextField.text;
        NSString *password = [RORUtils md5:passwordTextField.text];
        User_Base *user = [RORUserServices syncUserInfoByLogin:userName withUserPassword:password];
        
        if (user == nil){
            [self sendAlart:LOGIN_ERROR];
            return;
        }
        [self startIndicator:self];

        [self syncDataAfterLogin];
        [self endIndicator:self];
    } else { //注册
        //todo
        NSDictionary *regDict = [[NSDictionary alloc]initWithObjectsAndKeys:usernameTextField.text, @"userName",[RORUtils md5:passwordTextField.text], @"password", nicknameTextField.text, @"nickName", @"unknow device id", @"deviceId",@"ios", @"platformInfo", nil];
        [self startIndicator:self];

        User_Base *user = [RORUserServices registerUser:regDict];
        [self endIndicator:self];
        if (user != nil){
            [self sendSuccess:REGISTER_SUCCESS];
            [self performSegueWithIdentifier:@"bodySetting" sender:self];
            return;
        } else {
            [self sendAlart:REGISTER_FAIL];
            [self endIndicator:self];
//            return;
        }
    }
    passwordTextField.text = @"";
    nicknameTextField.text = @"";
    
    [self dismissViewControllerAnimated:YES completion:^(){}];
//    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (BOOL) isLegalInput {
    if (switchButton.selectionIndex == 0){
//        NSLog(@"%@,%@",usernameTextField.text,passwordTextField.text);
        if (usernameTextField.text.length<=0 ||
            passwordTextField.text.length <=0) {
            [self sendAlart:LOGIN_INPUT_CHECK];
            return NO;
        }
    } else {
        if (usernameTextField.text.length<=0 ||
            passwordTextField.text.length<=0 ||
            nicknameTextField.text.length<=0) {
            [self sendAlart:REGISTER_INPUT_CHECK];
            return NO;
        }
        
//        NSLog(@"%d",nicknameTextField.text.length);
        if ([RORUtils convertToInt:nicknameTextField.text]>6) {
            [self sendAlart:@"昵称太长啦！"];
            return NO;
        }
        if ([usernameTextField.text rangeOfString:@"@"].location == NSNotFound||
            [usernameTextField.text rangeOfString:@"."].location == NSNotFound){
            [self sendAlart:@"请填写正确的邮箱"];
            return NO;
        }
        if (passwordTextField.text.length <6){
            [self sendAlart:@"密码太短"];
            return NO;
        }
    }
    return YES;
}

- (IBAction)backgroundTap:(id)sender {
    [usernameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    [nicknameTextField resignFirstResponder];
    if (self.view.frame.origin.y<0)
        [Animations moveDown:self.view andAnimationDuration:0.3 andWait:NO andLength:75];
}


- (IBAction)visibilityOfPW:(id)sender {
    RORCheckBox *button = (RORCheckBox *)sender;
    passwordTextField.secureTextEntry = button.isChecked;
    [passwordTextField resignFirstResponder];
}

- (IBAction)sinaWeiboLogin:(id)sender {
    [self authLoginFromSNS:ShareTypeSinaWeibo];
}

- (IBAction)tencentWeiboLogin:(id)sender {
    [self authLoginFromSNS:ShareTypeTencentWeibo];
}

- (IBAction)qqAccountLogin:(id)sender {
    [self authLoginFromSNS:ShareTypeQQSpace];
}

- (IBAction)renrenAccountLogin:(id)sender {
    [self authLoginFromSNS:ShareTypeRenren];
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    
    [self setBtnRenRenLogin:nil];
    [self setBtnQQLogin:nil];
    [self setBtnTencentLogin:nil];
    [self setBtnSinaLogin:nil];
    [self setUsernameTextField:nil];
    [self setPasswordTextField:nil];
    [self setSwitchButton:nil];
    [self setNicknameTextField:nil];
    //[super viewDidUnload];
    
}

- (void)authLoginFromSNS:(ShareType) type{
    RORAppDelegate *appDelegate = (RORAppDelegate *)[UIApplication sharedApplication].delegate;
    
    //RORShareViewDelegate *shareViewDelegate = [[RORShareViewDelegate alloc] init];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:appDelegate.viewDelegate
                                               authManagerViewDelegate:nil];
    
    [authOptions setPowerByHidden:true];
    
    [ShareSDK getUserInfoWithType:type
                      authOptions:authOptions
                           result:^(BOOL result, id<ISSUserInfo> userInfo, id<ICMErrorInfo> error) {
                               if (result)
                               {
                                   BOOL islogin = [RORShareService loginFromSNS:userInfo withSNSType: type];
                                   [RORUserUtils userInfoUpdateHandler:userInfo withSNSType: type];
                                   if(islogin){
                                       [self syncDataAfterLogin];
                                       [self.navigationController popViewControllerAnimated:YES];
                                   }
                                   else{
                                       [self performSegueWithIdentifier:@"bodySetting" sender:self];
                                   }
                               }
                               else
                               {
                                   [self sendAlart:error.errorDescription];
                               }
                           }];
}

-(void)syncDataAfterLogin{
    [self startIndicator:self];
    BOOL history = [RORRunHistoryServices syncRunningHistories:[RORUserUtils getUserId]];
    if(!history){
        history = [RORRunHistoryServices syncRunningHistories:[RORUserUtils getUserId]];
    }
//    BOOL collect = [RORPlanService syncUserCollect:[RORUserUtils getUserId]];
//    if(!collect){
//        collect = [RORPlanService syncUserCollect:[RORUserUtils getUserId]];
//    }
//    BOOL follow = [RORPlanService syncUserFollow:[RORUserUtils getUserId]];
//    if(!follow){
//        follow = [RORPlanService syncUserFollow:[RORUserUtils getUserId]];
//    }
//    BOOL plan = [RORPlanService syncUserPlanHistory:[RORUserUtils getUserId]];
//    if(!plan){
//        plan = [RORPlanService syncUserPlanHistory:[RORUserUtils getUserId]];
//    }
    [self endIndicator:self];
    if(!history){
        [self sendAlart:@"个人信息加载失败"];
        [RORUserUtils logout];
    }
}

@end
