//
//  ReportViewController.m
//  WalkFun
//
//  Created by Bjorn on 14-4-4.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "ReportViewController.h"

@interface ReportViewController ()

@end

@implementation ReportViewController
@synthesize winLabel, expLabel, coinLabel, itemLabel;

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
    
    [RORUtils setFontFamily:APP_FONT forView:self.view andSubViews:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    winLabel.text = winText;
    expLabel.text = expText;
    coinLabel.text = coinText;
    itemLabel.text = itemText;
}

-(void)customInit:(NSString *)win Exp:(NSString *)exp Coin:(NSString *)coin andItem:(NSString *)item{
    winText = win;
    expText = exp;
    coinText= coin;
    itemText = item;
    [self viewWillAppear:NO];
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
