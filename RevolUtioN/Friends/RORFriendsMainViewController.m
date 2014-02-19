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
    
    noMoreData = NO;
    pageCount = 0;
    //[RORUserServices syncFollowersDetails:[RORUserUtils getUserId] withPageNo:[NSNumber numberWithInt:pageCount]];
    contentList = [[NSMutableArray alloc]init];
    //[contentList addObjectsFromArray:[RORUserServices fetchFollowersDetails:[RORUserUtils getUserId] withPageNo:[NSNumber numberWithInt:pageCount++]]];
    latestPage = contentList;
    self.addButton.enabled = 0;
    
    [Animations frameAndShadow:self.searchFriendView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self initSearchField];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSDictionary *dict = [RORUserUtils getUserSettingsPList];
    NSNumber *didIntro = [RORDBCommon getNumberFromId:[dict objectForKey:@"HasShowFriendsIntro"]];
    if (!didIntro){
        RORIntroCoverView *introCoverView = [[RORIntroCoverView alloc]initWithFrame:self.view.frame andImage:[UIImage imageNamed:@"introFriendPage.png"]];
        [self.view addSubview:introCoverView];
        [RORUserUtils writeToUserSettingsPList:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1], @"HasShowFriendsIntro", nil]];
    }
}

- (IBAction)editingDidBegin:(id)sender {
//    [Animations frameAndShadow:self.searchTextField];
    self.searchTextField.text = @"";
}

-(void)viewWillDisAppear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)backAction:(id)sender{
    [self.tableView setEditing:NO];
    [super backAction:sender];
}

-(void)initSearchField{
    self.searchTextField.text = @"";
    self.searchResultUserNameLabel.text = @"";
    self.searchResultUserLvLabel.text = @"";
    self.searchResultUserIdLabel.text = @"";
    self.searchResultUserSex.image = nil;
    self.addButton.alpha = 0;
}

- (IBAction)expandAction:(id)sender {
    CGRect f = self.searchFriendView.frame;
    
    if (f.origin.y < 0) {
        searchViewTop = f.origin.y;
        [self.searchFriendView moveUp:0.5 length:-searchViewTop delegate:self];
        self.searchFriendView.frame = CGRectMake(f.origin.x, 0, f.size.width, f.size.height);
        [self initSearchField];
        [self.searchTextField becomeFirstResponder];
        [self.expandButton setTitle:@"收起" forState:UIControlStateNormal];
    } else {
        [self.searchFriendView moveUp:0.5 length:searchViewTop delegate:self];
        self.searchFriendView.frame = CGRectMake(f.origin.x, searchViewTop, f.size.width, f.size.height);
        [self.searchTextField resignFirstResponder];
        [self.expandButton setTitle:@"添加" forState:UIControlStateNormal];
    }
}

- (IBAction)hideKeyboard:(id)sender {
    [self.searchTextField resignFirstResponder];
    [Animations removeFrameAndShadow:self.searchTextField];
}

- (IBAction)doSearchAction:(id)sender {
    User_Base *info = [RORUserServices syncUserInfoById:[RORUtils removeEggache:self.searchTextField.text]];
    if (info){
        userInfo = info;
        [self showUserInfo];
        [self refreshAddButton];
    } else {
        [self sendAlart:@"无此用户"];
    }
    [self.searchTextField resignFirstResponder];
    [Animations removeFrameAndShadow:self.searchTextField];
}

-(void)refreshAddButton{
    self.addButton.alpha = 1;
    if (userInfo.userId.integerValue == [RORUserUtils getUserId].integerValue ){
        [self.addButton setTitle:@"添加" forState:UIControlStateNormal];
        self.addButton.enabled = 0;
        return;
    }
//    Plan_User_Follow *userFollow = [RORPlanService fetchUserFollow:[RORUserUtils getUserId] withFollowerId:userInfo.userId];
//    if (userFollow && userFollow.status.integerValue == FollowStatusFollowed){
//        [self.addButton setTitle:@"已添加" forState:UIControlStateNormal];
//        self.addButton.enabled = 0;
//        return;
//    }
    
    [self.addButton setTitle:@"添加" forState:UIControlStateNormal];
    self.addButton.enabled = 1;
}

