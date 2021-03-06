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
    
    self.backButton.alpha = 0;

    mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:[NSBundle mainBundle]];
    totalStepString = [RORUtils formattedSteps:record.steps.integerValue];
    durationString = [RORUtils transSecondToStandardFormat:record.duration.integerValue];
    
    NSDateFormatter *formattter = [[NSDateFormatter alloc] init];
    [formattter setDateFormat:@"yyyy-MM-dd"];
    dateString = [NSString stringWithFormat:@"%@", [formattter stringFromDate:record.missionDate]];
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
    
    NSString *pgString =record.propGet;
    NSMutableString *ss = [[NSMutableString alloc]init];
    NSArray *pgStringList = [pgString componentsSeparatedByString:@"-"];
    if (((NSString *)[pgStringList objectAtIndex:0]).length>0){
        [ss appendString:[NSString stringWithFormat:@"%@", [pgStringList objectAtIndex:0]]];
    }
    sumString = [NSString stringWithFormat:@"获得%@场战斗胜利。\n获得%@个金币。",ss,record.goldCoin];
    winString = [NSString stringWithFormat:@"%@", ss];
    
    self.rightShadow.alpha = 0;
    self.leftShadow.alpha = 0;
    
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
        self.rightShadow.alpha = ([itemDict allKeys].count>5);
        self.leftShadow.alpha = ([itemDict allKeys].count>5);
    }
    

    [RORUtils setFontFamily:APP_FONT forView:self.view andSubViews:YES];
    
    userBase = [RORUserServices fetchUser:[RORUserUtils getUserId]];
    
    showCongrats = NO;
    if ([delegate isKindOfClass:[RORRunningViewController class]]){
        showCongrats = YES;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"RORHistoryDetailViewController"];
      [MTA trackPageViewBegin:@"RORHistoryDetailViewController"];
    //如果完成了任务
    if (showCongrats){//[delegate isKindOfClass:[RORRunningViewController class]]){
        
        showCongrats = NO;
        
        //显示结果页面
        NSString *commentText;
        if (record.steps.intValue<200){
            commentText = @"你是猴子请来的逗B么？";
        } else if (record.steps.intValue<1200){
            commentText = @"少年还需努力！";
        } else {
            commentText = @"干得漂亮！";
        }
        ReportViewController *reportViewController =  [mainStoryboard instantiateViewControllerWithIdentifier:@"ReportViewController"];
        [reportViewController customInit:[NSString stringWithFormat:@"%@", winString]
                                     Exp:[NSString stringWithFormat:@"+%d", record.experience.intValue]
                                    Coin:[NSString stringWithFormat:@"+%d", record.goldCoin.intValue]
                                    Item:[NSString stringWithFormat:@"%d", totalItems]
                                    Fat:[NSString stringWithFormat:@"+%d", -record.fatness.intValue]
                                    andComment:commentText];

        [coverViewQueue addObject:reportViewController];
        
        
        //判断完成任务
        if (record.missionId){
            Mission *doneMission = [RORMissionServices fetchMission:record.missionId];

            //保存任务数据
            User_Mission_History *mh = [User_Mission_History intiUnassociateEntity:[RORContextUtils getPrivateContext]];
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
            
            if (missionProcess.intValue < 3)
                missionDoneLabel.text = [NSString stringWithFormat:@"再完成%d次任务获得奖励", 3-missionProcess.intValue];
            else
                missionDoneLabel.text = @"快去首页看看宝箱里有什么吧！";
        }
        
        //判断升级
        [self checkLevelUp];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"RORHistoryDetailViewController"];
}

-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [MTA trackPageViewEnd:@"RORHistoryDetailViewController"];
}

- (void)viewDidUnload {
    [self setRecord:nil];
    [self setDelegate:nil];

    [super viewDidUnload];
}

-(void)checkLevelUp{
    if (!userBase)
        return;
    
    NSMutableDictionary *userInfoList = [RORUserUtils getUserInfoPList];
    NSNumber *userLevel = [userInfoList valueForKey:@"userLevel"];
    if (userLevel.intValue == 0){
        [userInfoList setValue:userBase.userDetail.level forKey:@"userLevel"];
        [RORUserUtils writeToUserInfoPList:userInfoList];
    } else if (userLevel.integerValue<userBase.userDetail.level.integerValue){
        [self performLevelUp];
    }
}

