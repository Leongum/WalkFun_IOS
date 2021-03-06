//
//  RORMainViewController.m
//  WalkFun
//
//  Created by Bjorn on 14-2-14.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//
#define kStrokeSize (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 6.0f : 1.5f)

#import "RORMainViewController.h"
#import "FTAnimation.h"
#import "Animations.h"

@interface RORMainViewController ()

@end

@implementation RORMainViewController
@synthesize contentViews, noteString;

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
    noteString = nil;
    self.backButton.alpha = 0;
    
	// Do any additional setup after loading the view.
    
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i <PAGE_QUANTITY; i++)
		[controllers addObject:[NSNull null]];
    
    self.contentViews = controllers;
    mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:[NSBundle mainBundle]];
    UIStoryboard *friendStoryboard = [UIStoryboard storyboardWithName:@"FriendsStoryboard" bundle:[NSBundle mainBundle]];
    
    firstViewController =  [mainStoryboard instantiateViewControllerWithIdentifier:@"firstViewContoller"];
    friendViewController =  [friendStoryboard instantiateViewControllerWithIdentifier:@"FriendsMainViewController"];
    UIStoryboard *itemStoryboard = [UIStoryboard storyboardWithName:@"ItemsStoryboard" bundle:[NSBundle mainBundle]];
    itemViewController =  [itemStoryboard instantiateViewControllerWithIdentifier:@"ItemsMainViewController"];
    
    [contentViews replaceObjectAtIndex:0 withObject:itemViewController];
    [contentViews replaceObjectAtIndex:2 withObject:friendViewController];
    [contentViews replaceObjectAtIndex:1 withObject:firstViewController];
    
    NSInteger numberPages = contentViews.count;
    // a page is the width of the scroll view
    
    self.scrollView.contentSize =
    CGSizeMake(CGRectGetWidth(self.scrollView.frame) * numberPages, 0);
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    
    self.pageControl.numberOfPages = numberPages;
    self.pageControl.currentPage = 1;
    
    for (int i=0; i<PAGE_QUANTITY; i++)
        [self loadPage:i];
    
    [self gotoPage:NO];
    
    missionBoardCenterY = self.missionView.center.y;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(allBackendSyncMethod:) name:@"Notification_GetUserAndSystemDetails" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userBackendSyncMethod:) name:@"Notification_GetUserDetails" object:nil];
    [RORUtils setFontFamily:APP_FONT forView:self.view andSubViews:YES];
    
}

