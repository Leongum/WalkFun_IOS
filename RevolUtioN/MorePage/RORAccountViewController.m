//
//  RORAccountViewController.m
//  RevolUtioN
//
//  Created by Beyond on 13-6-26.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORAccountViewController.h"
#import "RORUserServices.h"

#import <AGCommon/UIImage+Common.h>

@interface RORAccountViewController ()

@end

@implementation RORAccountViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)initDataFromPlist{
    
    NSArray *authList = [NSArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@/authListCache.plist",NSTemporaryDirectory()]];
    if (authList == nil)
    {
        [shareTypeArray writeToFile:[NSString stringWithFormat:@"%@/authListCache.plist",NSTemporaryDirectory()] atomically:YES];
    }
    else
    {
        for (int i = 0; i < [authList count]; i++)
        {
            NSDictionary *item = [authList objectAtIndex:i];
            for (int j = 0; j < [shareTypeArray count]; j++)
            {
                if ([[[shareTypeArray objectAtIndex:j] objectForKey:@"type"] integerValue] == [[item objectForKey:@"type"] integerValue])
                {
                    [shareTypeArray replaceObjectAtIndex:j withObject:[NSMutableDictionary dictionaryWithDictionary:item]];
                    break;
                }
            }
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    shareTypeArray = [[NSMutableArray alloc] initWithObjects:
                      [NSMutableDictionary dictionaryWithObjectsAndKeys:
                       @"新浪微博",
                       @"title",
                       [NSNumber numberWithInteger:ShareTypeSinaWeibo],
                       @"type",
                       nil],
                      [NSMutableDictionary dictionaryWithObjectsAndKeys:
                       @"腾讯微博",
                       @"title",
                       [NSNumber numberWithInteger:ShareTypeTencentWeibo],
                       @"type",
                       nil],
                      [NSMutableDictionary dictionaryWithObjectsAndKeys:
                       @"人人网",
                       @"title",
                       [NSNumber numberWithInteger:ShareTypeRenren],
                       @"type",
                       nil],
                      [NSMutableDictionary dictionaryWithObjectsAndKeys:
                       @"QQ",
                       @"title",
                       [NSNumber numberWithInteger:ShareTypeQQSpace],
                       @"type",
                       nil],
                      nil];
    [self initDataFromPlist];
    
    if ([RORUserUtils getUserId].integerValue<0)
        self.logoutButton.alpha = 0;
    else
        self.logoutButton.alpha = 1;
    
    User_Base *userInfo = [RORUserServices fetchUser:[RORUserUtils getUserId]];
    self.userNameLabel.text = userInfo.nickName;
    [RORUtils setFontFamily:CHN_PRINT_FONT forView:self.userNameLabel andSubViews:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)logoutAction:(id)sender {
    //delete core data
    
    UIAlertView *confirmView = [[UIAlertView alloc] initWithTitle:LOGOUT_ALERT_TITLE message:LOGOUT_ALERT_CONTENT delegate:self cancelButtonTitle:CANCEL_BUTTON_CANCEL otherButtonTitles:OK_BUTTON_OK, nil];
    [confirmView show];
    confirmView = nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }else if(buttonIndex == 1){
        [RORUserUtils logout];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)userInfoUpdateHandler:(NSNotification *)notif
{
    NSInteger plat = [[[notif userInfo] objectForKey:SSK_PLAT] integerValue];
    id<ISSUserInfo> userInfo = [[notif userInfo] objectForKey:SSK_USER_INFO];
    
    for (int i = 0; i < [shareTypeArray count]; i++)
    {
        NSMutableDictionary *item = [shareTypeArray objectAtIndex:i];
        ShareType type = [[item objectForKey:@"type"] integerValue];
        if (type == plat)
        {
            [item setObject:[userInfo nickname] forKey:@"username"];
            [_tblAutoView reloadData];
        }
    }
}


- (void)authSwitchChangeHandler:(UISwitch *)sender
{
    NSInteger index = sender.tag - 100;
    
    if (index < [shareTypeArray count])
    {
        NSMutableDictionary *item = [shareTypeArray objectAtIndex:index];
        if (sender.on)
        {
            //用户用户信息
            ShareType type = [[item objectForKey:@"type"] integerValue];
            
            id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                                 allowCallback:YES
                                                                 authViewStyle:SSAuthViewStyleFullScreenPopup
                                                                  viewDelegate:nil
                                                       authManagerViewDelegate:nil];
            
            [authOptions setPowerByHidden:true];
            
            [ShareSDK getUserInfoWithType:type
                              authOptions:authOptions
                                   result:^(BOOL result, id<ISSUserInfo> userInfo, id<ICMErrorInfo> error) {
                                       if (result)
                                       {
                                           [RORUserUtils userInfoUpdateHandler:userInfo withSNSType:type];
                                           [self initDataFromPlist];
                                       }
                                       [_tblAutoView reloadData];
                                   }];
        }
        else
        {
            //取消授权
            [ShareSDK cancelAuthWithType:[[item objectForKey:@"type"] integerValue]];
            [_tblAutoView reloadData];
        }
        
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [shareTypeArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"authCell"];

    UISwitch *switchCtrl = [[UISwitch alloc] initWithFrame:CGRectZero];
    [switchCtrl sizeToFit];
    [switchCtrl addTarget:self action:@selector(authSwitchChangeHandler:) forControlEvents:UIControlEventValueChanged];
    cell.accessoryView = switchCtrl;
    
    if (indexPath.row < [shareTypeArray count])
    {
        NSDictionary *item = [shareTypeArray objectAtIndex:indexPath.row];
        UIImage *img;
        switch (indexPath.row) {
            case 0:
                img = [UIImage imageNamed:@"weibo.png"];
                break;
            case 1:
                img = [UIImage imageNamed:@"tencent_weibo.png"];
                break;
            case 2:
                img = [UIImage imageNamed:@"renren.png"];
                break;
            case 3:
                img = [UIImage imageNamed:@"QQ.png"];
                break;
            default:
                break;
        }
//        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:
//                                            @"Icon/sns_icon_%d.png",
//                                            [[item objectForKey:@"type"] integerValue]]
//                                bundleName:@"Resource"];
        cell.imageView.image = img;
        
        ((UISwitch *)cell.accessoryView).on = [ShareSDK hasAuthorizedWithType:[[item objectForKey:@"type"] integerValue]];
        ((UISwitch *)cell.accessoryView).tag = 100 + indexPath.row;
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        if (((UISwitch *)cell.accessoryView).on)
        {
            cell.textLabel.text = [item objectForKey:@"username"];
        }
        else
        {
            cell.textLabel.text = @"尚未授权";
        }
    }
    
    return cell;
}

- (void)viewDidUnload {
    [self setTblAutoView:nil];
    [super viewDidUnload];
}
@end
