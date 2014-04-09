//
//  MissionStoneCongratsViewController.m
//  WalkFun
//
//  Created by Bjorn on 14-4-9.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "MissionStoneCongratsViewController.h"
#import "FTAnimation.h"
#import "Animations.h"

@interface MissionStoneCongratsViewController ()

@end

@implementation MissionStoneCongratsViewController

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
    titleView = [self.view viewWithTag:1];
    [RORUtils setFontFamily:APP_FONT forView:self.view andSubViews:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    [Animations rotate:titleView andAnimationDuration:0 andWait:NO andAngle:-18];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showItem:(Virtual_Product *)item{
    self.itemIconImageView.image = [RORVirtualProductService getImageOf:item];
    self.itemNameLabel.text = item.productName;
    
    self.goldSubView.alpha = 0;
    self.itemSubView.alpha = 1;
    
    [self.itemSubView popIn:0.5 delegate:self];
}

-(void)showGold:(NSNumber *)number{
    self.goldLabel.text = [NSString stringWithFormat:@"%@", number];
    
    self.goldSubView.alpha = 1;
    self.itemSubView.alpha = 0;
    [self.goldSubView popIn:0.5 delegate:self];
}


@end