-(void)checkDailyMission{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        todayMission = [RORMissionServices getTodayMission];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (todayMission){
                NSMutableDictionary *userInfoList = [RORUserUtils getUserInfoPList];
                NSNumber *missionUseItemQuantity = [userInfoList valueForKey:@"missionUseItemQuantity"];
                if (todayMission.missionTypeId.integerValue == MissionTypeUseItem){
                    if (missionUseItemQuantity.integerValue<0 || missionUseItemQuantity==nil){
                        //接到使用道具的任务，初始化missionUseItemQuantity为总次数
                        [userInfoList setObject:todayMission.triggerNumbers forKey:@"missionUseItemQuantity"];
                        [RORUserUtils writeToUserInfoPList:userInfoList];
                    } else {
                        //如果使用道具的任务完成了
                        if (missionUseItemQuantity.integerValue == 0){
                            //保存任务数据
                            User_Mission_History *mh = [User_Mission_History intiUnassociateEntity:[RORContextUtils getPrivateContext]];
                            mh.userId = [RORUserUtils getUserId];
                            mh.userName = [RORUserUtils getUserName];
                            mh.missionId = todayMission.missionId;
                            mh.missionName = todayMission.missionName;
                            mh.missionStatus = [NSNumber numberWithInteger: MissionStatusDone];
                            mh.missionTypeId = todayMission.missionTypeId;
                            mh.startTime = [NSDate date];
                            mh.endTime = [NSDate date];
                            [RORMissionHistoyService saveMissionHistoryInfoToDB:mh];
                            
                            //显示任务完成提示
                            UIViewController *missionDoneViewController =  [mainStoryboard instantiateViewControllerWithIdentifier:@"missionCongratsVIewController"];
                            [coverViewQueue addObject:missionDoneViewController];
                            //                    CoverView *congratsCoverView = (CoverView *)missionDoneViewController.view;
                            //                    [congratsCoverView addCoverBgImage:[RORUtils captureScreen] grayed:YES];
                            //                    [self.view addSubview:congratsCoverView];
                            //                    [congratsCoverView appear:self];
                            
                            UIView *missionCongratsView = missionDoneViewController.view;
                            UILabel *missionNameLabel = (UILabel *)[missionCongratsView viewWithTag:100];
                            UILabel *missionGoldLabel = (UILabel *)[missionCongratsView viewWithTag:101];
                            UILabel *missionExpLabel = (UILabel *)[missionCongratsView viewWithTag:102];
                            UILabel *missionDoneLabel = (UILabel *)[missionCongratsView viewWithTag:103];
                            
                            missionNameLabel.text = todayMission.missionDescription;
                            missionGoldLabel.text = [NSString stringWithFormat:@"+%d",todayMission.goldCoin.intValue];
                            missionExpLabel.text = [NSString stringWithFormat:@"+%d",todayMission.experience.intValue];
                            NSMutableDictionary *userInfoList = [RORUserUtils getUserInfoPList];
                            NSNumber *missionProcess = (NSNumber *)[userInfoList objectForKey:@"missionProcess"];
                            int mp = missionProcess.intValue;
                            if (++mp>3)
                                mp = 3;
                            //修改plist中的任务相关标记
                            [userInfoList setObject:[NSNumber numberWithInteger:mp] forKey:@"missionProcess"];
                            [userInfoList setObject:[NSNumber numberWithInteger:-1] forKey:@"missionUseItemQuantity"];
                            [userInfoList setObject:[NSDate date] forKey:@"lastDailyMissionFinishedDate"];
                            [RORUserUtils writeToUserInfoPList:userInfoList];
                            
                            if (mp < 3)
                                missionDoneLabel.text = [NSString stringWithFormat:@"再完成%d次任务获得奖励", 3-mp];
                            else
                                missionDoneLabel.text = @"快去首页看看宝箱里有什么吧！";
                            return;
                        }
                    }
                }
                
                if (missionUseItemQuantity.intValue>0){
                    [userInfoList setObject:[NSNumber numberWithInteger:-1] forKey:@"missionUseItemQuantity"];
                    [RORUserUtils writeToUserInfoPList:userInfoList];
                }
                
                self.missionContentLabel.text = todayMission.missionDescription;
                [Animations moveUp:self.missionView andAnimationDuration:1 andWait:NO andLength:100];
            }
            isFolded = NO;
        });
    });
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"RORMainViewController"];
    [MTA trackPageViewBegin:@"RORMainViewController"];
    //未登录
    if ([RORUserUtils getUserId].integerValue<0) {
        //        UIViewController *loginViewController =  [mainStoryboard instantiateViewControllerWithIdentifier:@"RORLoginNavigatorController"];
        //        [self presentViewController:loginViewController animated:NO completion:NULL];
    } else {
        userBase = [RORUserServices fetchUser:[RORUserUtils getUserId]];
        //还未设置性别
        if ((![userBase.sex isEqualToString:@"男"]) && (![userBase.sex isEqualToString:@"女"])){
            //            UIViewController *loginViewController =  [mainStoryboard instantiateViewControllerWithIdentifier:@"SexSelectionViewController"];
            //            [self presentViewController:loginViewController animated:NO completion:^(){}];
        } else {
            //刷新页面
            for (int i=0; i<PAGE_QUANTITY; i++){
                UIViewController *controller =(UIViewController *)[contentViews objectAtIndex:i];
                [controller viewWillAppear:NO];
            }
            //看是否有新的恩仇录
            NSNumber *aQnum = (NSNumber *)[[RORUserUtils getUserInfoPList] objectForKey:@"MessageReceivedNumber"];
            //看是否有新的公告
            NSDictionary *settingDict = [RORUserUtils getUserSettingsPList];
            NSNumber *fdv= [settingDict objectForKey:@"formerDescVersion"];
            NSNumber *dv = [settingDict objectForKey:@"DescVersion"];
            //看是否有新版本
            NSNumber *mainVersion = [settingDict objectForKey:@"MainVersion"];
            NSNumber *subVersion = [settingDict objectForKey:@"SubVersion"];
            if (((!fdv) || fdv.intValue < dv.intValue) || //有新公告
                (aQnum && aQnum.intValue>0) || //有新恩仇录
                (mainVersion.intValue > CURRENT_VERSION_MAIN || subVersion.intValue > CURRENT_VERSION_SUB)) //有新版本
                self.msgNoteImageView.alpha = 1;
            else
                self.msgNoteImageView.alpha = 0;
            
            //检查是否需要显示提示信息
            [self checkPinchInstruction];
//            [self checkMissionStoneInstruction];
//            [self checkMainPageInstruction];
//            [self checkSyncInstruction];
//            [self checkHistoryInstruction];
        }
    }
    self.missionView.center = CGPointMake(self.missionView.center.x, missionBoardCenterY);
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"RORMainViewController"];
}

