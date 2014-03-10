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

#pragma mark - Action

-(IBAction)backAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^(){}];
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
            identifier = @"aboutCell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];

            Version_Control *version = [RORSystemService syncVersion:@"ios"];
            if (version.version.integerValue != CURRENT_VERSION_MAIN ||
                version.subVersion.integerValue != CURRENT_VERSION_SUB){
                [cell viewWithTag:3].alpha = 1;
            } else
                [cell viewWithTag:3].alpha = 0;
            break;
        }
        case 1:
        {
            identifier = @"recommendCell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            break;
        }
    }

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.row == 2){
//        RORCheckBox *check = (RORCheckBox*)[[tableView cellForRowAtIndexPath:indexPath] viewWithTag:3];
//        [check checkBoxClicked];
//    }
}

- (IBAction)feedbackAction:(id)sender {
    [UMFeedback showFeedback:self withAppkey:UMENG_APPKEY];
}


- (IBAction)logoutAction:(id)sender {
    //delete core data
    
    UIAlertView *confirmView = [[UIAlertView alloc] initWithTitle:LOGOUT_ALERT_TITLE message:LOGOUT_ALERT_CONTENT delegate:self cancelButtonTitle:CANCEL_BUTTON_CANCEL otherButtonTitles:OK_BUTTON_OK, nil];
    [confirmView show];
    confirmView = nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }else if(buttonIndex == 1){
        [RORUserUtils logout];
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:[NSBundle mainBundle]];
        UIViewController *loginViewController =  [mainStoryboard instantiateViewControllerWithIdentifier:@"RORLoginViewController"];
        [self.navigationController pushViewController:loginViewController animated:NO];
    }
}
@end
