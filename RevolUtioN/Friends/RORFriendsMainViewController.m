//
//  RORFriendsMainViewController.m
//  WalkFun
//
//  Created by Bjorn on 13-11-6.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORFriendsMainViewController.h"
#import "FTAnimation.h"

@interface RORFriendsMainViewController ()

@end

@implementation RORFriendsMainViewController

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
    titleView = self.friendTitleView;
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.backButton.alpha = 0;
    self.endDeletingButton.alpha = 0;
    self.startDeletingButton.enabled = YES;
    
    [Animations roundedCorners:self.tableView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"RORFriendsMainViewController"];
    followList = [RORFriendService fetchFriendFollowsList];
    fansList = [RORFriendService fetchFriendFansList];
    friendList = [RORFriendService fetchFriendEachFansList];
 
    //把cover view挪到mainViewController
    [self.filterCoverView removeFromSuperview];
    [self.parentViewController.view addSubview:self.filterCoverView];
    [self.parentViewController.view bringSubviewToFront:self.filterCoverView];
    self.filterCoverView.alpha = 0;
    
    [self initFriendDisplayBool];
    [self refreshTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"RORFriendsMainViewController"];
}

-(void)initFriendDisplayBool{
    NSMutableDictionary *settinglist = [RORUserUtils getUserSettingsPList];
    NSNumber *showFollowNum = (NSNumber *)[settinglist objectForKey:@"showFollow"];
    NSNumber *showFansNum = (NSNumber *)[settinglist objectForKey:@"showFans"];
    if ((!showFollowNum)||(!showFansNum)){
        showFollowNum = [NSNumber numberWithBool:YES];
        showFansNum = [NSNumber numberWithBool:NO];
    }
    showFollow = showFollowNum.boolValue;
    showFans = showFansNum.boolValue;
    [self arrangeButtons];
//    [self refreshFriendDisplayButton];
}

-(void)refreshFriendDisplayButton{
//    if (showFollow && showFans){
//        self.titleLabel.text = @"我的好友";
//    } else if (showFollow) {
//        self.titleLabel.text = @"我的关注";
//    } else if (showFans) {
//        self.titleLabel.text = @"我的粉丝";
//    } else {
//        self.titleLabel.text = @"";
//    }
    
//    if (showFollow){
//        [self.showFollowButton setBackgroundImage:[UIImage imageNamed:@"followButton_selected.png"] forState:UIControlStateNormal];
//    } else{
//        [self.showFollowButton setBackgroundImage:[UIImage imageNamed:@"followButton_normal.png"] forState:UIControlStateNormal];
//    }
//    if (showFans){
//        [self.showFansButton setBackgroundImage:[UIImage imageNamed:@"fansButton_selected.png"] forState:UIControlStateNormal];
//    } else
//    [self.showFansButton setBackgroundImage:[UIImage imageNamed:@"fansButton_normal.png"] forState:UIControlStateNormal];

    [self saveFriendDisplayPlist];
}

#pragma mark - Action

-(IBAction)backAction:(id)sender{
    [self.tableView setEditing:NO];
    [super backAction:sender];
}

- (IBAction)doSearchAction:(id)sender {
}

- (IBAction)clickShowFollowButton:(id)sender{
    showFollow = !showFollow;
//    [self refreshFriendDisplayButton];
//    [self refreshTableView];
    
    self.filterCoverView.alpha = 1;
}

- (IBAction)hideCoverViewAction:(id)sender {
    self.filterCoverView.alpha = 0;
}

- (IBAction)showFriendAction:(id)sender {
    [MobClick event:@"friendClcik"];
    showFans = YES;
    showFollow = YES;
    [self arrangeButtons];
    [self refreshTableView];
    [self saveFriendDisplayPlist];
    [self hideCoverViewAction:self];
}

- (IBAction)showFansAction:(id)sender {
    [MobClick event:@"fanClick"];
    showFollow = NO;
    showFans = YES;
    [self arrangeButtons];
    [self refreshTableView];
    [self saveFriendDisplayPlist];
    [self hideCoverViewAction:self];
}

