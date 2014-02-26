//
//  SexSelectionViewController.m
//  WalkFun
//
//  Created by Bjorn on 14-2-25.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "SexSelectionViewController.h"

@interface SexSelectionViewController ()

@end

@implementation SexSelectionViewController

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
    self.backButton.alpha = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Actions

- (IBAction)maleAction:(id)sender {
    userSex = @"男";
    [self showConfirmView];
}

- (IBAction)femaleAction:(id)sender {
    userSex = @"女";
    [self showConfirmView];
}

-(void)showConfirmView{
    UIAlertView *confirmView = [[UIAlertView alloc] initWithTitle:@"选择性别" message:[NSString stringWithFormat:@"确定选【%@】吗？", userSex] delegate:self cancelButtonTitle:CANCEL_BUTTON_CANCEL otherButtonTitles:OK_BUTTON_OK, nil];
    [confirmView show];
    confirmView = nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }else if(buttonIndex == 1){
        [self didSelectSexAction];
        [self dismissViewControllerAnimated:YES completion:^(){}];
    }
}

- (void)didSelectSexAction{
//    NSDictionary *saveDict = [NSDictionary dictionaryWithObjectsAndKeys:
//                              userSex, @"sex", nil];
//    [RORUserUtils writeToUserSettingsPList:saveDict];
    
    User_Base *userBase = [RORUserServices fetchUser:[RORUserUtils getUserId]];
    userBase.sex = userSex;
    [RORUserServices updateUserBase:userBase];
}

@end
