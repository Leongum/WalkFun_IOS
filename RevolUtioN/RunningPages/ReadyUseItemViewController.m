//
//  ReadyUseItemViewController.m
//  WalkFun
//
//  Created by Bjorn on 14-3-25.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "ReadyUseItemViewController.h"

@interface ReadyUseItemViewController ()

@end

@implementation ReadyUseItemViewController
@synthesize userBase, delegate;

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
    self.backButton.alpha = 0;
    contentList = [RORUserPropsService fetchUserProps:[RORUserUtils getUserId]];
    itemList = [[NSMutableArray alloc]init];
    for (int i=0; i<contentList.count; i++){
        User_Prop *userItem = (User_Prop *)[contentList objectAtIndex:i];
        [itemList addObject:[RORVirtualProductService fetchVProduct:userItem.productId]];
    }
    
    [RORUtils setFontFamily:APP_FONT forView:self.view andSubViews:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

 -(IBAction)backAction:(id)sender{
     [self dismissViewControllerAnimated:YES completion:^(){}];
 }

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return contentList.count;
}

- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = nil;
    UITableViewCell *cell = nil;
    identifier = @"itemCell";
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    User_Prop *userProp = [contentList objectAtIndex:indexPath.row];
    UILabel *propNameLabel = (UILabel *)[cell viewWithTag:100];
    propNameLabel.text = userProp.productName;
    
    Virtual_Product *thisItem = [itemList objectAtIndex:indexPath.row];
    UIImageView *itemIcon = (UIImageView *)[cell viewWithTag:200];
    UIImage *iconImage = [RORVirtualProductService getImageOf:thisItem];
    itemIcon.image = iconImage;
    
    [RORUtils setFontFamily:APP_FONT forView:cell andSubViews:YES];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    User_Prop *userProp = [contentList objectAtIndex:indexPath.row];
    Virtual_Product *item = [RORVirtualProductService fetchVProduct:userProp.productId];
    NSString *alertMessage = [NSString stringWithFormat:@"确定要使用【%@】吗？\n\n战斗力: +4->+5\n体力: +3->+1\n  ", userProp.productName];
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"使用道具" andMessage:alertMessage];
    [alertView addButtonWithTitle:@"取消"
                             type:SIAlertViewButtonTypeCancel
                          handler:^(SIAlertView *alertView) {
                          }];
    [alertView addButtonWithTitle:@"确定"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView) {
                              [delegate setValue:item forKey:@"selectedItem"];
                              [self backAction:self];
                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    
    [alertView show];
}


@end
