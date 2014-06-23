//
//  RORRecommendViewController.m
//  WalkFun
//
//  Created by Bjorn on 14-1-10.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "RORRecommendViewController.h"

@interface RORRecommendViewController ()

@end

@implementation RORRecommendViewController

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
    contentList = [RORSystemService fetchAllRecommedInfo];
    self.backButton.alpha = 0;
    [RORUtils setFontFamily:APP_FONT forView:self.view andSubViews:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"RORRecommendViewController"];
    [MTA trackPageViewBegin:@"RORRecommendViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"RORRecommendViewController"];
}

-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [MTA trackPageViewEnd:@"RORRecommendViewController"];
}

-(IBAction)backAction:(id)sender{
    [super backAction:sender];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return contentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"plainCell"];
    
    Recommend_App *app = [contentList objectAtIndex:indexPath.row];
    
    //to-do
    UIImageView *appIcon = (UIImageView *)[cell viewWithTag:100];
    UILabel *appNameLabel = (UILabel *)[cell viewWithTag:101];
    UILabel *appDescriptionLabel = (UILabel *)[cell viewWithTag:102];
    
    NSURL *imageUrl = [NSURL URLWithString:app.appPicLink];
    UIImage *iconImage = [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:imageUrl]];
    [Animations roundedCorners:appIcon];
    appIcon.image = iconImage;
    
    appNameLabel.text = app.appName;
    
    [appDescriptionLabel setLineBreakMode:NSLineBreakByWordWrapping];
    appDescriptionLabel.numberOfLines = 3;
    appDescriptionLabel.text = app.appDescription;
    
    [RORUtils setFontFamily:APP_FONT forView:cell andSubViews:YES];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Recommend_App *app = [contentList objectAtIndex:indexPath.row];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:app.appAddress]];
}

@end