-(void)showUserInfo{
    self.searchResultUserNameLabel.text = userInfo.nickName;
    //self.searchResultUserLvLabel.text = [NSString stringWithFormat:@"Lv.%d", userInfo.attributes.level.integerValue];
    self.searchResultUserIdLabel.text = [NSString stringWithFormat:@"%@号选手", [RORUtils addEggache:userInfo.userId]];
    self.searchResultUserSex.image = [RORUserUtils getImageForUserSex:userInfo.sex];
}

- (IBAction)addAction:(id)sender {
    [self startIndicator:self];
//    Plan_User_Follow *userFollow = [Plan_User_Follow intiUnassociateEntity];
//    userFollow.userId = [RORUserUtils getUserId];
//    userFollow.followUserId = userInfo.userId;
//    userFollow.status = [NSNumber numberWithInt:FollowStatusFollowed];
//    [RORPlanService updateUserFollow:userFollow];
    self.addButton.enabled = 0;
    [self.tableViewContainer pop:0.5 delegate:self];
    [self reloadTableView];
    [self endIndicator:self];
    [self expandAction:self];
    [self sendNotification:@"添加成功！"];
}

-(void)reloadTableView{
    contentList = [[NSMutableArray alloc]init];
    for (int i=0; i<pageCount; i++){
   //      [contentList addObjectsFromArray:[RORUserServices fetchFollowersDetails:[RORUserUtils getUserId] withPageNo:[NSNumber numberWithInt:pageCount]]];
    }
    [self.tableView reloadData];
}

-(void)loadTableViewData:(NSInteger)page{
    if (noMoreData)
        return;
    
    int count = contentList.count;
    //latestPage = [RORUserServices fetchFollowersDetails:[RORUserUtils getUserId] withPageNo:[NSNumber numberWithInt:page]];
    [contentList addObjectsFromArray:latestPage];
    if (contentList.count-count<FRIENDS_PAGE_SIZE){
        noMoreData = YES;
    }
    [self.tableView reloadData];
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
    
    User_Base *user = [contentList objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"userInfoCell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel *userNameLabel = (UILabel *)[cell viewWithTag:100];
    UILabel *userLevelLabel = (UILabel *)[cell viewWithTag:101];
    UILabel *userIdLabel = (UILabel *)[cell viewWithTag:102];
    UIImageView *userSexImage = (UIImageView *)[cell viewWithTag:103];
    
    userNameLabel.text = user.nickName;
    //userLevelLabel.text = [NSString stringWithFormat:@"Lv.%d", user.attributes.level.integerValue];
    userIdLabel.text = [NSString stringWithFormat:@"%@号选手", [RORUtils addEggache:user.userId]];
    userSexImage.image = [RORUserUtils getImageForUserSex:user.sex];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == contentList.count){
        [self loadTableViewData:pageCount++];
    } else {
        [self sendNotification:@"【好友信息】\n正在哼哧哼哧开发中！\n\n向左划划试试"];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row<contentList.count)
        return 77;
    return 50;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//更改删除按钮
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    User_Base *user = [contentList objectAtIndex:indexPath.row];
//    Plan_User_Follow *userFollow = [RORPlanService fetchUserFollow:[RORUserUtils getUserId] withFollowerId:user.userId];
//    userFollow.userId = [RORUserUtils getUserId];
//    userFollow.followUserId = user.userId;
//    userFollow.status = [NSNumber numberWithInt:FollowStatusNotFollowed];
    //[RORPlanService updateUserFollow:userFollow];
    [self.tableViewContainer pop:0.5 delegate:self];
    [self reloadTableView];
}

@end
