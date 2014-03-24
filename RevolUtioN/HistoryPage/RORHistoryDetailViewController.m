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
    if (record.actionIds){
        NSArray *objList = [RORUtils toArrayFromJson:record.actionIds];
        eventList = [[NSMutableArray alloc]init];
        for (NSDictionary *objDict in objList) {
            Walk_Event *walkEvent = [[Walk_Event alloc]initWithDictionary:objDict];
            [eventList addObject:walkEvent];
        }
        eventDisplayList = [[NSMutableArray alloc]init];
        for (Walk_Event *walkEvent in eventList) {
            if ([walkEvent.eType isEqualToString:RULE_Type_Action]){
                Action_Define *actionEvent = [RORSystemService fetchActionDefine:walkEvent.eId];
                if ([actionEvent.actionName rangeOfString:@"金币"].location == NSNotFound){
                    [eventDisplayList addObject:walkEvent];
                }
            } else {
                [eventDisplayList addObject:walkEvent];
            }
        }
    }

    [self.sumLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.sumLabel.numberOfLines = 0;
    NSString *pgString =record.propGet;
    NSMutableString *sumString = [[NSMutableString alloc]init];
    NSArray *pgStringList = [pgString componentsSeparatedByString:@"|"];
    if (((NSString *)[pgStringList objectAtIndex:0]).length>0){
        [sumString appendString:[NSString stringWithFormat:@"共获得%@场战斗胜利\n", [pgStringList objectAtIndex:0]]];
    }
    if (((NSString *)[pgStringList objectAtIndex:1]).length>0){
        [sumString appendString:[NSString stringWithFormat:@"获得道具：%@\n", [pgStringList objectAtIndex:1]]];
    }

    self.sumLabel.text = sumString;

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //如果完成了任务
    if (record.missionId && [delegate isKindOfClass:[RORRunningViewController class]]){
        Mission *doneMission = [RORMissionServices fetchMission:record.missionId];

        //保存任务数据
        User_Mission_History *mh = [User_Mission_History intiUnassociateEntity];
        mh.userId = [RORUserUtils getUserId];
        mh.userName = [RORUserUtils getUserName];
        mh.missionId = record.missionId;
        mh.missionName = doneMission.missionName;
        mh.missionStatus = [NSNumber numberWithInteger: MissionStatusDone];
        mh.missionTypeId = doneMission.missionTypeId;
        mh.startTime = record.missionStartTime;
        mh.endTime = record.missionEndTime;
        [RORMissionHistoyService saveMissionHistoryInfoToDB:mh];
        //显示任务完成提示
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:[NSBundle mainBundle]];
        UIViewController *missionDoneViewController =  [mainStoryboard instantiateViewControllerWithIdentifier:@"missionCongratsVIewController"];
        CoverView *congratsCoverView = (CoverView *)missionDoneViewController.view;
        [congratsCoverView addCoverBgImage];
        [self.view addSubview:congratsCoverView];
        [congratsCoverView appear:self];
        
        UIView *missionCongratsView = missionDoneViewController.view;
        UILabel *missionNameLabel = (UILabel *)[missionCongratsView viewWithTag:100];
        UILabel *missionGoldLabel = (UILabel *)[missionCongratsView viewWithTag:101];
        UILabel *missionExpLabel = (UILabel *)[missionCongratsView viewWithTag:102];
        UILabel *missionDoneLabel = (UILabel *)[missionCongratsView viewWithTag:103];
        
        missionNameLabel.text = doneMission.missionDescription;
        missionGoldLabel.text = [NSString stringWithFormat:@"+%ld",(long)doneMission.goldCoin.integerValue];
        missionExpLabel.text = [NSString stringWithFormat:@"+%ld",(long)doneMission.experience.integerValue];
        
        NSMutableDictionary *userInfoList = [RORUserUtils getUserInfoPList];
        NSNumber *missionProcess = (NSNumber *)[userInfoList objectForKey:@"missionProcess"];
        if (missionProcess.integerValue >= 3)
            missionDoneLabel.text = [NSString stringWithFormat:@"%ld/%d", (long)missionProcess.integerValue, 3];
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
    NSInteger rows = eventDisplayList.count + 1;
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
        eventLabel.text = @"从村里出发";
        effectLabel.text = @"一切看起来都那么美好～";
    } else {
        identifier = @"eventCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        UILabel *eventTimeLabel = (UILabel *)[cell viewWithTag:100];
        UILabel *eventLabel = (UILabel *)[cell viewWithTag:101];
        UILabel *effectLabel = (UILabel *)[cell viewWithTag:102];
        Walk_Event *walkEvent = [eventDisplayList objectAtIndex:indexPath.row-1];
        if ([walkEvent.eType isEqualToString:RULE_Type_Action]){
            Action_Define *actionEvent = [RORSystemService fetchActionDefine:walkEvent.eId];
            eventLabel.text = actionEvent.actionName;
            effectLabel.text = [NSString stringWithFormat:@"获得：%@",actionEvent.actionAttribute];
            eventTimeLabel.text = [NSString stringWithFormat:@"%@的时候",[RORUtils transSecondToStandardFormat:walkEvent.times.integerValue]];
        } else {
            Fight_Define *fightEvent = [RORSystemService fetchFightDefineInfo:walkEvent.eId];
            if (walkEvent.eWin.integerValue>0){
                eventLabel.text = fightEvent.fightWin;
                effectLabel.text = [NSString stringWithFormat:@"获得：%@",fightEvent.winGot];
            } else{
                eventLabel.text = fightEvent.fightLoose;
                effectLabel.text = [NSString stringWithFormat:@""];
            }
            eventTimeLabel.text = [NSString stringWithFormat:@"%@的时候",[RORUtils transSecondToStandardFormat:walkEvent.times.integerValue]];
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 62;
}


@end
