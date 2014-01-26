//
//  RORCustomShareViewController.m
//  RevolUtioN
//
//  Created by leon on 13-8-19.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORCustomShareViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <AGCommon/UIImage+Common.h>
#import <AGCommon/UIDevice+Common.h>
#import <AGCommon/UINavigationBar+Common.h>
#import <AGCommon/UIColor+Common.h>
#import <RenRenConnection/RenRenConnection.h>

#define SHARE_MAX_CONTENT 70

@implementation RORCustomShareViewController

@synthesize shareImage;
@synthesize shareMessage;

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
    isTyping = NO;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _txtShareContent.delegate = self;
    //[_txtShareContent becomeFirstResponder];
    _lblContentCount.text = [NSString stringWithFormat:@"%d/%d", SHARE_MAX_CONTENT, SHARE_MAX_CONTENT];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    _txtShareContent.layer.borderWidth=1.0;
    _txtShareContent.layer.borderColor=[[UIColor grayColor] CGColor];
}

-(IBAction)backAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)keyboardWillShow:(NSNotification *)sender {
    if (!isTyping){
       [Animations moveUp:self.view andAnimationDuration:0.3 andWait:NO andLength:150];
        isTyping = YES;
    }
}

- (void)keyboardWillHide:(NSNotification *)sender  {
    [Animations moveDown:self.view andAnimationDuration:0.3 andWait:NO andLength:150];
    isTyping = NO;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [_txtShareContent resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)updateWordCount
{
    
    NSInteger count = SHARE_MAX_CONTENT - [_txtShareContent.text length];
    _lblContentCount.text = [NSString stringWithFormat:@"%d/%d", count, SHARE_MAX_CONTENT];
    
    if (count < 0)
    {
        _lblContentCount.textColor = [UIColor redColor];
    }
    else
    {
        _lblContentCount.textColor = [UIColor darkGrayColor];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self updateWordCount];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shareContentAction:(id)sender {
    RORAppDelegate *appDelegate = (RORAppDelegate *)[UIApplication sharedApplication].delegate;
    NSArray *selectedClients = [_shareBar selectedClients];
    if ([selectedClients count] == 0)
    {
        [self sendAlart:SELECT_SHARE_PLATFORM_ERROR];
        return;
    }
    
    NSString *shareContent = shareMessage;
    
    //NSString *shareContent = [NSString stringWithFormat:SHARE_DEFAULT_CONTENT,[RORUtils outputDistance:record.distance.doubleValue],[RORUtils transSecondToStandardFormat:record.duration.doubleValue],[NSString stringWithFormat:@"%.1f kca", record.spendCarlorie.doubleValue]];
    
    if([_txtShareContent.text length]>0){
        shareContent = [[NSString stringWithFormat:@"『%@』",_txtShareContent.text] stringByAppendingString:shareContent];
    }
    
    id<ISSContent> publishContent = [ShareSDK content:shareContent
                                       defaultContent:nil
                                                image:[ShareSDK jpegImageWithImage:shareImage quality:1]
                                                title:SHARE_DEFAULT_TITLE
                                                  url:SHARE_DEFAULT_URL
                                          description:SHARE_DEFAULT_DESCRIPTION
                                            mediaType:SSPublishContentMediaTypeText];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:appDelegate.viewDelegate
                                               authManagerViewDelegate:nil];
    
    [authOptions setPowerByHidden:true];
    
    //分享内容
    for(int index=0; index<[selectedClients count]; index++){
        ShareType shareType = [[selectedClients objectAtIndex:index] integerValue];
        if(shareType != ShareTypeRenren){
            [ShareSDK shareContent:publishContent
                              type:shareType
                       authOptions:authOptions
                     statusBarTips:NO
                            result:nil];
        }
        else{
            [self sendRenRenShare:shareContent];
        }
    
    }
    [self sendSuccess:SHARE_SUBMITTED];
    [self dismissViewControllerAnimated:YES completion:^{}];
}

-(void)sendRenRenShare:(NSString *) shareContent{
    
    RORAppDelegate *appDelegate = (RORAppDelegate *)[UIApplication sharedApplication].delegate;
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:appDelegate.viewDelegate
                                               authManagerViewDelegate:nil];
    
    [authOptions setPowerByHidden:true];
    
    [ShareSDK getUserInfoWithType:ShareTypeRenren
                      authOptions:authOptions
                           result:^(BOOL result, id<ISSUserInfo> userInfo, id<ICMErrorInfo> error) {
                               if (result)
                               {
                                   //调用上传照片至用户相册。此接口需要采用multipart/form-data的编码方式。：http://wiki.dev.renren.com/wiki/V2/photo/upload
                                   //先获取相关平台的App对象
                                   id<ISSRenRenApp> app = (id<ISSRenRenApp>)[ShareSDK getClientWithType:ShareTypeRenren];
                                   id<ISSCAttachment> imgAtt =[ShareSDK jpegImageWithImage:shareImage quality:1];
                                   //构造参数
                                   id<ISSCParameters> params = [ShareSDKCoreService parameters];
                                   [params addParameter:@"description" value:shareContent];
                                   [params addParameter:@"file" fileName:[imgAtt fileName] data:[imgAtt data] mimeType:[imgAtt mimeType] transferEncoding:nil];
                                   //调用接口
                                   [app api:@"https://api.renren.com/v2/photo/upload"
                                     method:SSRenRenRequestMethodMultipartPost
                                     params:params
                                       user:nil
                                     result:^(id responder) {
                                        //do nothing
                                      }
                                      fault:^(SSRenRenErrorInfo *error) {
                                         //do nothing
                                      }];

                               }
                           }];
}

- (IBAction)hideKeyboard:(id)sender {
    [self.txtShareContent resignFirstResponder];
}

- (void)viewDidUnload {
    [self setTxtShareContent:nil];
    [self setLblContentCount:nil];
    [self setShareBar:nil];
    [super viewDidUnload];
}
@end