-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [MTA trackPageViewEnd:@"RORMainViewController"];
}

-(void)viewDidAppear:(BOOL)animated{
    self.missionView.center = CGPointMake(self.missionView.center.x, missionBoardCenterY);

    if ([RORUserUtils getUserId].integerValue<0) {
        UIViewController *loginViewController =  [mainStoryboard instantiateViewControllerWithIdentifier:@"RORLoginNavigatorController"];
        [self presentViewController:loginViewController animated:NO completion:NULL];
    } else {
        if ((![userBase.sex isEqualToString:@"男"]) && (![userBase.sex isEqualToString:@"女"])){
            UIViewController *loginViewController =  [mainStoryboard instantiateViewControllerWithIdentifier:@"SexSelectionViewController"];
            [self presentViewController:loginViewController animated:NO completion:^(){}];
        }
    }
    
    [self checkFirstOpenInstruction];
    [self checkItemPageInstruction];
    [self checkFriendPageInstruction];

    //检查日常任务
    [self checkDailyMission];
    //检查是否提示玩家去appstore评价
    [self checkSendToAppstore];
    
    if (noteString!=nil){
        NSArray *stringList = [noteString componentsSeparatedByString:@"\n"];
        for (NSString *itString in stringList){
            NoteAnimationCoverView *noteCover = [[NoteAnimationCoverView alloc]initWithFrame:self.view.bounds andNoteText:itString];
            [coverViewQueue addObject:noteCover];
        }
//        [self dequeueCoverView];
        noteString = nil;
    }
    
    [super viewDidAppear:animated];
}

-(void)checkMainPageInstruction{
    NSMutableDictionary *dict = [RORUserUtils getUserInfoPList];
    NSNumber *n = (NSNumber *)[dict objectForKey:@"MainPageInstruction"];
    NSNumber *foi = (NSNumber *)[dict objectForKey:@"FirstOpenInstruction"];
    if (userBase && !n && self.pageControl.currentPage == 1 && foi){
        if (userBase.userDetail.level.intValue<2)
            return;
        
        CoverView *instructionCV = [[CoverView alloc]initWithFrame:self.view.frame];
        instructionCV.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
        [instructionCV addCoverBgImage:[UIImage imageNamed:@"intro_mainpage.png"] grayed:NO];
        [coverViewQueue addObject:instructionCV];
        
        [dict setObject:[NSNumber numberWithInt:1] forKey:@"MainPageInstruction"];
        [RORUserUtils writeToUserInfoPList:dict];
    }
}

-(void)checkMissionStoneInstruction{
    NSMutableDictionary *dict = [RORUserUtils getUserInfoPList];
    NSNumber *n = (NSNumber *)[dict objectForKey:@"MissionStoneInstruction"];
    NSNumber *mpi = (NSNumber *)[dict objectForKey:@"MainPageInstruction"];
    if (userBase && !n && mpi && self.pageControl.currentPage == 1){
        CoverView *instructionCV = [[CoverView alloc]initWithFrame:self.view.frame];
        instructionCV.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
        [instructionCV addCoverBgImage:[UIImage imageNamed:@"intro_missionstone.png"] grayed:NO];
        [coverViewQueue addObject:instructionCV];
        
        [dict setObject:[NSNumber numberWithInt:1] forKey:@"MissionStoneInstruction"];
        [RORUserUtils writeToUserInfoPList:dict];
    }
}

-(void)checkFirstOpenInstruction{
    InstructionCoverView *startInstruction = [[InstructionCoverView alloc]initWithFrame:self.view.bounds thisKey:InstructionOrder_toString[0]  andActiveRegionFrame:self.ready2StartButton.frame];
    [startInstruction addNoteText:@"当你准备开始走路了，点击这里准备出发"];
    [startInstruction addTriggerForerunnerKey:nil minLevel:0];
    [startInstruction addAction:self withSelector:@selector(ready2StartAction:)];
    [startInstruction setOnlyChoice:NO];
    [coverViewQueue addObject:startInstruction];
}

