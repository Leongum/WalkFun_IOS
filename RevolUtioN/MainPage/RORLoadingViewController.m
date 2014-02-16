//
//  RORLoadingViewController.m
//  RevolUtioN
//
//  Created by leon on 13-8-6.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORLoadingViewController.h"
#import "RORMissionServices.h"
#import "RORUserServices.h"
#import "RORRunHistoryServices.h"
#import "RORSystemService.h"
#import "RORNetWorkUtils.h"
#import "MLNavigationController.h"

@interface RORLoadingViewController ()

@end

@implementation RORLoadingViewController

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
    self.backButton.alpha = 0;
    
//    [RORUtils setFontFamily:CHN_PRINT_FONT forView:self.view andSubViews:YES];
//    [RORUtils setFontFamily:ENG_GAME_FONT forView:self.loadingLabel andSubViews:NO];
    
//    [self startIndicator:self];
    [RORNetWorkUtils initCheckNetWork];
    NSLog(@"%hhd",[RORNetWorkUtils getIsConnetioned]);

	// Do any additional setup after loading the view.
    //sync version
    Version_Control *version = [RORSystemService syncVersion:@"ios"];
    if(version != nil){
        if (CURRENT_VERSION_MAIN < version.version.integerValue ||
            CURRENT_VERSION_SUB < version.subVersion.integerValue){
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"新版本" message:[NSString stringWithFormat:@"发现Cyberace的最新版本%d.%d（当前版本%d.%d），现在就去app store更新？",version.version.integerValue, version.subVersion.integerValue, CURRENT_VERSION_MAIN, CURRENT_VERSION_SUB] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"前往", nil];
            [alertView show];
        }
        if([RORUserUtils getDownLoaded].doubleValue == 0){
            NSDictionary *downLoadDict = [[NSDictionary alloc]initWithObjectsAndKeys:@"ios", @"platform",[NSString stringWithFormat:@"%@.%@", version.version,version.subVersion], @"version", nil];
//            BOOL success = [RORSystemService submitDownloaded:downLoadDict];
//            if(success){
//                [RORUserUtils doneDowned];
//            }
        }
    }
//    [RORUserUtils syncSystemData];
    
    [self endIndicator:self];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }else if(buttonIndex == 1){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/cyberace/id718299464?ls=1&mt=8"]];
    }
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

-(void)viewDidAppear:(BOOL)animated{
//    [self performSegueWithIdentifier:@"loadingfinished" sender:self];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:[NSBundle mainBundle]];
    UINavigationController *navigationController =  [storyboard instantiateViewControllerWithIdentifier:@"RORNavigationController"];
//    MLNavigationController *navigationController =  [storyboard instantiateViewControllerWithIdentifier:@"RORNavigationController"];
    
//    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:2]];
    
//    sleep(2);
    
    [self presentViewController:navigationController animated:NO completion:NULL];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
