//
//  ReportViewController.m
//  WalkFun
//
//  Created by Bjorn on 14-4-4.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "ReportViewController.h"
#import "FTAnimation.h"

@interface ReportViewController ()

@end

@implementation ReportViewController
@synthesize winLabel, expLabel, coinLabel, itemLabel,fatLabel, commentLabel;

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
    winLabel.alpha = 0;
    expLabel.alpha = 0;
    coinLabel.alpha = 0;
    itemLabel.alpha = 0;
    fatLabel.alpha = 0;
    
    [commentLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [commentLabel setTextAlignment:NSTextAlignmentCenter];
    commentLabel.numberOfLines = 0;

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
    fatLabel.text = fatText;
    commentLabel.text = commentText;
    winLabel.alpha = 1;
    [winLabel popIn:0.25 delegate:self startSelector:nil stopSelector:@selector(itemLabelAnimation)];
}

-(void)expLabelAnimation{
    expLabel.alpha = 1;
    [expLabel popIn:0.25 delegate:self startSelector:nil stopSelector:@selector(fatLabelAnimation)];
}

-(void)coinLabelAnimation{
    coinLabel.alpha = 1;
    [coinLabel popIn:0.25 delegate:self startSelector:nil stopSelector:@selector(expLabelAnimation)];
}

-(void)itemLabelAnimation{
    itemLabel.alpha = 1;
    [itemLabel popIn:0.25 delegate:self startSelector:nil stopSelector:@selector(coinLabelAnimation)];
}

-(void)fatLabelAnimation{
    fatLabel.alpha = 1;
    [fatLabel popIn:0.25 delegate:self];
}

-(void)customInit:(NSString *)win Exp:(NSString *)exp Coin:(NSString *)coin Item:(NSString *)item Fat:(NSString *)fat andComment:(NSString *)comment{
    winText = win;
    expText = exp;
    coinText= coin;
    itemText = item;
    fatText = fat;
    commentText = comment;
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
