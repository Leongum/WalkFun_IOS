//
//  AnnouncementViewController.m
//  WalkFun
//
//  Created by Bjorn on 14-4-24.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "AnnouncementViewController.h"

@interface AnnouncementViewController ()

@end

@implementation AnnouncementViewController

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
    [RORUtils setFontFamily:APP_FONT forView:self.view andSubViews:YES];
    [self.announceTextField setFont:[UIFont fontWithName:APP_FONT size:16]];
    
    NSMutableDictionary *settingDict = [RORUserUtils getUserSettingsPList];
    [settingDict setObject:[settingDict objectForKey:@"DescVersion"] forKey:@"formerDescVersion"];
    [RORUserUtils writeToUserSettingsPList:settingDict];
    
    self.announceTextField.text = [settingDict objectForKey:@"VersionDescription"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"AnnouncementViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"AnnouncementViewController"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
