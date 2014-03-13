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
@synthesize contentViews;

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
}

-(void)checkDailyMission{
    todayMission = [RORMissionServices getTodayMission];
    if (todayMission){
        NSMutableDictionary *userInfoList = [RORUserUtils getUserInfoPList];
        NSNumber *missionUseItemQuantity = [userInfoList valueForKey:@"missionUseItemQuantity"];
        if (todayMission.missionTypeId.integerValue == MissionTypeUseItem){
            if (missionUseItemQuantity.integerValue<0){
                //接到使用道具的任务，初始化missionUseItemQuantity为总次数
                [userInfoList setObject:todayMission.triggerUserNumbers forKey:@"missionUseItemQuantity"];
                [RORUserUtils writeToUserInfoPList:userInfoList];
            } else {
                //如果使用道具的任务完成了
                if (missionUseItemQuantity.integerValue == 0){
                    //保存任务数据
                    User_Mission_History *mh = [User_Mission_History intiUnassociateEntity];
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
                    CoverView *congratsCoverView = (CoverView *)missionDoneViewController.view;
                    [congratsCoverView addCoverBgImage];
                    [self.view addSubview:congratsCoverView];
                    [congratsCoverView appear:self];
                    
                    UIView *missionCongratsView = missionDoneViewController.view;
                    UILabel *missionNameLabel = (UILabel *)[missionCongratsView viewWithTag:100];
                    UILabel *missionGoldLabel = (UILabel *)[missionCongratsView viewWithTag:101];
                    UILabel *missionExpLabel = (UILabel *)[missionCongratsView viewWithTag:102];
                    UILabel *missionDoneLabel = (UILabel *)[missionCongratsView viewWithTag:103];
                    
                    missionNameLabel.text = todayMission.missionDescription;
                    missionGoldLabel.text = [NSString stringWithFormat:@"+%d",todayMission.goldCoin.integerValue];
                    missionExpLabel.text = [NSString stringWithFormat:@"+%d",todayMission.experience.integerValue];
                    NSMutableDictionary *userInfoList = [RORUserUtils getUserInfoPList];
                    NSNumber *missionProcess = (NSNumber *)[userInfoList objectForKey:@"missionProcess"];
                    int mp = missionProcess.integerValue;
                    mp++;
                    missionDoneLabel.text = [NSString stringWithFormat:@"%d/%d", mp, 3];
                    //修改plist中的任务相关标记
                    [userInfoList setObject:[NSNumber numberWithInteger:mp] forKey:@"missionProcess"];
                    [userInfoList setObject:[NSNumber numberWithInteger:-1] forKey:@"missionUseItemQuantity"];
                    [userInfoList setObject:[NSDate date] forKey:@"lastDailyMissionFinishedDate"];
                    [RORUserUtils writeToUserInfoPList:userInfoList];
                    return;
                }
            }
        } else {
            if (missionUseItemQuantity>=0){
                [userInfoList setObject:[NSNumber numberWithInteger:-1] forKey:@"missionUseItemQuantity"];
                [RORUserUtils writeToUserInfoPList:userInfoList];
            }
        }
        
        self.missionContentLabel.text = todayMission.missionDescription;
        [Animations moveUp:self.missionView andAnimationDuration:1 andWait:NO andLength:100];
    }
    isFolded = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([RORUserUtils getUserId].integerValue<0) {
        UIViewController *loginViewController =  [mainStoryboard instantiateViewControllerWithIdentifier:@"RORLoginNavigatorController"];
        [self presentViewController:loginViewController animated:NO completion:^(){}];
    } else {
        userBase = [RORUserServices fetchUser:[RORUserUtils getUserId]];
        for (int i=0; i<PAGE_QUANTITY; i++){
            UIViewController *controller =(UIViewController *)[contentViews objectAtIndex:i];
            [controller viewWillAppear:NO];
        }
    }
    self.missionView.center = CGPointMake(self.missionView.center.x, missionBoardCenterY);
}

-(void)viewDidAppear:(BOOL)animated{
    [self checkLevelUp];
    [self checkDailyMission];
}

-(void)checkLevelUp{
    if (!userBase)
        return;
    
    NSMutableDictionary *userInfoList = [RORUserUtils getUserInfoPList];
    NSNumber *userLevel = [userInfoList valueForKey:@"userLevel"];
    
    if (!userLevel){
        NSDictionary *saveDict = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithDouble:userBase.userDetail.goldCoinSpeed.doubleValue * 2.5], @"extraGold", userBase.userDetail.level, @"userLevel", nil];
        [RORUserUtils writeToUserInfoPList:saveDict];
        return;
    }
    if (userLevel.integerValue<userBase.userDetail.level.integerValue){
        [self performLevelUp];
    }
}

-(void)performLevelUp{
    UIStoryboard *itemStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:[NSBundle mainBundle]];
    LevelUpCongratsViewController *levelupViewController =  [itemStoryboard instantiateViewControllerWithIdentifier:@"levelUpCongratsCoverViewController"];
    [self addChildViewController:levelupViewController];
    [self.view addSubview:levelupViewController.view];
    [self didMoveToParentViewController:levelupViewController];
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
    if (!isFolded){
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
    //    bounds.origin.x = CGRectGetWidth(bounds) * page;
    //    bounds.origin.y = 0;
    //    [self.scrollView scrollRectToVisible:bounds animated:animated];
}

- (IBAction)changePage:(id)sender {
    [self gotoPage:YES];    // YES = animate
    if (self.pageControl.currentPage == 2){
        MainPageViewController *controller =(MainPageViewController *)[contentViews objectAtIndex:self.pageControl.currentPage];
        [controller viewWillAppear:NO];
    }
}

- (IBAction)missionAction:(id)sender {
    [self startIndicator:self];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL run = [RORRunHistoryServices uploadRunningHistories];
        BOOL mission = [RORMissionHistoyService uploadMissionHistories];
        
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

- (IBAction)settingsAction:(id)sender {
    UIViewController *moreViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"moreViewController"];
    [self presentViewController:moreViewController animated:YES completion:^(){}];
}

- (IBAction)closeDailyMissionAction:(id)sender {
    UIAlertView *confirmView = [[UIAlertView alloc] initWithTitle:@"放弃任务" message:@"确定放弃今天的任务吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [confirmView show];
    confirmView = nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }else if(buttonIndex == 1){
        [self cancelMission];
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


#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *destination = segue.destinationViewController;
    if ([destination respondsToSelector:@selector(setDelegate:)]){
        [destination setValue:self forKey:@"delegate"];
    }
    
    if ([destination respondsToSelector:@selector(setTodayMission:)]){
        [destination setValue:todayMission forKey:@"todayMission"];
    }
}

@end
