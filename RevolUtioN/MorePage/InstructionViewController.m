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
    [self.instructionTextView setFont:[UIFont systemFontOfSize:14]];
    
    self.instructionTextView.text = GAME_RULE;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"InstructionViewController"];
    [MTA trackPageViewBegin:@"InstructionViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"InstructionViewController"];
}
-(void) viewDidDisappear:(BOOL)animated {
     [super viewDidDisappear:animated];
    [MTA trackPageViewEnd:@"InstructionViewController"];
}


@end
