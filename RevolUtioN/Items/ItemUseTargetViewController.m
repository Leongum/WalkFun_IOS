//
//  ItemUseTargetViewController.m
//  WalkFun
//
//  Created by Bjorn on 14-2-17.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "ItemUseTargetViewController.h"

@interface ItemUseTargetViewController ()

@end

@implementation ItemUseTargetViewController

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
    
    //todo:load content
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

- (IBAction)use2Self:(id)sender {
    //todo
    [self useItemTo:[RORUserUtils getUserId]];
}

-(void)useItemTo:(NSNumber *)userId{
    //todo
    [self sendSuccess:@"使用成功"];
    [self backAction:self];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
//    return contentList.count;
}

- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = nil;
    UITableViewCell *cell = nil;
    identifier = @"friendCell";
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

@end
