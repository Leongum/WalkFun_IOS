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
#import "RORFriendService.h"
#import "RORUserPropsService.h"
#import "RORMissionHistoyService.h"
#import "RORNetWorkUtils.h"

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
            [self endIndicator:self];
//            [self performSegueWithIdentifier:@"bodySetting" sender:self];
//            return;
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
    [self authLoginFromSNS: UMShareToSina];
}

- (IBAction)qqAccountLogin:(id)sender {
    [self authLoginFromSNS: UMShareToQzone];
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    
    [self setBtnQQLogin:nil];
    [self setBtnSinaLogin:nil];
    [self setUsernameTextField:nil];
    [self setPasswordTextField:nil];
    [self setSwitchButton:nil];
    [self setNicknameTextField:nil];
    //[super viewDidUnload];
}

- (void)authLoginFromSNS:(NSString *) type{
    BOOL isOauth = [UMSocialAccountManager isOauthWithPlatform:type];
    if(!isOauth){
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:type];
        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response)
                                      {
                                          NSLog(@"response is %@",response);
                                          if(response.responseCode == UMSResponseCodeSuccess){
                                              [[UMSocialDataService defaultDataService] requestSocialAccountWithCompletion:^(UMSocialResponseEntity *accountResponse){
                                                  NSLog(@"SNS account response %@", accountResponse);
                                                  NSDictionary *snsAccountDic = [UMSocialAccountManager socialAccountDictionary];
                                                  UMSocialAccountEntity *account = [snsAccountDic valueForKey:type];
                                                  
                                                  BOOL islogin = [RORShareService loginFromSNS:account];
                                                  if(islogin){
                                                      [self syncDataAfterLogin];
                                                      [self.navigationController popViewControllerAnimated:YES];
                                                  }
                                                  else{
                                                      [self performSegueWithIdentifier:@"bodySetting" sender:self];
                                                  }
                                              }];
                                          }
                                      });
    }else {
        NSDictionary *snsAccountDic = [UMSocialAccountManager socialAccountDictionary];
        UMSocialAccountEntity *account = [snsAccountDic valueForKey:type];
        
        BOOL islogin = [RORShareService loginFromSNS:account];
        if(islogin){
            [self syncDataAfterLogin];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            [self performSegueWithIdentifier:@"bodySetting" sender:self];
        }
    }
    
}

-(void)syncDataAfterLogin{
    [self startIndicator:self];
    //用户历史
    BOOL history = [RORRunHistoryServices syncRunningHistories:[RORUserUtils getUserId]];
    if(!history){
        history = [RORRunHistoryServices syncRunningHistories:[RORUserUtils getUserId]];
    }
    //用户好友信息
    BOOL friends = [RORFriendService syncFriends:[RORUserUtils getUserId]];
    if(!friends){
        friends = [RORFriendService syncFriends:[RORUserUtils getUserId]];
    }
    //好友初步信息
    BOOL friendsort = [RORFriendService syncFriendSort:[RORUserUtils getUserId]];
    if(!friendsort){
        friendsort = [RORFriendService syncFriendSort:[RORUserUtils getUserId]];
    }
    //好友action信息
    BOOL action = [RORFriendService syncActions:[RORUserUtils getUserId]];
    if(!action){
        action = [RORFriendService syncActions:[RORUserUtils getUserId]];
    }
    //用户mission list
    BOOL missionHistory = [RORMissionHistoyService syncMissionHistories:[RORUserUtils getUserId]];
    if(!missionHistory){
        missionHistory = [RORMissionHistoyService syncMissionHistories:[RORUserUtils getUserId]];
    }
    //用户道具
    BOOL userPorp = [RORUserPropsService syncUserProps:[RORUserUtils getUserId]];
    if(!userPorp){
        userPorp = [RORUserPropsService syncUserProps:[RORUserUtils getUserId]];
    }
    [self endIndicator:self];
    if(!history || !friends || !friendsort || !action || !missionHistory || !userPorp){
        [self sendAlart:@"个人信息加载失败"];
        [RORUserUtils logout];
    }
}

@end
