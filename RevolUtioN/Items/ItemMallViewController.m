//
//  ItemMallViewController.m
//  WalkFun
//
//  Created by Bjorn on 14-2-15.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "ItemMallViewController.h"

@interface ItemMallViewController ()

@end

@implementation ItemMallViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^(){}];
}

- (IBAction)buyAction:(id)sender {
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = nil;
    UITableViewCell *cell = nil;
    identifier = @"itemCell";
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
