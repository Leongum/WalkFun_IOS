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
    
    [self.itemQuantityCoverView removeFromSuperview];
}

-(void)viewDidAppear:(BOOL)animated{
    [self startIndicator:self];
    contentList = [RORVirtualProductService fetchAllVProduct];
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
    [self sendNotification:@"购买成功"];
    
    [self.itemQuantityCoverView bgTap:self];
}

//选择某件道具后弹出该道具的购买页面
-(void)showItemQuantityCover{
    [self.view addSubview:self.itemQuantityCoverView];
    [self.itemQuantityCoverView appear:self];
    [self.pickView selectRow:0 inComponent:0 animated:NO];
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
    itemDescLabel.text = item.productDescription;
    [itemDescLabel setLineBreakMode:NSLineBreakByWordWrapping];
    itemDescLabel.numberOfLines = 3;

    UILabel *costLabel = (UILabel *)[cell viewWithTag:103];
    costLabel.text = [NSString stringWithFormat:@"$ %d", item.virtualPrice.integerValue];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedItem = [contentList objectAtIndex:indexPath.row];
    [self showItemQuantityCover];
}

#pragma mark -
#pragma mark Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 10;
}

#pragma mark Picker Delegate Methods
- (NSString *)titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%d", row+1];
}

//- (CGFloat)pickerView:(UIPickerView*)pickerView widthForComponent:(NSInteger)component{
//    if (component<3)
//        return 80;
//    return 40;
//}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12.0f, 0.0f, [pickerView rowSizeForComponent:component].width-12, [pickerView rowSizeForComponent:component].height)];
    
    [label setText:[self titleForRow:row forComponent:component]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    return label;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.totalCost.text = [NSString stringWithFormat:@"$ %d", (row+1)*selectedItem.virtualPrice.integerValue];
    [self.totalCost pop:0.5 delegate:self];
}
@end
