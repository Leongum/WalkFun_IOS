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
#import "UMFeedback.h"

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
    self.backButton.alpha = 0;
    [RORUtils setFontFamily:APP_FONT forView:self.view andSubViews:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [moreTableView reloadData];
    [MobClick beginLogPageView:@"RORMoreViewController"];
    [MTA trackPageViewBegin:@"RORMoreViewController"];
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"RORMoreViewController"];
}

-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [MTA trackPageViewEnd:@"RORMoreViewController"];
}

#pragma mark - Action

-(IBAction)backAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^(){}];
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
        case 0:{
            identifier = @"notebookCell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            UIView *msgNote = (UIView *)[cell viewWithTag:200];
            //同步好友间的事件
            NSNumber *aQnum = (NSNumber *)[[RORUserUtils getUserInfoPList] objectForKey:@"MessageReceivedNumber"];
            msgNote.alpha = (aQnum && aQnum.intValue>0);

            break;
        }
        case 1:{
            identifier = @"announcementCell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            UIView *msgNote = (UIView *)[cell viewWithTag:200];
            NSDictionary *settingDict = [RORUserUtils getUserSettingsPList];
            NSNumber *fdv= [settingDict objectForKey:@"formerDescVersion"];
            NSNumber *dv = [settingDict objectForKey:@"DescVersion"];
            if ((!fdv) || fdv.intValue < dv.intValue){
                msgNote.alpha = 1;
            } else
                msgNote.alpha = 0;
            break;
        }
        case 2:{
            identifier = @"instructionCell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            break;
        }
        case 3:
        {
            identifier = @"aboutCell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            UIView *msgNote = (UIView *)[cell viewWithTag:3];

            NSDictionary *settingDict = [RORUserUtils getUserSettingsPList];
            NSNumber *mainVersion = [settingDict objectForKey:@"MainVersion"];
            NSNumber *subVersion = [settingDict objectForKey:@"SubVersion"];
            if (mainVersion.intValue > CURRENT_VERSION_MAIN ||
                subVersion.intValue > CURRENT_VERSION_SUB){
                msgNote.alpha = 1;
            } else
                msgNote.alpha = 0;
            break;
        }
        case 4:
        {
            identifier = @"gradeCell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            break;
        }
        case 5:
        {
            identifier = @"recommendCell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            break;
        }
    }
    [RORUtils setFontFamily:APP_FONT forView:cell andSubViews:YES];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 4) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_URL]];
    }
}

- (IBAction)feedbackAction:(id)sender {
    [UMFeedback showFeedback:self withAppkey:UMENG_APPKEY];
}


- (IBAction)logoutAction:(id)sender {
    //delete core data
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"注销" andMessage:@"确定要注销吗？"];
    [alertView addButtonWithTitle:@"取消"
                             type:SIAlertViewButtonTypeCancel
                          handler:^(SIAlertView *alertView) {
                              NSLog(@"Cancel Clicked");
                          }];
    [alertView addButtonWithTitle:@"确定"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView) {
                              NSLog(@"OK Clicked");
                              [self logoutAction];
                          }];
//    alertView.titleColor = [UIColor blackColor];
//    alertView.cornerRadius = 10;
//    alertView.buttonFont = [UIFont boldSystemFontOfSize:15];
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    
    alertView.willShowHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, willShowHandler2", alertView);
    };
    alertView.didShowHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, didShowHandler2", alertView);
    };
    alertView.willDismissHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, willDismissHandler2", alertView);
    };
    alertView.didDismissHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, didDismissHandler2", alertView);
    };
    
    [alertView show];
}

- (void)logoutAction{
    [RORUserUtils logout];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:[NSBundle mainBundle]];
    UIViewController *loginViewController =  [mainStoryboard instantiateViewControllerWithIdentifier:@"RORLoginViewController"];
    [self.navigationController pushViewController:loginViewController animated:NO];
}
@end
