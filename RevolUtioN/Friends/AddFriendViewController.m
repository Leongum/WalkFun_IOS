//
//  AddFriendViewController.m
//  WalkFun
//
//  Created by Bjorn on 14-2-21.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "AddFriendViewController.h"

@interface AddFriendViewController ()

@end

@implementation AddFriendViewController

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
	// Do any additional setup after loading the view.
    recommendPage = 0;
    contentList = [RORFriendService fetchRecommendFriends:[NSNumber numberWithInteger:recommendPage]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

-(IBAction)backAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^(){}];
}

- (IBAction)searchAction:(id)sender {
    //todo searchAction
    
}

- (IBAction)refreshRecommendAction:(id)sender {
    recommendPage++;
    NSArray *tmpList = [RORFriendService fetchRecommendFriends:[NSNumber numberWithInteger:recommendPage]];
    if (tmpList.count>0){
        contentList = tmpList;
        [self.tableView reloadData];
    } else {
        [self sendNotification:@"今天就这么多\n明天再来试试吧"];
        self.refreshRecommendButton.enabled = NO;
    }
}

- (IBAction)follow:(id)sender{
    NSInteger row = [self rowOfButton:sender];
    Search_Friend *f = (Search_Friend *)[contentList objectAtIndex:row];
    if (![RORFriendService followFriend:f.userId]){
        [self sendAlart:@"关注失败，请检查一下网络"];
    }
}

- (IBAction)deFollow:(id)sender{
    NSInteger row = [self rowOfButton:sender];
    Search_Friend *f = (Search_Friend *)[contentList objectAtIndex:row];
    if (![RORFriendService deFollowFriend:f.userId]){
        [self sendAlart:@"取消关注失败，请检查一下网络"];
    }
}

-(NSInteger )rowOfButton:(UIButton *)sender{
    UIView *tmp = sender;
    while (![tmp isKindOfClass:[UITableViewCell class]]) {
        tmp = [tmp superview];
    }
    UITableViewCell *cell = (UITableViewCell *)tmp;
    return [self.tableView indexPathForCell:cell].row;
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
    
    Search_Friend *user = [contentList objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"friendCell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel *userNameLabel = (UILabel *)[cell viewWithTag:100];
    UILabel *userLevelLabel = (UILabel *)[cell viewWithTag:102];
    UIImageView *userSexImage = (UIImageView *)[cell viewWithTag:103];
    UIButton *follow = (UIButton *)[cell viewWithTag:200];
    
    userNameLabel.text = user.nickName;
    userLevelLabel.text = [NSString stringWithFormat:@"Lv.%d", user.level.integerValue];
    userSexImage.image = [RORUserUtils getImageForUserSex:user.sex];
    if ([RORFriendService getFollowStatus:user.userId] == FollowStatusNotFollowed){
        [follow setTitle:@"关注" forState:UIControlStateNormal];
        [follow addTarget:self action:@selector(follow:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [follow setTitle:@"取消关注" forState:UIControlStateNormal];
        [follow addTarget:self action:@selector(deFollow:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Search_Friend *user = [contentList objectAtIndex:indexPath.row];

    UIStoryboard *friendsStoryboard = [UIStoryboard storyboardWithName:@"FriendsStoryboard" bundle:[NSBundle mainBundle]];
    UIViewController *friendInfoViewController =  [friendsStoryboard instantiateViewControllerWithIdentifier:@"FriendInfoViewController"];
    if ([friendInfoViewController respondsToSelector:@selector(setUserBase:)]){
        User_Base *userBase =[RORUserServices fetchUser:user.userId];
        if (!userBase)
            [RORUserServices syncUserInfoById:user.userId];
        if (userBase){
            [friendInfoViewController setValue:userBase forKey:@"userBase"];
            [self.navigationController pushViewController:friendInfoViewController animated:YES];
        } else {
            [self sendAlart:@"信息读取失败"];
        }
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


@end
