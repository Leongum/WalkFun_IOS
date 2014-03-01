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
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    followList = [RORFriendService fetchFriendFollowsList];
    fansList = [RORFriendService fetchFriendFansList];
    friendList = [RORFriendService fetchFriendEachFansList];
    
    [self initFriendDisplayBool];
    [self refreshTableView];
}

-(void)syncPageFromServer{
    [super syncPageFromServer];
//    int friends = [RORFriendService syncFriends:[RORUserUtils getUserId]];
//    
//    //好友初步信息
//    BOOL friendsort = [RORFriendService syncFriendSort:[RORUserUtils getUserId]];
//    if(!friendsort){
//        friendsort = [RORFriendService syncFriendSort:[RORUserUtils getUserId]];
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    [self refreshFriendDisplayButton];
}

-(void)refreshFriendDisplayButton{
    if (showFollow){
        [self.showFollowButton setBackgroundColor:[UIColor redColor]];
        self.startDeletingButton.enabled = YES;
    } else{
        [self.showFollowButton setBackgroundColor:[UIColor clearColor]];
        self.startDeletingButton.enabled = NO;
    }
    if (showFans){
        [self.showFansButton setBackgroundColor:[UIColor redColor]];
    } else
        [self.showFansButton setBackgroundColor:[UIColor clearColor]];
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
    [self refreshFriendDisplayButton];
    [self refreshTableView];
}

- (IBAction)clickShowFansButton:(id)sender{
    showFans = !showFans;
    [self refreshFriendDisplayButton];
    [self refreshTableView];
}

- (IBAction)startDeletingAction:(id)sender {
    self.endDeletingButton.alpha = 1;
    [self refreshTableView];
}

- (IBAction)endDeletingAction:(id)sender {
    self.endDeletingButton.alpha = 0;
    [self refreshTableView];
}

- (IBAction)followAction:(id)sender{
    NSInteger row = [self rowOfButton:sender];
    deletingFriend = (Friend *)[contentList objectAtIndex:row];
    [self startIndicator:self];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        isDeletingSuccess = [RORFriendService followFriend:deletingFriend.friendId];
        followList = [RORFriendService fetchFriendFollowsList];
        friendList = [RORFriendService fetchFriendEachFansList];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self endIndicator:self];
            if (!isDeletingSuccess){
                [self sendAlart:@"取消关注失败，请检查一下网络"];
            } else {
                [self refreshTableView];
            }
        });
    });
}

- (IBAction)deFollowAction:(id)sender{
    NSInteger row = [self rowOfButton:sender];
    deletingFriend = (Friend *)[contentList objectAtIndex:row];
    [self startIndicator:self];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        isDeletingSuccess = [RORFriendService deFollowFriend:deletingFriend.friendId];
        followList = [RORFriendService fetchFriendFollowsList];
        friendList = [RORFriendService fetchFriendEachFansList];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self endIndicator:self];
            if (!isDeletingSuccess){
                [self sendAlart:@"取消关注失败，请检查一下网络"];
            } else {
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
    UIButton *deleteButton = (UIButton *)[cell viewWithTag:200];
    
    userNameLabel.text = user.userName;
    userLevelLabel.text = [NSString stringWithFormat:@"Lv.%d", user.level.integerValue];
    userSexImage.image = [RORUserUtils getImageForUserSex:user.sex];
    
    if (self.startDeletingButton.enabled){
        deleteButton.alpha = self.endDeletingButton.alpha;
        [deleteButton setTitle:@"取消关注" forState:UIControlStateNormal];
        [deleteButton removeTarget:self action:@selector(followAction:) forControlEvents:UIControlEventTouchUpInside];
        [deleteButton addTarget:self action:@selector(deFollowAction:) forControlEvents:UIControlEventTouchUpInside];
    }
//    else if (showFans){
//        deleteButton.alpha = 1;
//        [deleteButton setTitle:@"关注" forState:UIControlStateNormal];
//        [deleteButton removeTarget:self action:@selector(deFollowAction:) forControlEvents:UIControlEventTouchUpInside];
//        [deleteButton addTarget:self action:@selector(followAction:) forControlEvents:UIControlEventTouchUpInside];
//    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.endDeletingButton.alpha == 0){
        Friend *user = (Friend *)[contentList objectAtIndex:indexPath.row];
        
        UIStoryboard *friendsStoryboard = [UIStoryboard storyboardWithName:@"FriendsStoryboard" bundle:[NSBundle mainBundle]];
        UIViewController *friendInfoViewController =  [friendsStoryboard instantiateViewControllerWithIdentifier:@"FriendInfoViewController"];
        if ([friendInfoViewController respondsToSelector:@selector(setUserBase:)]){
            User_Base *userBase =[RORUserServices fetchUser:user.friendId];
            if (!userBase)
                userBase = [RORUserServices syncUserInfoById:user.friendId];
            if (userBase){
                [friendInfoViewController setValue:userBase forKey:@"userBase"];
                [self.navigationController pushViewController:friendInfoViewController animated:YES];
            } else {
                [self sendAlart:@"信息读取失败"];
            }
        }
    } else {
        [self deFollowAction:[self.tableView cellForRowAtIndexPath:indexPath]];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 77;
}

@end
