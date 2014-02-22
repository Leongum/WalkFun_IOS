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
}

-(void)viewWillAppear:(BOOL)animated{
    contentList = [RORFriendService fetchFriendFollowsList];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backAction:(id)sender{
    [self.tableView setEditing:NO];
    [super backAction:sender];
}

- (IBAction)doSearchAction:(id)sender {
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
    
    userNameLabel.text = user.userName;
    userLevelLabel.text = [NSString stringWithFormat:@"Lv.%d", user.level.integerValue];
    userSexImage.image = [RORUserUtils getImageForUserSex:user.sex];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
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
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 77;
}

@end
