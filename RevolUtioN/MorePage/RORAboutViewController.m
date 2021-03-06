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
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"RORAboutViewController"];
    [MTA trackPageViewBegin:@"RORAboutViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"RORAboutViewController"];
}
-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [MTA trackPageViewEnd:@"RORAboutViewController"];
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

            NSDictionary *settingDict = [RORUserUtils getUserSettingsPList];
            NSNumber *mainVersion = [settingDict objectForKey:@"MainVersion"];
            NSNumber *subVersion = [settingDict objectForKey:@"SubVersion"];
            Version_Control *version = [RORSystemService syncVersion:@"ios"];
            if (mainVersion.intValue != CURRENT_VERSION_MAIN ||
                subVersion.intValue != CURRENT_VERSION_SUB){
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
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_URL]];
    }
}

@end