-(void)checkItemPageInstruction{
    InstructionCoverView *itemPageInstruction = [[InstructionCoverView alloc]initWithFrame:self.view.bounds thisKey:InstructionOrder_toString[3]  andActiveRegionFrame:CGRectMake(350, 0, 0, 0)];
    [itemPageInstruction addNoteText:@"向右滑动，可以进入道具页面"];
    [itemPageInstruction addTriggerForerunnerKey:InstructionOrder_toString[2] minLevel:0];
    [itemPageInstruction addAction:self withSelector:nil];
    [itemPageInstruction setOnlyChoice:NO];
    [coverViewQueue addObject:itemPageInstruction];
}

-(void)checkItemMallInstruction{
    InstructionCoverView *instruction = [[InstructionCoverView alloc]initWithFrame:self.view.bounds thisKey:InstructionOrder_toString[4]  andActiveRegionFrame:CGRectMake(209, 10, 83, 61)];
    [instruction addNoteText:@"点这里可以进入道具商城"];
    [instruction addTriggerForerunnerKey:InstructionOrder_toString[3] minLevel:0];
    [instruction addAction:itemViewController withSelector:@selector(mallAction:)];
    [instruction setOnlyChoice:NO];
    [coverViewQueue addObject:instruction];
}

-(void)checkFriendPageInstruction{
    InstructionCoverView *instruction = [[InstructionCoverView alloc]initWithFrame:self.view.bounds thisKey:InstructionOrder_toString[5]  andActiveRegionFrame:CGRectMake(350, 0, 0, 0)];
    [instruction addNoteText:@"向左滑动，可以进入好友页面"];
    [instruction addTriggerForerunnerKey:InstructionOrder_toString[4] minLevel:0];
    [instruction addAction:self withSelector:nil];
    [instruction setOnlyChoice:NO];
    [coverViewQueue addObject:instruction];
}

-(void)checkAddFriendInstruction{
    InstructionCoverView *instruction = [[InstructionCoverView alloc]initWithFrame:self.view.bounds thisKey:InstructionOrder_toString[6]  andActiveRegionFrame:CGRectMake(256, 18, 38, 38)];
    [instruction addNoteText:@"点这里可以添加好友"];
    [instruction addTriggerForerunnerKey:InstructionOrder_toString[5] minLevel:0];
    [instruction addAction:itemViewController withSelector:@selector(mallAction:)];
    [instruction setOnlyChoice:NO];
    [coverViewQueue addObject:instruction];
}

-(void)checkPinchInstruction{
    NSMutableDictionary *dict = [RORUserUtils getUserInfoPList];
    NSNumber *n = (NSNumber *)[dict objectForKey:@"PinchInstruction"];
    NSNumber *msi = (NSNumber *)[dict objectForKey:InstructionOrder_toString[6]];
    if (userBase && !n && msi){
        CoverView *instructionCV = [[CoverView alloc]initWithFrame:self.view.frame];
        instructionCV.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
        [instructionCV addCoverBgImage:[UIImage imageNamed:@"intro_Pinch.png"] grayed:NO];
        [coverViewQueue addObject:instructionCV];
        
        [dict setObject:[NSNumber numberWithInt:1] forKey:@"PinchInstruction"];
        [RORUserUtils writeToUserInfoPList:dict];
    }
}

-(void)checkSendToAppstore{
    NSMutableDictionary *dict = [RORUserUtils getUserInfoPList];
    NSNumber *n = (NSNumber *)[dict objectForKey:@"AppOpenCounter"];
    if (n.integerValue>5 && n.integerValue<1000){
        alertType = ALERT_TYPE_TOAPPSTORE;
        n = [NSNumber numberWithInteger:1001];
        [dict setObject:n forKey:@"AppOpenCounter"];
        [RORUserUtils writeToUserInfoPList:dict];
        
        NSString *msg;
        if ([userBase.sex isEqualToString:@"男"])
            msg = @"大爷，帮忙给个好评呗？么么哒！";
        else
            msg = @"美女，帮忙给个好评呗？么么哒！";
        UIAlertView *confirmView = [[UIAlertView alloc] initWithTitle:@"求评价" message:msg delegate:self cancelButtonTitle:@"走开" otherButtonTitles:@"好说好说", nil];
        [confirmView show];
        confirmView = nil;
    }
}

