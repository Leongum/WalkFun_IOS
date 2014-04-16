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
    
    self.loginInputView.alpha = 0;
    
    self.showPWCheckBox.isChecked = YES;
    
    [self.backButton removeTarget:self.backButton action:@selector(pressOn:) forControlEvents:UIControlEventTouchDown];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.nicknameTextField.alpha = 0;
}

-(IBAction)backAction:(id)sender{
    self.loginButtonView.alpha = 1;
    self.loginInputView.alpha = 0;
    self.backButton.alpha = 0;
}

#pragma RORSegmentControl-Delegate======

-(void)reFreshView{
    nicknameTextField.alpha = segmentIndex;
    self.loginButtonView.alpha = 0;
    self.loginInputView.alpha = 1;
    self.backButton.alpha = 1;
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
        [self sendAlart:@"网络链接错误"];
        return;
    }
    if (![self isLegalInput]) {
        return;
    }
    if (segmentIndex == 0){ //登录
        NSString *userName = usernameTextField.text;
        NSString *password = [RORUtils md5:passwordTextField.text];
        User_Base *user = [RORUserServices syncUserInfoByLogin:userName withUserPassword:password];
        if (user == nil){
            [self sendAlart:@"用户名密码输入错误，请重试"];
            return;
        }
        loggedInUserBase = user;
        [self startIndicator:self];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            BOOL success = [self syncDataAfterLogin];
            dispatch_async(dispatch_get_main_queue(), ^{
                if(success){
                    [self dismissViewControllerAnimated:YES completion:^(){}];
                }
                [self endIndicator:self];
            });
        });
    } else { //注册
        NSDictionary *regDict = [[NSDictionary alloc]initWithObjectsAndKeys:usernameTextField.text, @"userName",[RORUtils md5:passwordTextField.text], @"password", nicknameTextField.text, @"nickName", [RORUserUtils getDeviceToken], @"deviceId",@"ios", @"platformInfo", nil];
        [self startIndicator:self];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            User_Base *user = [RORUserServices registerUser:regDict];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (user != nil){
                    loggedInUserBase = user;
                    [self initUserInfoPlist];
                    [self sendSuccess:@"注册成功"];
                    [self performSegueWithIdentifier:@"sexSetting" sender:self];
                } else {
                    [self sendAlart:@"注册失败，用户名已存在"];
                }
            });
        });
    }
    passwordTextField.text = @"";
    nicknameTextField.text = @"";
}

-(void)initUserInfoPlist{
    [RORUserUtils writeToUserInfoPList:[NSDictionary dictionaryWithObjectsAndKeys:loggedInUserBase.userDetail.fight, @"fightPower", loggedInUserBase.userDetail.level,  @"userLevel", [NSNumber numberWithInteger:0],@"missionProcess", nil]];
}

- (BOOL) isLegalInput {
    if (segmentIndex == 0){
        if (usernameTextField.text.length<=0 ||
            passwordTextField.text.length <=0) {
            [self sendAlart:@"请填写正确的用户名密码"];
            return NO;
        }
    } else {
        if (usernameTextField.text.length<=0 ||
            passwordTextField.text.length<=0 ||
            nicknameTextField.text.length<=0) {
            [self sendAlart:@"请填写完整的用户信息"];
            return NO;
        }
        
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
                                                      [self startIndicator:self];
                                                      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                          BOOL success = [self syncDataAfterLogin];
                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                              if(success){
                                                                  [self dismissViewControllerAnimated:YES completion:^(){}];
                                                              }
                                                              [self endIndicator:self];
                                                          });
                                                      });
                                                  }
                                                  else{
                                                      [self performSegueWithIdentifier:@"sexSetting" sender:self];
                                                  }
                                              }];
                                          }
                                      });
    }else {
        NSDictionary *snsAccountDic = [UMSocialAccountManager socialAccountDictionary];
        UMSocialAccountEntity *account = [snsAccountDic valueForKey:type];
        
        BOOL islogin = [RORShareService loginFromSNS:account];
        if(islogin){
            [self startIndicator:self];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                BOOL success = [self syncDataAfterLogin];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(success){
                        [self dismissViewControllerAnimated:YES completion:^(){}];
                    }
                    [self endIndicator:self];
                });
            });
        }
        else{
            [self performSegueWithIdentifier:@"sexSetting" sender:self];
        }
    }
    
}

-(BOOL)syncDataAfterLogin{
    [self initUserInfoPlist];
    //用户历史
    BOOL history = [RORRunHistoryServices syncRunningHistories:[RORUserUtils getUserId]];
    if(!history){
        history = [RORRunHistoryServices syncRunningHistories:[RORUserUtils getUserId]];
    }
    //用户好友信息
    int friends = [RORFriendService syncFriends:[RORUserUtils getUserId]];
    if(friends<0){
        friends = [RORFriendService syncFriends:[RORUserUtils getUserId]];
    }
    //好友初步信息
    BOOL friendsort = [RORFriendService syncFriendSort:[RORUserUtils getUserId]];
    if(!friendsort){
        friendsort = [RORFriendService syncFriendSort:[RORUserUtils getUserId]];
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
    if(!history || friends<0 || !friendsort || !missionHistory || !userPorp){
        [RORUserUtils logout];
        [self sendAlart:@"个人信息加载失败"];
        return NO;
    }
    
//    [RORUserUtils initialUserInfoPlist];
    return YES;
}

- (IBAction)loginButtonAction:(id)sender {
    segmentIndex = 0;
    [self reFreshView];
}


- (IBAction)registerButtonAction:(id)sender {
    segmentIndex = 1;
    [self reFreshView];
}


@end
