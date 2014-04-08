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
    coverViewQueue = [[NSMutableArray alloc]init];
    
    self.backButton.alpha = 0;

    mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:[NSBundle mainBundle]];
    
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
    NSArray *pgStringList = [pgString componentsSeparatedByString:@"-"];
    if (((NSString *)[pgStringList objectAtIndex:0]).length>0){
        [sumString appendString:[NSString stringWithFormat:@"%@", [pgStringList objectAtIndex:0]]];
    }
    //展示获得的道具
    if (((NSString *)[pgStringList objectAtIndex:1]).length>0){
        NSDictionary *itemDict = [RORUtils explainActionEffetiveRule:[pgStringList objectAtIndex:1]];
        self.itemGetScrollView.contentSize = CGSizeMake(5 + [itemDict allKeys].count*(ICON_SIZE_ITEM + 5), 0);
        int i=0;
        totalItems=0;
        for (NSString *key in [itemDict allKeys]){
            NSNumber *thisItemId = [RORDBCommon getNumberFromId:key];
            Virtual_Product *thisItem = [RORVirtualProductService fetchVProduct:thisItemId];
            NSNumber *itemQuantity = (NSNumber *)[itemDict valueForKey:key];
            ItemIconView *itemIconView = [[ItemIconView alloc]initWithFrame:CGRectMake(5 + i*(ICON_SIZE_ITEM + 5), 1, ICON_SIZE_ITEM, ICON_SIZE_ITEM)];
            itemIconView.delegate = self;
            itemIconView.isUsable = NO;//只显示道具信息，不可使用
            [itemIconView fillContentWith:thisItem andQuantity:itemQuantity.integerValue];
            [self.itemGetScrollView addSubview:itemIconView];
            i++;
            
            totalItems += itemQuantity.integerValue;
        }
    }
    
    self.sumLabel.text = sumString;

    [RORUtils setFontFamily:APP_FONT forView:self.view andSubViews:YES];
    
    userBase = [RORUserServices fetchUser:[RORUserUtils getUserId]];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //如果完成了任务
    if ([delegate isKindOfClass:[RORRunningViewController class]]){
        
        //显示结果页面
        ReportViewController *reportViewController =  [mainStoryboard instantiateViewControllerWithIdentifier:@"ReportViewController"];
        [reportViewController customInit:[NSString stringWithFormat:@"x%@", self.sumLabel.text]
                                     Exp:[NSString stringWithFormat:@"x%d", record.experience.intValue]
                                    Coin:[NSString stringWithFormat:@"x%d", record.goldCoin.intValue]
                                 andItem:[NSString stringWithFormat:@"x%d", totalItems]];

        [coverViewQueue addObject:reportViewController];
        
        
        //判断完成任务
        if (record.missionId){
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
            UIViewController *missionDoneViewController =  [mainStoryboard instantiateViewControllerWithIdentifier:@"missionCongratsVIewController"];
            //加入队列
            [coverViewQueue addObject:missionDoneViewController];
//            CoverView *congratsCoverView = (CoverView *)missionDoneViewController.view;
//            [congratsCoverView addCoverBgImage];
//            [self.view addSubview:congratsCoverView];
//            [congratsCoverView appear:self];
            
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
        
        //判断升级
        [self checkLevelUp];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [self dequeueCoverView];
}

-(void)dequeueCoverView{
    for (UIViewController *viewController in coverViewQueue){
        CoverView *congratsCoverView = (CoverView *)viewController.view;
        congratsCoverView.delegate = self;
        [congratsCoverView addCoverBgImage];
        [congratsCoverView appear:self];
        
        [self addChildViewController:viewController];
        [self.view addSubview:congratsCoverView];
        [self didMoveToParentViewController:viewController];

        [coverViewQueue removeObject:viewController];
        break;
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

-(void)checkLevelUp{
    if (!userBase)
        return;
    
    NSMutableDictionary *userInfoList = [RORUserUtils getUserInfoPList];
    NSNumber *userLevel = [userInfoList valueForKey:@"userLevel"];
    
    if (userLevel.integerValue<userBase.userDetail.level.integerValue){
        [self performLevelUp];
    }
}

//弹出升级提示页面
-(void)performLevelUp{
    PooViewController *pooController = [mainStoryboard instantiateViewControllerWithIdentifier:@"levelUpCongratsCoverViewController"];
    [coverViewQueue addObject:pooController];

//    CoverView *coverView = (CoverView *)pooController.view;
//    [coverView addCoverBgImage];
//    [coverView appear:self];
//    
//    [self addChildViewController:pooController];
//    [self.view addSubview:pooController.view];
//    [self didMoveToParentViewController:pooController];
    
    CABasicAnimation *heartsBurst = [CABasicAnimation animationWithKeyPath:@"emitterCells.heart.birthRate"];
	heartsBurst.fromValue		= [NSNumber numberWithFloat:2.0];
	heartsBurst.toValue			= [NSNumber numberWithFloat:  0.0];
	heartsBurst.duration		= 3.0;
	heartsBurst.timingFunction	= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	[pooController.heartsEmitter addAnimation:heartsBurst forKey:@"heartsBurst"];
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
    if ([destination respondsToSelector:@selector(setEventList:)]){
        [destination setValue:eventList forKeyPath:@"eventList"]; //eventDisplayList
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
        if (record.friendName!=nil)
            eventLabel.text = [NSString stringWithFormat:@"与小伙伴%@一起从村里出发了",record.friendName];
        else
            eventLabel.text = @"从村里出发了";
//        eventLabel.text = @"从村里出发";
        effectLabel.text = @"一切看起来都那么美好～";
    } else {
        
        Walk_Event *walkEvent = [eventDisplayList objectAtIndex:indexPath.row-1];
        if ([walkEvent.eType isEqualToString:RULE_Type_Action]){
            identifier = @"eventCell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            UILabel *eventTimeLabel = (UILabel *)[cell viewWithTag:100];
            UILabel *eventLabel = (UILabel *)[cell viewWithTag:101];
            UILabel *effectLabel = (UILabel *)[cell viewWithTag:102];
            
            Action_Define *actionEvent = [RORSystemService fetchActionDefine:walkEvent.eId];
            eventLabel.text = actionEvent.actionName;
            effectLabel.text = [NSString stringWithFormat:@"获得：%@",actionEvent.actionAttribute];
            eventTimeLabel.text = [NSString stringWithFormat:@"%@的时候",[RORUtils transSecondToStandardFormat:walkEvent.times.integerValue]];
        } else {
            identifier = @"fightCell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            UILabel *eventTimeLabel = (UILabel *)[cell viewWithTag:100];
            UILabel *eventLabel = (UILabel *)[cell viewWithTag:101];
            UILabel *effectLabel = (UILabel *)[cell viewWithTag:102];
            
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
    [RORUtils setFontFamily:APP_FONT forView:cell andSubViews:YES];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    double newCellHeight = 75;
    if (indexPath.row>0){
        Walk_Event *event = [eventDisplayList objectAtIndex:indexPath.row-1];
        if ([event.eType isEqualToString:RULE_Type_Fight]){
            newCellHeight = 110;
        }
    }
    return newCellHeight;
}

#pragma mark - Cover View Delegate

-(void)coverViewDidDismissed:(id)view{
    [self dequeueCoverView];
}

@end
