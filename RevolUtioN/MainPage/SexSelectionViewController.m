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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Actions

- (IBAction)maleAction:(id)sender {
    userSex = @"男";
}

- (IBAction)femaleAction:(id)sender {
    userSex = @"女";
}

- (void)didSelectSexAction{
    NSDictionary *saveDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              userSex, @"sex", nil];
    [RORUserUtils writeToUserSettingsPList:saveDict];
    if([RORUserUtils getUserId].integerValue > 0){
        [RORUserServices updateUserInfo:saveDict];
}

@end