-(void)loadPage:(NSInteger)page{
    MainPageViewController *controller =(MainPageViewController *)[contentViews objectAtIndex:page];
    UIView *view = controller.view;
    CGRect frame = self.scrollView.frame;
    frame.origin.x = CGRectGetWidth(frame) * page;
    frame.origin.y = 0;
    view.frame = frame;
    
    [self addChildViewController:controller];
    [self.scrollView addSubview:view];
    [controller didMoveToParentViewController:self];
    [controller setPage:page];
}

-(IBAction)gotoFormerPage:(id)sender{
    self.pageControl.currentPage--;
    [self gotoPage:YES];
}

-(IBAction)gotoNextPage:(id)sender{
    self.pageControl.currentPage++;
    [self gotoPage:YES];
}

#pragma mark UIScrollViewDelegate

// at the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (!isFolded && todayMission){
        [self hideorshowDailyMissionBoardAction:self];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self refreshPageTitles:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSUInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [self refreshPageTitles:scrollView];
    self.pageControl.currentPage = page;
    
    if (page != 1){
        UIViewController *controller =[contentViews objectAtIndex:self.pageControl.currentPage];
        [controller viewWillAppear:NO];
    }
    [MobClick event:@"slideClick"];
    [MTA trackCustomKeyValueEvent:@"slideClick" props:nil];

    
    NSMutableDictionary *userInfoDict = [RORUserUtils getUserInfoPList];
    if (![userInfoDict objectForKey:InstructionOrder_toString[3]] && page == 0){
        [userInfoDict setObject:[NSNumber numberWithInt:1] forKey:InstructionOrder_toString[3]];
        [RORUserUtils writeToUserInfoPList:userInfoDict];
    }
    if (![userInfoDict objectForKey:InstructionOrder_toString[6]] && page == 2){
        [userInfoDict setObject:[NSNumber numberWithInt:1] forKey:InstructionOrder_toString[6]];
        [RORUserUtils writeToUserInfoPList:userInfoDict];
    }
    
    if (page == 0){
        [self checkItemMallInstruction];
        [self dequeueCoverView];
    }
    if (page == 2){
        [self checkAddFriendInstruction];
        [self dequeueCoverView];
    }
}

-(void)refreshPageTitles:(UIScrollView *)scrollView{
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    for (int i=0; i<PAGE_QUANTITY; i++){
        MainPageViewController *controller =(MainPageViewController *)[contentViews objectAtIndex:i];
        double offset = self.scrollView.contentOffset.x - i*pageWidth;
        [controller refreshTitleLayout:offset];
    }
}

- (void)gotoPage:(BOOL)animated
{
    NSInteger page = self.pageControl.currentPage;
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    
	// update the scroll view to the appropriate page
    CGRect bounds = self.scrollView.bounds;
    CGPoint offset;
    offset.x = CGRectGetWidth(bounds) * page;
    offset.y = 0;
    [self.scrollView setContentOffset:offset animated:YES];
}

- (IBAction)changePage:(id)sender {
    [self gotoPage:YES];    // YES = animate
    if (self.pageControl.currentPage == 2){
        MainPageViewController *controller =(MainPageViewController *)[contentViews objectAtIndex:self.pageControl.currentPage];
        [controller viewWillAppear:NO];
    }
}

- (IBAction)showHistoryAction:(id)sender {
    [MobClick event:@"historyClick"];
    [MTA trackCustomKeyValueEvent:@"historyClick" props:nil];
    mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:[NSBundle mainBundle]];
    UIViewController *historyViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"historyListViewController"];
    [self presentViewController:historyViewController animated:YES completion:^(){}];
}

//其实这里是同步按钮的事件 - -
- (IBAction)missionAction:(id)sender {
    
    [self startIndicator:self];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL run = [RORRunHistoryServices uploadRunningHistories];
        BOOL mission = [RORMissionHistoyService uploadMissionHistories];
        
        int aQuantity = [RORFriendService syncActions:[RORUserUtils getUserId]];
        [RORUserUtils writeToUserInfoPList:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:aQuantity], @"MessageReceivedNumber", nil]];
        
        userBase = [RORUserServices syncUserInfoById:[RORUserUtils getUserId]];
        //用户好友信息
        int friends = [RORFriendService syncFriends:[RORUserUtils getUserId]];
        //好友初步信息
        BOOL friendsort = [RORFriendService syncFriendSort:[RORUserUtils getUserId]];
        //用户道具
        BOOL userPorp = [RORUserPropsService syncUserProps:[RORUserUtils getUserId]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(friends>=0 && run && friendsort && userPorp && mission){
                for (int i=0; i<PAGE_QUANTITY; i++){
                    UIViewController *controller =(UIViewController *)[contentViews objectAtIndex:i];
                    [controller viewWillAppear:NO];
                }
                [self sendSuccess:@"同步成功"];
            }else {
                [self sendAlart:@"同步失败"];
            }
        });
    });
}


