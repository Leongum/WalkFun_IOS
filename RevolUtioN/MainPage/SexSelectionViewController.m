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
    UIAlertView *confirmView = [[UIAlertView alloc] initWithTitle:@"选择性别" message:[NSString stringWithFormat:@"确定选【%@】吗？", userSex] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [confirmView show];
    confirmView = nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }else if(buttonIndex == 1){
        [self didSelectSexAction];
    }
}

- (void)didSelectSexAction{
    User_Base *userBase = [RORUserServices fetchUser:[RORUserUtils getUserId]];
    userBase.sex = userSex;
    [self startIndicator:self];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL success = [RORUserServices updateUserBase:userBase];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self endIndicator:self];
            if(success){
                [self dismissViewControllerAnimated:YES completion:^(){}];
            }else {
                [self sendAlart:@"性别设置失败"];
            }
        });
    });
}

@end