- (IBAction)showFollowAction:(id)sender {
    [MobClick event:@"followClick"];
    showFans = NO;
    showFollow = YES;
    [self arrangeButtons];
    [self refreshTableView];
    [self saveFriendDisplayPlist];
    [self hideCoverViewAction:self];
}

-(void)arrangeButtons{
    if (showFollow && showFans) {
        self.followFilterButton.center = CGPointMake(160, 132);
        self.fansFilterButton.center = CGPointMake(160, 85);
        self.friendFilterButton.center = CGPointMake(160, 38);
        [self.showFollowButton setTitle:@"互相关注" forState:UIControlStateNormal];
    } else if (showFollow && !showFans){
        self.followFilterButton.center = CGPointMake(160, 38);
        self.fansFilterButton.center = CGPointMake(160, 132);
        self.friendFilterButton.center = CGPointMake(160, 85);
        [self.showFollowButton setTitle:@"我的关注" forState:UIControlStateNormal];
    } else if (showFans && !showFollow) {
        self.followFilterButton.center = CGPointMake(160, 132);
        self.fansFilterButton.center = CGPointMake(160, 38);
        self.friendFilterButton.center = CGPointMake(160, 85);
        [self.showFollowButton setTitle:@"我的粉丝" forState:UIControlStateNormal];
    }
}


- (IBAction)clickShowFansButton:(id)sender{
    showFans = !showFans;
    [self refreshFriendDisplayButton];
    [self refreshTableView];
}

- (IBAction)startDeletingAction:(id)sender {
    [MobClick event:@"removeClick"];
    self.endDeletingButton.alpha = 1;
    [self.endDeletingButton slideInFrom:kFTAnimationTop duration:0.1 delegate:self];
    [self refreshTableView];
}

- (IBAction)endDeletingAction:(id)sender {
    [self.endDeletingButton slideOutTo:kFTAnimationTop duration:0.1 delegate:self startSelector:nil stopSelector:@selector(hideEndDeletingButton:)];
}

-(IBAction)hideEndDeletingButton:(id)sender{
    self.endDeletingButton.alpha = 0;
    [self refreshTableView];
}

- (IBAction)followAction:(id)sender{
    [MobClick event:@"followFriendClick"];
    NSInteger row = [self rowOfButton:sender];
    deletingFriend = (Friend *)[contentList objectAtIndex:row];
    [self startIndicator:self];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (contentList == fansList)
            isDeletingSuccess = [RORFriendService followFriend:deletingFriend.userId];
        else
            isDeletingSuccess = [RORFriendService followFriend:deletingFriend.friendId];
        followList = [RORFriendService fetchFriendFollowsList];
        friendList = [RORFriendService fetchFriendEachFansList];
        fansList = [RORFriendService fetchFriendFansList];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!isDeletingSuccess){
                [self sendAlart:@"关注失败，请检查一下网络"];
            } else {
                [self endIndicator:self];
                [self refreshTableView];
            }
        });
    });
}

- (IBAction)deFollowAction:(id)sender{
    [MobClick event:@"defollowFriendClick"];
    NSInteger row = [self rowOfButton:sender];
    deletingFriend = (Friend *)[contentList objectAtIndex:row];
    [self startIndicator:self];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (contentList == fansList)
            isDeletingSuccess = [RORFriendService deFollowFriend:deletingFriend.userId];
        else
            isDeletingSuccess = [RORFriendService deFollowFriend:deletingFriend.friendId];
        followList = [RORFriendService fetchFriendFollowsList];
        friendList = [RORFriendService fetchFriendEachFansList];
        fansList = [RORFriendService fetchFriendFansList];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!isDeletingSuccess){
                [self sendAlart:@"取消关注失败，请检查一下网络"];
            } else {
                [self endIndicator:self];
                [self refreshTableView];
            }
        });
    });
}

-(NSInteger )rowOfButton:(UIView *)sender{
    UIView *tmp = sender;
    while (![tmp isKindOfClass:[UITableViewCell class]]) {
        tmp = [tmp superview];
    }
    UITableViewCell *cell = (UITableViewCell *)tmp;
    return [self.tableView indexPathForCell:cell].row;
}

-(void)refreshTableView{
    if (showFollow && showFans){
        contentList = friendList;
    } else if (showFollow){
        contentList = followList;
    } else if (showFans){
        contentList = fansList;
    } else {
        contentList = [[NSArray alloc]init];
    }
    [self.tableView reloadData];
}