//弹出升级提示页面
-(void)performLevelUp{
    [MobClick event:@"levelUpTimes"];
    [MTA trackCustomKeyValueEvent:@"levelUpTimes" props:nil];
    PooViewController *pooController = [mainStoryboard instantiateViewControllerWithIdentifier:@"levelUpCongratsCoverViewController"];
    [coverViewQueue addObject:pooController];
 
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

-(IBAction)fightIconAction:(id)sender{
    FightIconButton *btn = (FightIconButton*)sender;
    [self sendNotification:[NSString stringWithFormat:@"%@怪物",FightStage_toString[btn.fightStage]]];
}

- (IBAction)shareAction:(id)sender {
    HistoryShareView *testView = [[HistoryShareView alloc]initWithFrame:CGRectMake(0, 0, 320, 0)];
    for (int i=0; i<eventDisplayList.count+1; i++){
//        UIImage *image =[RORUtils getImageFromView:];
        UIView *iv = [self viewForRow:i];
        iv.frame = CGRectMake(0, 0, iv.frame.size.width, iv.frame.size.height);
        [testView add:iv];
    }
    
    NSString *msg = [NSString stringWithFormat:@"#报告村长#，我刚才出去探险，碰到了%d件奇奇怪怪的事情",eventDisplayList.count];
    
    [RORUtils popShareCoverViewFor:self withImage:[testView getImage] title:@"分享这个页面" andMessage:msg animated:YES];
}

-(UITableViewCell*)viewForRow:(int)row{
    NSString *identifier = nil;
    UITableViewCell *cell = nil;
    
    if (row==0){
        identifier = @"sumCell";
        cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
        UILabel *dateLabel = (UILabel *)[cell viewWithTag:101];
        UILabel *durationLabel = (UILabel *)[cell viewWithTag:102];
        UILabel *totalStepLabel = (UILabel *)[cell viewWithTag:103];
        UILabel *sumLabel = (UILabel *)[cell viewWithTag:104];
        [sumLabel setLineBreakMode:NSLineBreakByWordWrapping];
        sumLabel.numberOfLines = 3;
        
        dateLabel.text = dateString;
        durationLabel.text = durationString;
        totalStepLabel.text = totalStepString;
        sumLabel.text = sumString;
    } else {
        Walk_Event *walkEvent = [eventDisplayList objectAtIndex:row-1];
        if ([walkEvent.eType isEqualToString:RULE_Type_Action]){
            identifier = @"eventCell";
            cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
            UILabel *eventTimeLabel = (UILabel *)[cell viewWithTag:100];
            UILabel *eventLabel = (UILabel *)[cell viewWithTag:101];
            UILabel *effectLabel = (UILabel *)[cell viewWithTag:102];
            [eventLabel setLineBreakMode:NSLineBreakByWordWrapping];
            eventLabel.numberOfLines = 3;
            
            Action_Define *actionEvent = [RORSystemService fetchActionDefine:walkEvent.eId];
            eventLabel.text = actionEvent.actionName;
            if (actionEvent.actionAttribute)
                effectLabel.text = [NSString stringWithFormat:@"获得：%@",actionEvent.actionAttribute];
            else
                effectLabel.text = @"";
            eventTimeLabel.text = [NSString stringWithFormat:@"%@的时候",[RORUtils transSecondToStandardFormat:walkEvent.times.integerValue]];
        } else if ([walkEvent.eType isEqualToString:RULE_Type_Fight]){
            Fight_Define *fightEvent = [RORSystemService fetchFightDefineInfo:walkEvent.eId];
            
            identifier = @"fightCell";
            cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
            UILabel *eventTimeLabel = (UILabel *)[cell viewWithTag:100];
            UILabel *eventLabel = (UILabel *)[cell viewWithTag:101];
            [eventLabel setLineBreakMode:NSLineBreakByWordWrapping];
            eventLabel.numberOfLines = 3;
            UILabel *effectLabel = (UILabel *)[cell viewWithTag:102];
            [effectLabel setLineBreakMode:NSLineBreakByWordWrapping];
            effectLabel.numberOfLines = 0;
            UILabel *expLabel = (UILabel *)[cell viewWithTag:103];
            FightIconButton *iconImageView = (FightIconButton *)[cell viewWithTag:200];
            iconImageView.fightStage = fightEvent.monsterLevel.intValue;
            [iconImageView addTarget:self action:@selector(fightIconAction:) forControlEvents:UIControlEventTouchUpInside];
            
            NSArray *meetText = [fightEvent.fightName componentsSeparatedByString:@"。"];
            NSMutableString *fightText = [[NSMutableString alloc]initWithString:[meetText objectAtIndex:0]];
            
            if (walkEvent.eWin.integerValue>0){
                NSArray *winTextList = [fightEvent.fightWin componentsSeparatedByString:@"|"];
                [fightText appendString:[NSString stringWithFormat:@"，%@",(NSString *)[winTextList objectAtIndex:walkEvent.eWin.intValue/10]]];
                
                if (walkEvent.eWin.integerValue%10>1 && fightEvent.winGot)
                    effectLabel.text = [NSString stringWithFormat:@"获得：%@",fightEvent.winGot];
                else
                    effectLabel.text = [NSString stringWithFormat:@"未获得战利品"];
            } else {
                NSArray *winTextList = [fightEvent.fightLoose componentsSeparatedByString:@"|"];
                [fightText appendString:[NSString stringWithFormat:@"，%@",(NSString *)[winTextList objectAtIndex:abs(walkEvent.eWin.intValue/10)]]];
                effectLabel.text = [NSString stringWithFormat:@"未获得战利品"];
            }
            [fightText appendString:[meetText objectAtIndex:1]];
            eventLabel.text = fightText;
            eventTimeLabel.text = [NSString stringWithFormat:@"%@的时候",[RORUtils transSecondToStandardFormat:walkEvent.times.integerValue]];
            double powerCost;
            if (walkEvent.eWin.integerValue%10==3){
                powerCost = fightEvent.basePowerConsume.doubleValue/2;
            } else {
                powerCost = fightEvent.basePowerConsume.doubleValue;
            }
            expLabel.text = [NSString stringWithFormat:@"经验值+%@  体力-%.0f", fightEvent.baseExperience, powerCost];
        } else if ([walkEvent.eType isEqualToString:RULE_Type_Fight_Friend]){
            identifier = @"fightCell";
            cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
            UILabel *eventTimeLabel = (UILabel *)[cell viewWithTag:100];
            UILabel *eventLabel = (UILabel *)[cell viewWithTag:101];
            [eventLabel setLineBreakMode:NSLineBreakByWordWrapping];
            eventLabel.numberOfLines = 0;
            UILabel *effectLabel = (UILabel *)[cell viewWithTag:102];
            UILabel *expLabel = (UILabel *)[cell viewWithTag:103];
            FightIconButton *iconImageView = (FightIconButton *)[cell viewWithTag:200];
            iconImageView.fightStage = FightStageEasy;
            [iconImageView addTarget:self action:@selector(fightIconAction:) forControlEvents:UIControlEventTouchUpInside];
            
            Friend *fightFriend = [RORFriendService fetchUserFriend:userBase.userId withFriendId:walkEvent.eId];
            
            NSMutableString *fightString = [[NSMutableString alloc]init];
            if (walkEvent.eWin.integerValue>0){
                NSArray *winTextList = [SENTENCE_FRIEND_FIGHT_WIN componentsSeparatedByString:@"|"];
                NSString *formatString = (NSString *)[winTextList objectAtIndex:walkEvent.eWin.intValue/10];
                [fightString appendString:[NSString stringWithFormat:formatString, fightFriend.userName]];
                effectLabel.text = @"获得：荣誉+1";
            } else {
                NSArray *winTextList = [SENTENCE_FRIEND_FIGHT_LOSE componentsSeparatedByString:@"|"];
                NSString *formatString = (NSString *)[winTextList objectAtIndex:abs(walkEvent.eWin.intValue/10)];
                [fightString appendString:[NSString stringWithFormat:formatString, fightFriend.userName]];
                effectLabel.text = @"未获得战利品";
            }
            [fightString appendString:[NSString stringWithFormat:@"（等级%@战斗）", fightFriend.level]];
            eventLabel.text = fightString;
            eventTimeLabel.text = [NSString stringWithFormat:@"%@的时候",[RORUtils transSecondToStandardFormat:walkEvent.times.integerValue]];
            expLabel.text = [NSString stringWithFormat:@"体力-%@", walkEvent.power];
            
        }else if ([walkEvent.eType isEqualToString:RULE_Type_Start]){ //出发事件
            identifier = @"eventCell";
            cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
            
            UILabel *eventTimeLabel = (UILabel *)[cell viewWithTag:100];
            UILabel *eventLabel = (UILabel *)[cell viewWithTag:101];
            UILabel *effectLabel = (UILabel *)[cell viewWithTag:102];
            [eventLabel setLineBreakMode:NSLineBreakByWordWrapping];
            eventLabel.numberOfLines = 3;
            eventTimeLabel.text = @"";
            if (record.friendName!=nil)
                eventLabel.text = [NSString stringWithFormat:[RORUtils getSentencebyRule:RULE_Type_Start eId10:walkEvent.eId.intValue andSentence:SENTENCE_START_WALKING_WITH],record.friendName];
            else
                eventLabel.text = [RORUtils getSentencebyRule:RULE_Type_Start eId10:walkEvent.eId.intValue andSentence:SENTENCE_START_WALKING_ALONE];
            effectLabel.text = @"一切看起来都那么美好～";
        }
    }
    
    [RORUtils setFontFamily:APP_FONT forView:cell andSubViews:YES];
    return cell;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = eventDisplayList.count+1;
    return rows;
}

- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    return [self viewForRow:indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    double newCellHeight = 110;
    if (indexPath.row==0){
        return 130;
    }
    if (indexPath.row>1){
        Walk_Event *event = [eventDisplayList objectAtIndex:indexPath.row-1];
        if ([event.eType isEqualToString:RULE_Type_Fight_Friend] || [event.eType isEqualToString:RULE_Type_Fight]){
            newCellHeight = 140;
        }
    }
    return newCellHeight;
}



@end
