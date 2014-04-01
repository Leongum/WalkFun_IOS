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
    self.backButton.alpha = 0;
    [self.refreshRecommendButton setBackgroundImage:[UIImage imageNamed:@"friend_add_nextPage_disabled.png"] forState:UIControlStateDisabled];
    
    [RORUtils setFontFamily:APP_FONT forView:self.view andSubViews:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self startIndicator:self];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        contentList = [RORFriendService fetchRecommendFriends:[NSNumber numberWithInteger:recommendPage]];
        recommendList = contentList;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self endIndicator:self];
            [self.tableView reloadData];
        });
    });
}

#pragma mark - Actions

- (IBAction)invateWeixinAction:(id)sender {
    
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeApp;
    //分享图文样式到微信朋友圈显示字数比较少，只显示分享标题
    [UMSocialData defaultData].extConfig.title = @"朋友圈分享内容";
    //设置微信好友或者朋友圈的分享url,下面是微信好友，微信朋友圈对应wechatTimelineData
    [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://www.cyberace.cc";
    
//    [[UMSocialControllerService defaultControllerService] setShareText:@"123" shareImage:nil socialUIDelegate:nil];
    //设置分享内容和回调对象
    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
}

-(IBAction)backAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^(){}];
}

- (IBAction)searchAction:(id)sender {
    //todo searchAction
    NSString *searchText =self.searchTextField.text;
    if (![searchText isEqualToString:@""]){
        [self startIndicator:self];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            searchResult = [RORUserServices searchFriend:searchText];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self endIndicator:self];
                contentList = searchResult;
                [self.tableView reloadData];
            });
        });
    } else {
        contentList = recommendList;
        [self.tableView reloadData];
    }
}

- (IBAction)refreshRecommendAction:(id)sender {
    recommendPage++;
    [self startIndicator:self];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *tmpList = [RORFriendService fetchRecommendFriends:[NSNumber numberWithInteger:recommendPage]];
        recommendList = contentList;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (tmpList.count>0){
                [self endIndicator:self];
                contentList = tmpList;
                recommendList = contentList;
                [self.tableView reloadData];
            } else {
                [self sendNotification:@"今天就这么多\n明天再来试试吧"];
                self.refreshRecommendButton.enabled = NO;
            }
        });
    });
}

- (IBAction)follow:(id)sender{
    NSInteger row = [self rowOfButton:sender];
    addingFriend = (Search_Friend *)[contentList objectAtIndex:row];
    [self startIndicator:self];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        isAddingSuccess = [RORFriendService followFriend:addingFriend.userId];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!isAddingSuccess){
                [self sendAlart:@"关注失败，请检查一下网络"];
            } else {
                [self endIndicator:self];
                [self.tableView reloadData];
            }
        });
    });
}

- (IBAction)deFollow:(id)sender{
    NSInteger row = [self rowOfButton:sender];
    addingFriend = (Search_Friend *)[contentList objectAtIndex:row];
    [self startIndicator:self];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        isAddingSuccess = [RORFriendService deFollowFriend:addingFriend.userId];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!isAddingSuccess){
                [self sendAlart:@"取消关注失败，请检查一下网络"];
            } else {
                [self endIndicator:self];
                [self.tableView reloadData];
            }
        });
    });
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
        [follow.titleLabel setTextColor:[UIColor whiteColor]];
        [follow removeTarget:self action:@selector(deFollow:) forControlEvents:UIControlEventTouchUpInside];
        [follow addTarget:self action:@selector(follow:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [follow setTitle:@"取消关注" forState:UIControlStateNormal];
        [follow.titleLabel setTextColor:[UIColor blackColor]];
        [follow removeTarget:self action:@selector(follow:) forControlEvents:UIControlEventTouchUpInside];
        [follow addTarget:self action:@selector(deFollow:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [RORUtils setFontFamily:APP_FONT forView:cell andSubViews:YES];
    
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
    return 86;
//    if (indexPath.row<contentList.count)
//        return 77;
//    return 50;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


@end