- (void) allBackendSyncMethod: (NSNotification*) aNotification
{
    [MobClick event:@"allSyncCallTimes"];
    [MTA trackCustomKeyValueEvent:@"allSyncCallTimes" props:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [RORUserUtils syncSystemData];
        [RORUserUtils syncUserData];
        userBase = [RORUserServices syncUserInfoById:[RORUserUtils getUserId]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self viewWillAppear:NO];
//            [self checkDailyMission];
            [self viewDidAppear:NO];
        });
    });
}

- (void) userBackendSyncMethod: (NSNotification*) aNotification
{
    [MobClick event:@"userInfoSycnCall"];
    [MTA trackCustomKeyValueEvent:@"userInfoSycnCall" props:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [RORUserUtils syncUserData];
        userBase = [RORUserServices syncUserInfoById:[RORUserUtils getUserId]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self viewWillAppear:NO];
            [self viewDidAppear:NO];
        });
    });
}


- (IBAction)settingsAction:(id)sender {
    [MobClick event:@"settingClick"];
    [MTA trackCustomKeyValueEvent:@"settingClick" props:nil];
    UIViewController *moreViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"moreViewController"];
    [self presentViewController:moreViewController animated:YES completion:^(){}];
}

- (IBAction)closeDailyMissionAction:(id)sender {
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"放弃任务" andMessage:@"确定放弃今天的任务吗？"];
    [alertView addButtonWithTitle:@"取消"
                             type:SIAlertViewButtonTypeCancel
                          handler:^(SIAlertView *alertView) {
                              NSLog(@"Cancel Clicked");
                          }];
    [alertView addButtonWithTitle:@"确定"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView) {
                              NSLog(@"OK Clicked");
                              [self cancelMission];
                          }];
    
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }else if(buttonIndex == 1){
        if (alertType == ALERT_TYPE_GIVEUPMISSION){
            [self cancelMission];
            [MobClick event:@"giveupEventClick"];
            [MTA trackCustomKeyValueEvent:@"giveupEventClick" props:nil];
        }
        else if (alertType == ALERT_TYPE_TOAPPSTORE)
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_URL]];
    }
}

-(void)cancelMission{
    todayMission = nil;
    NSDictionary *saveDict = [[NSDictionary alloc]initWithObjectsAndKeys:[NSDate date], @"lastDailyMissionFinishedDate", [NSNumber numberWithInteger:-1], @"missionUseItemQuantity", nil];
    [RORUserUtils writeToUserInfoPList:saveDict];
    [Animations moveDown:self.missionView andAnimationDuration:1 andWait:NO andLength:100];
}

- (IBAction)hideorshowDailyMissionBoardAction:(id)sender {
    if (isFolded){
        [Animations moveUp:self.missionView andAnimationDuration:0 andWait:NO andLength:34];
        isFolded = NO;
    } else {
        [Animations moveDown:self.missionView andAnimationDuration:0 andWait:NO andLength:34];
        isFolded = YES;
    }
}

- (IBAction)ready2StartAction:(id)sender {
    [MobClick event:@"runClick"];
    [MTA trackCustomKeyValueEvent:@"runClick" props:nil];

    ReadyToGoViewController *readyController = [mainStoryboard instantiateViewControllerWithIdentifier:@"ReadyToGoViewController"];
    CoverView *coverView = (CoverView *)readyController.view;
    [coverView addCoverBgImage:[RORUtils captureScreen] grayed:YES];
    [coverView appear:self];
    
    [self addChildViewController:readyController];
    [self.view addSubview:readyController.view];
    [self didMoveToParentViewController:readyController];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *destination = segue.destinationViewController;
    if ([destination respondsToSelector:@selector(setDelegate:)]){
        [destination setValue:self forKey:@"delegate"];
    }
}

@end
