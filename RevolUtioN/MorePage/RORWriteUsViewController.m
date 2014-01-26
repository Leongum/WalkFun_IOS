//
//  RORWriteUsViewController.m
//  WalkFun
//
//  Created by Bjorn on 13-9-30.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORWriteUsViewController.h"

@interface RORWriteUsViewController ()

@end

@implementation RORWriteUsViewController

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
    [RORUtils setFontFamily:CHN_PRINT_FONT forView:self.view andSubViews:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)hideKeyboard:(id)sender {
    [self.textField resignFirstResponder];
}

-(IBAction)submitAction:(id)sender{
    NSDictionary *feedbackDict = [[NSDictionary alloc]initWithObjectsAndKeys:self.textField.text, @"suggestion",@"", @"contact", [RORUserUtils getUserId], @"userId", nil];
    [self startIndicator:self];
    [RORSystemService submitFeedback:feedbackDict];
    [self backAction:self];
    [self endIndicator:self];
}
@end
