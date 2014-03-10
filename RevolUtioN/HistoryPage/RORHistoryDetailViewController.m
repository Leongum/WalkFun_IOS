//
//  RORHistoryDetailViewController.m
//  RevolUtioN
//
//  Created by Beyond on 13-6-7.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORHistoryDetailViewController.h"
#import "RORRunningViewController.h"
#import "RORDBCommon.h"
#import "RORUtils.h"
#import "RORShareService.h"
#import "FTAnimation.h"

#define ROUTE_NORMAL 0
#define ROUTE_SHADOW 1

@interface RORHistoryDetailViewController ()
    
@end

@implementation RORHistoryDetailViewController{
    UIImage *img;
}

@synthesize stepLabel, durationLabel;
@synthesize record;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


//===============================================
//life cycle
//===============================================
- (void)viewDidLoad
{
    [super viewDidLoad];

    stepLabel.text = [RORUtils formattedSteps:record.steps.integerValue];
    durationLabel.text = [RORUtils transSecondToStandardFormat:record.duration.integerValue];

   NSDateFormatter *formattter = [[NSDateFormatter alloc] init];
    [formattter setDateFormat:@"yyyy-MM-dd"];
    self.dateLabel.text = [NSString stringWithFormat:@"%@", [formattter stringFromDate:record.missionDate]];
    
    NSArray *tmpList = [RORSystemService getEventListFromString:record.actionIds];
    eventTimeList = [tmpList objectAtIndex:0];
    eventList = [tmpList objectAtIndex:1];
    
//    [RORSystemService getPropgetListFromString:record.propGet];//debug
    [self.sumLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.sumLabel.numberOfLines = 0;
    NSString *pgString =record.propGet;
    NSMutableString *sumString = [[NSMutableString alloc]init];
    NSArray *pgStringList = [pgString componentsSeparatedByString:@"|"];
    if (((NSString *)[pgStringList objectAtIndex:0]).length>0){
        [sumString appendString:[NSString stringWithFormat:@"属性变化：%@\n", [pgStringList objectAtIndex:0]]];
    }
    if (((NSString *)[pgStringList objectAtIndex:1]).length>0){
        [sumString appendString:[NSString stringWithFormat:@"获得道具：%@\n", [pgStringList objectAtIndex:1]]];
    }
    if (((NSString *)[pgStringList objectAtIndex:2]).length>0){
        [sumString appendString:[NSString stringWithFormat:@"获得金币：%@", [pgStringList objectAtIndex:2]]];
    }
    self.sumLabel.text = sumString;

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //如果完成了任务
    if (record.missionId && [delegate isKindOfClass:[RORRunningViewController class]]){
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:[NSBundle mainBundle]];
        UIViewController *missionDoneViewController =  [mainStoryboard instantiateViewControllerWithIdentifier:@"missionCongratsVIewController"];
        [self.view addSubview:missionDoneViewController.view];
        
        UIView *missionCongratsView = missionDoneViewController.view;
        UILabel *missionNameLabel = (UILabel *)[missionCongratsView viewWithTag:100];
        UILabel *missionGoldLabel = (UILabel *)[missionCongratsView viewWithTag:101];
        UILabel *missionExpLabel = (UILabel *)[missionCongratsView viewWithTag:102];
        UILabel *missionDoneLabel = (UILabel *)[missionCongratsView viewWithTag:103];
        
        Mission *doneMission = [RORMissionServices fetchMission:record.missionId];
        missionNameLabel.text = doneMission.missionDescription;
        missionGoldLabel.text = [NSString stringWithFormat:@"+%d",doneMission.goldCoin.integerValue];
        missionExpLabel.text = [NSString stringWithFormat:@"+%d",doneMission.experience.integerValue];
        
        NSMutableDictionary *userInfoList = [RORUserUtils getUserInfoPList];
        NSNumber *missionProcess = (NSNumber *)[userInfoList objectForKey:@"missionProcess"];
        if (missionProcess.integerValue >= 3)
            missionDoneLabel.text = [NSString stringWithFormat:@"%d/%d", missionProcess.integerValue, 3];
    }
}

- (void)viewDidUnload {
    [self setStepLabel:nil];
    [self setDurationLabel:nil];
    [self setRecord:nil];
    [self setDelegate:nil];
    [self setDateLabel:nil];

    [super viewDidUnload];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *destination = segue.destinationViewController;
    if ([destination respondsToSelector:@selector(setDelegate:)]){
        [destination setValue:self forKey:@"delegate"];
    }
    if ([destination respondsToSelector:@selector(setRoutes:)]){
        [destination setValue:[RORDBCommon getRoutesFromString:record.missionRoute] forKey:@"routes"];
    }
    if ([destination respondsToSelector:@selector(setShareImage:)]){
        [destination setValue:img forKey:@"shareImage"];
    }
    
    if ([destination respondsToSelector:@selector(setShareMessage:)]){
        NSString *shareContent = [NSString stringWithFormat:SHARE_DEFAULT_CONTENT,[RORUtils outputDistance:record.distance.doubleValue],[RORUtils transSecondToStandardFormat:record.duration.doubleValue],[NSString stringWithFormat:@"%.1f kca", record.spendCarlorie.doubleValue]];
        [destination setValue:shareContent forKey:@"shareMessage"];
    }
    
    if ([destination respondsToSelector:@selector(setRecord:)]){
        [destination setValue:record forKey:@"record"];
    }
}


- (IBAction)switchSpeedDisplayAction:(id)sender {
    if (self.tableView.alpha == 0){
        self.tableView.alpha = 1;
    } else {
        self.tableView.alpha = 0;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backAction:(id)sender {
    if ([delegate isKindOfClass:[RORRunningBaseViewController class]]){
        [self dismissViewControllerAnimated:YES completion:^(){}];
    } else
        [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int rows = eventList.count + 1;
    return rows;
}

- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = nil;
    UITableViewCell *cell = nil;
    if (indexPath.row == 0) {
        identifier = @"eventCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        UILabel *eventTimeLabel = (UILabel *)[cell viewWithTag:100];
        UILabel *eventLabel = (UILabel *)[cell viewWithTag:101];
        UILabel *effectLabel = (UILabel *)[cell viewWithTag:102];
        eventTimeLabel.text = @"";
        eventLabel.text = @"开始散步";
        effectLabel.text = @"一切看起来都那么美好～";
    } else {
        Action_Define *event = [eventList objectAtIndex:indexPath.row-1];
        if ([event.actionDescription rangeOfString:@"金币"].location != NSNotFound ){
            identifier = @"coinCell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        } else {
            identifier = @"eventCell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            UILabel *eventTimeLabel = (UILabel *)[cell viewWithTag:100];
            UILabel *eventLabel = (UILabel *)[cell viewWithTag:101];
            UILabel *effectLabel = (UILabel *)[cell viewWithTag:102];
            eventLabel.text = event.actionName;
            effectLabel.text = [NSString stringWithFormat:@"获得：%@",event.actionAttribute];
            
            int timeInt = ((NSNumber *)[eventTimeList objectAtIndex:indexPath.row-1]).integerValue;
            eventTimeLabel.text = [NSString stringWithFormat:@"%@的时候",[RORUtils transSecondToStandardFormat:timeInt]];
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0)
        return 62;
    Action_Define *event = [eventList objectAtIndex:indexPath.row-1];
    if ([event.actionDescription rangeOfString:@"金币"].location != NSNotFound ){
        return 30;
    }
    return 62;
}


@end
