//
//  RORAboutViewController.m
//  WalkFun
//
//  Created by Bjorn on 13-9-29.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORAboutViewController.h"
#import "RORSystemService.h"

@interface RORAboutViewController ()

@end

@implementation RORAboutViewController

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
    hasNewVersion = NO;
    [RORUtils setFontFamily:APP_FONT forView:self.view andSubViews:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = nil;
    UITableViewCell *cell = nil;

    switch (indexPath.row) {
        case 0:
        {
            identifier = @"versionCell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d.%d", CURRENT_VERSION_MAIN, CURRENT_VERSION_SUB];
            Version_Control *version = [RORSystemService syncVersion:@"ios"];
            if (version.version.integerValue != CURRENT_VERSION_MAIN ||
                version.subVersion.integerValue != CURRENT_VERSION_SUB){
                hasNewVersion = YES;
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@(点击更新%d.%d)",cell.detailTextLabel.text, version.version.integerValue, version.subVersion.integerValue];
            }
            break;
        }
        case 1:
        {
            identifier = @"siteCell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            break;
        }
        default:
            break;
    }
    [RORUtils setFontFamily:APP_FONT forView:cell andSubViews:YES];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0 && hasNewVersion){
        //todo:: change url.
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/cyberace/id718299464?ls=1&mt=8"]];
    }
    if (indexPath.row == 1){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.cyberace.cc"]];
    }
}

@end
