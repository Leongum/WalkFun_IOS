//
//  RORMoreViewController.m
//  RevolUtioN
//
//  Created by Beyond on 13-5-25.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORMoreViewController.h"
#import "RORUserServices.h"
#import "RORAppDelegate.h"
#import "RORSegmentControl.h"
#import "RORCheckBox.h"

@interface RORMoreViewController ()

@end

@implementation RORMoreViewController
@synthesize context;
@synthesize moreTableView;

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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [moreTableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *destination = segue.destinationViewController;
    if ([destination respondsToSelector:@selector(setDelegate:)]){
        [destination setValue:self forKey:@"delegate"];
    }
}

- (void)viewDidUnload {
    [self setMoreTableView:nil];
    [super viewDidUnload];
}

//-(IBAction)changeSpeedType:(id)sender{
//    NSMutableDictionary *settinglist = [RORUserUtils getUserSettingsPList];
//    RORSegmentControl *seg = (RORSegmentControl*)sender;
//    [settinglist setValue:[NSNumber numberWithInteger:[seg selectionIndex]] forKey:@"speedType"];
//    [RORUserUtils writeToUserSettingsPList:settinglist];
//}

- (void) SegmentValueChanged:(NSUInteger)segmentIndex{
    NSMutableDictionary *settinglist = [RORUserUtils getUserSettingsPList];
    [settinglist setValue:[NSNumber numberWithInteger:segmentIndex] forKey:@"speedType"];
    [RORUserUtils writeToUserSettingsPList:settinglist];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = nil;
    UITableViewCell *cell = nil;

    switch (indexPath.row) {
        case 0:
        {
            identifier = @"accountCell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            UILabel *label = (UILabel*)[cell viewWithTag:1];
            User_Base *userInfo = [RORUserServices fetchUser:[RORUserUtils getUserId]];
            if (userInfo.nickName.length<=0)
                label.text = @"未登录";
            else
                label.text =  userInfo.nickName;
//            [RORUtils setFontFamily:CHN_PRINT_FONT forView:cell andSubViews:YES];
            break;
        }
        case 1:
        {
            identifier = @"bodyCell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            UILabel *label = (UILabel*)[cell viewWithTag:1];
            label.text = @"身体参数";
//            [RORUtils setFontFamily:CHN_PRINT_FONT forView:cell andSubViews:YES];
            break;
        }
        case 2:
        {
            NSMutableDictionary *settinglist = [RORUserUtils getUserSettingsPList];
            NSString *syncMode = [settinglist valueForKey:@"uploadMode"];
            identifier = @"syncCell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            UILabel *label = (UILabel*)[cell viewWithTag:1];
            label.text = SYNC_MODE_WIFI;
            RORCheckBox *switchCtrl = (RORCheckBox *)[cell viewWithTag:3];
            [switchCtrl setTarget:self fun:@selector(syncModeSwitchChangeHandler:)];
            if([syncMode isEqualToString:DEFAULT_NET_WORK_MODE]){
                [switchCtrl setIsChecked:NO];
                //label.text = SYNC_MODE_ALL;
            }
            else{
                [switchCtrl setIsChecked:YES];
                //label.text = SYNC_MODE_WIFI;
            }
//            [RORUtils setFontFamily:CHN_PRINT_FONT forView:cell andSubViews:YES];
            break;
        }
        case 3:
        {
            identifier = @"speedCell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//            UISegmentedControl *seg = (UISegmentedControl *)[cell viewWithTag:2];
            RORSegmentControl *seg = (RORSegmentControl *)[cell viewWithTag:2];
            if (seg == nil){
                seg = [[RORPaperSegmentControl alloc]initWithFrame:CGRectMake(cell.frame.size.width - 130 - 10, (cell.frame.size.height - 29)/2, 130, 29) andSegmentNumber:2];
                seg.delegate = self;
                [seg setSegmentTitle:@"7'41\"/km" withIndex:0];
                [seg setSegmentTitle:@"7.8km/h" withIndex:1];
                [seg setTag:2];
                [cell addSubview:seg];
            }
            
            NSMutableDictionary *settinglist = [RORUserUtils getUserSettingsPList];
            NSNumber *speedType = [settinglist valueForKey:@"speedType"];
            if (speedType != nil){
                NSInteger st = speedType.integerValue;
                [seg selectSegmentAtIndex:st];
            }
            
//            [RORUtils setFontFamily:CHN_PRINT_FONT forView:cell andSubViews:YES];
//            [RORUtils setFontFamily:ENG_WRITTEN_FONT forView:seg andSubViews:YES];
            [RORUtils setSystemFontSize:14 forView:seg andSubViews:YES];
            break;
        }
        case 4:
        {
            identifier = @"aboutCell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//            [RORUtils setFontFamily:CHN_PRINT_FONT forView:[cell viewWithTag:1] andSubViews:NO];
//            [RORUtils setFontFamily:ENG_WRITTEN_FONT forView:[cell viewWithTag:2] andSubViews:NO];
//            [RORUtils setFontFamily:CHN_PRINT_FONT forView:[cell viewWithTag:3] andSubViews:NO];

            Version_Control *version = [RORSystemService syncVersion:@"ios"];
            if (version.version.integerValue != CURRENT_VERSION_MAIN ||
                version.subVersion.integerValue != CURRENT_VERSION_SUB){
                [cell viewWithTag:3].alpha = 1;
            } else
                [cell viewWithTag:3].alpha = 0;
            break;
        }
        case 5:
        {
            identifier = @"recommendCell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            break;
        }
    }

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 2){
        RORCheckBox *check = (RORCheckBox*)[[tableView cellForRowAtIndexPath:indexPath] viewWithTag:3];
        [check checkBoxClicked];
    }
}

- (void)syncModeSwitchChangeHandler:(RORCheckBox *)sender
{
    NSMutableDictionary *settingDict = [[NSMutableDictionary alloc] init];
    if (![sender isChecked])
    {   
        [settingDict setValue:DEFAULT_NET_WORK_MODE forKey:@"uploadMode"];
    }
    else
    {
        [settingDict setValue:NET_WORK_MODE_WIFI forKey:@"uploadMode"];
    }
    [RORUserUtils writeToUserSettingsPList:settingDict];
    //[moreTableView reloadData];
}

- (void)loadingAnimationChangeHandler:(RORCheckBox *)sender{
    NSMutableDictionary *settingDict = [[NSMutableDictionary alloc] init];
    [settingDict setValue:[NSNumber numberWithBool:sender.isChecked] forKey:@"loadingAnimation"];
    [RORUserUtils writeToUserInfoPList:settingDict];
}

@end
