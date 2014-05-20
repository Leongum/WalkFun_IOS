//
//  InstructionViewController.m
//  WalkFun
//
//  Created by Bjorn on 14-5-20.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "InstructionViewController.h"

@interface InstructionViewController ()

@end

@implementation InstructionViewController

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
    [self.instructionTextView setFont:[UIFont fontWithName:APP_FONT size:16]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
