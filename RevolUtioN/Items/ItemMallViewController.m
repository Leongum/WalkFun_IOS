//
//  ItemMallViewController.m
//  WalkFun
//
//  Created by Bjorn on 14-2-15.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "ItemMallViewController.h"
#import "FTAnimation.h"

@interface ItemMallViewController ()

@end

@implementation ItemMallViewController
@synthesize userBase;

#pragma mark ViewController initial

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
    userMoney = userBase.userDetail.goldCoin.integerValue;
    self.moneyLabel.text = [NSString stringWithFormat:@"%d", userMoney];
    [self.itemQuantityCoverView removeFromSuperview];
    
}

-(void)viewDidAppear:(BOOL)animated{
    contentList = [[NSMutableArray alloc]initWithArray:[RORVirtualProductService fetchAllVProduct]];
    NSMutableArray *deletingList = [[NSMutableArray alloc]init];
    for (Virtual_Product *item in contentList) {
        if (item.virtualPrice == nil || item.virtualPrice.integerValue == 0)
            [deletingList addObject:item];
    }
    [contentList removeObjectsInArray:deletingList];
    [self.tableView reloadData];
    [self endIndicator:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Actions

-(IBAction)backAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^(){}];
}

//点“购买”之后执行这里
- (IBAction)buyAction:(id)sender {
    [self startIndicator:self];
    [self.itemQuantityCoverView bgTap:self];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        isServiceSuccess = [RORUserPropsService buyUserProps:selectedItem.productId withBuyNumbers:[NSNumber numberWithInt:selectedQuantity]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self endIndicator:self];
            if (isServiceSuccess){
                userBase = [RORUserServices fetchUser:[RORUserUtils getUserId]];
                userMoney = userBase.userDetail.goldCoin.integerValue;
                [self sendNotification:@"购买成功"];
                [self.itemQuantityCoverView bgTap:self];
            } else {
                [self sendNotification:@"网络错误"];
            }
            self.moneyLabel.text = [NSString stringWithFormat:@"%d", userMoney];
        });
    });
}

//选择某件道具后弹出该道具的购买页面
-(void)showItemQuantityCover{
    [self.itemQuantityCoverView addCoverBgImage];
    [self.view addSubview:self.itemQuantityCoverView];
    [self.itemQuantityCoverView appear:self];
    [self.pickView reloadAllComponents];
    [self.pickView selectRow:0 inComponent:0 animated:NO];
    selectedQuantity = 1;
    self.totalCost.text = [NSString stringWithFormat:@"$ %d", selectedItem.virtualPrice.integerValue];
    self.selectedItemNameLabel.text = selectedItem.productName;
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
    
    Virtual_Product *item = [contentList objectAtIndex:indexPath.row];

    //为cell填内容
    UIImageView *itemIcon = (UIImageView *)[cell viewWithTag:100];
    UIImage *iconImage = [RORVirtualProductService getImageOf:item];
    itemIcon.image = iconImage;
    
    UILabel *itemNameLabel = (UILabel *)[cell viewWithTag:101];
    itemNameLabel.text = item.productName;
    
    UILabel *itemDescLabel = (UILabel *)[cell viewWithTag:102];
    [itemDescLabel setLineBreakMode:NSLineBreakByWordWrapping];
    itemDescLabel.numberOfLines = 0;
    NSMutableString *desc = [[NSMutableString alloc]initWithString:item.productDescription];
    [desc replaceOccurrencesOfString:@"\\n" withString:@"\n" options:NSLiteralSearch|NSCaseInsensitiveSearch range:NSMakeRange(0, [desc length])];
    itemDescLabel.text = desc;


    UILabel *costLabel = (UILabel *)[cell viewWithTag:103];
    costLabel.text = [NSString stringWithFormat:@"$ %d", item.virtualPrice.integerValue];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedItem = [contentList objectAtIndex:indexPath.row];
    if (userMoney / selectedItem.virtualPrice.integerValue > 0){
        [self showItemQuantityCover];
    } else {
        [self sendAlart:@"好像买不起"];
    }
}

#pragma mark -
#pragma mark Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component{
    return userMoney / selectedItem.virtualPrice.integerValue;
}

#pragma mark Picker Delegate Methods
- (NSString *)titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%d", row+1];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12.0f, 0.0f, [pickerView rowSizeForComponent:component].width-12, [pickerView rowSizeForComponent:component].height)];
    
    [label setText:[self titleForRow:row forComponent:component]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    return label;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    selectedQuantity = (row+1);
    self.totalCost.text = [NSString stringWithFormat:@"$ %d", selectedQuantity*selectedItem.virtualPrice.integerValue];
    [self.totalCost pop:0.5 delegate:self];
}
@end