-(void)saveFriendDisplayPlist{
    NSDictionary *saveDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:showFollow], @"showFollow", [NSNumber numberWithBool:showFans], @"showFans",nil];
    [RORUserUtils writeToUserSettingsPList:saveDict];
}

-(BOOL)didFollowed:(NSInteger)friendId{
    for (Friend *f in followList){
        if (f.friendId.intValue == friendId)
            return YES;
    }
    return NO;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return contentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    Friend *user = (Friend *)[contentList objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"userInfoCell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel *userNameLabel = (UILabel *)[cell viewWithTag:100];
    UILabel *userLevelLabel = (UILabel *)[cell viewWithTag:101];
    UIImageView *userSexImage = (UIImageView *)[cell viewWithTag:103];
    UILabel *friendStatusLabel = (UILabel *)[cell viewWithTag:104];
    BadgeView *badgeView = (BadgeView *)[cell viewWithTag:105];
    [badgeView setFriendFightWin:user.friendFightWin];
    UIButton *deleteButton = (UIButton *)[cell viewWithTag:200];
    
    userNameLabel.text = user.userName;
    userLevelLabel.text = [NSString stringWithFormat:@"Lv.%d", user.level.integerValue];
    userSexImage.image = [RORUserUtils getImageForUserSex:user.sex];
    if (user.friendEach.intValue == FriendStatusOnlyFollowed){
        if (contentList == fansList)
            friendStatusLabel.text = @"";
        else
            friendStatusLabel.text = @"已关注";
    } else if (user.friendEach.intValue == FriendStatusFollowEachother){
        friendStatusLabel.text = @"互相关注";
    }
    
    if (self.endDeletingButton.alpha){
//        deleteButton.enabled = self.endDeletingButton.alpha;
        if (showFans && user.friendEach.intValue != FriendStatusFollowEachother)
            deleteButton.alpha = 0;
        else
            deleteButton.alpha = 1;
//        deleteButton.alpha = self.endDeletingButton.alpha;
        [deleteButton setTitle:@"取消关注" forState:UIControlStateNormal];
        [deleteButton removeTarget:self action:@selector(followAction:) forControlEvents:UIControlEventTouchUpInside];
        [deleteButton addTarget:self action:@selector(deFollowAction:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [deleteButton setTitle:@"关注" forState:UIControlStateNormal];
        [deleteButton removeTarget:self action:@selector(deFollowAction:) forControlEvents:UIControlEventTouchUpInside];
        [deleteButton addTarget:self action:@selector(followAction:) forControlEvents:UIControlEventTouchUpInside];
        if (showFans && user.friendEach.intValue != FriendStatusFollowEachother)
            deleteButton.alpha = 1;
        else
            deleteButton.alpha = 0;
    }
    
    [RORUtils setFontFamily:APP_FONT forView:cell andSubViews:YES];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.endDeletingButton.alpha == 0){
        Friend *user = (Friend *)[contentList objectAtIndex:indexPath.row];
        
        UIStoryboard *friendsStoryboard = [UIStoryboard storyboardWithName:@"FriendsStoryboard" bundle:[NSBundle mainBundle]];
        UIViewController *friendInfoViewController =  [friendsStoryboard instantiateViewControllerWithIdentifier:@"FriendInfoViewController"];
        if ([friendInfoViewController respondsToSelector:@selector(setUserBase:)]){
            NSNumber *fId;
            if (contentList == fansList)
                fId = user.userId;
            else
                fId = user.friendId;
            
            [self startIndicator:self];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                User_Base *userBase =[RORUserServices fetchUser:fId];
                if (!userBase)
                    userBase = [RORUserServices syncUserInfoById:fId];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (userBase){
                        [self endIndicator:self];
                        [friendInfoViewController setValue:userBase forKey:@"userBase"];
                        [self.navigationController pushViewController:friendInfoViewController animated:YES];
                    } else {
                        [self sendAlart:@"信息读取失败"];
                    }
                });
            });

        }
    } else {
        [self deFollowAction:[self.tableView cellForRowAtIndexPath:indexPath]];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 72;
}

@end
