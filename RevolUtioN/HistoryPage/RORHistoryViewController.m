//
//  RORHistoryViewController.m
//  RevolUtioN
//
//  Created by Beyond on 13-6-7.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORHistoryViewController.h"
#import "RORAppDelegate.h"
#import "User_Running_History.h"
#import "RORUtils.h"
#import "RORRunHistoryServices.h"
#import "RORUserServices.h"
#import "Animations.h"
#import "RORImageView.h"
#import "FTAnimation+UIView.h"

@interface RORHistoryViewController ()

@end

@implementation RORHistoryViewController
@synthesize runHistoryList, dateList, sortedDateList, syncButtonItem;

- (void)viewDidUnload{
    [self setSyncButtonItem:nil];
    [self setRunHistoryList:nil];
    [self setDateList:nil];
    [self setSortedDateList:nil];
    [self setTableView:nil];
    [self setNoHistoryMessageLabel:nil];
    [super viewDidUnload];
}

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
    scrolled = NO;
    [super viewDidLoad];
    self.noHistoryMessageLabel.text = @"居然一次都没？！";
    self.noHistoryMessageLabel.alpha = 0;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


-(void)initTableData{
    runHistoryList = [[NSMutableDictionary alloc] init];
    dateList = [[NSMutableArray alloc] init];

    NSArray *fetchObject = [RORRunHistoryServices fetchRunHistoryByUserId:[RORUserUtils getUserId]];
    if (fetchObject>0){
        [self showContent];
        for (User_Running_History *historyObj in fetchObject) {
            NSDate *date = [historyObj valueForKey:@"missionDate"];
            NSDateFormatter *formate = [[NSDateFormatter alloc] init];
            //    formate.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
            [formate setDateFormat:@"yyyy-MM-dd"];
            //        [formate setTimeStyle:NSDateFormatterNoStyle];
            NSString *formatDateString = [formate stringFromDate:date];
            if (![dateList containsObject:formatDateString])
                [dateList addObject:formatDateString];
            NSMutableArray *record4Date = [runHistoryList objectForKey:formatDateString];
            if (record4Date == nil)
                record4Date = [[NSMutableArray alloc] init];
            [record4Date addObject:historyObj];
            [runHistoryList setObject:record4Date forKey:formatDateString];
        }
    } else {
        [self hideContent];
    }

    sortedDateList = [dateList sortedArrayUsingComparator:^(NSString *str1, NSString *str2){
        return [str2 compare:str1];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshTable];
}

-(void)refreshTable{
    [self initTableData];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showContent{
    self.tableView.alpha = 1;
    self.noHistoryMessageLabel.alpha = 0;
}

-(void)hideContent{
    self.tableView.alpha = 0;
    self.noHistoryMessageLabel.alpha = 1;
}

#pragma mark - Action



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return sortedDateList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString *date_str = [sortedDateList objectAtIndex:section];
    NSArray *records4Date = [runHistoryList objectForKey:date_str];
    return records4Date.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return (NSString *)[sortedDateList objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"plainCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    [RORUtils setFontFamily:ENG_WRITTEN_FONT forView:cell andSubViews:YES];
    
    NSString *date_str = [sortedDateList objectAtIndex:indexPath.section];
    NSArray *records4DateList = [runHistoryList objectForKey:date_str];
    User_Running_History *record4Date = [records4DateList objectAtIndex:indexPath.row];
    UILabel *distanceLabel = (UILabel *)[cell viewWithTag:DISTANCE];
    distanceLabel.text = [NSString stringWithFormat:@"%@步",record4Date.steps];
    UILabel *durationLabel = (UILabel *)[cell viewWithTag:DURATION];
    durationLabel.text = [RORUtils transSecondToStandardFormat:[record4Date.duration integerValue]];
    if (record4Date.valid.integerValue<=0){
        distanceLabel.textColor = [UIColor grayColor];
        durationLabel.textColor = [UIColor grayColor];
    }else{
        distanceLabel.textColor = [UIColor blackColor];
        durationLabel.textColor = [UIColor darkGrayColor];
    }
    
    RORImageView *isValidImage = (RORImageView *)[cell viewWithTag:VALID];

    isValidImage.alpha = 0;
    bottomIndexPath = indexPath;
    return cell;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *result = nil;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, tableView.frame.size.width-50, 22)];
    label.text = (NSString *)[sortedDateList objectAtIndex:section];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor darkGrayColor];
    label.backgroundColor = [UIColor clearColor];

    result = [[UIView alloc] initWithFrame:label.frame];
    [result addSubview:label];
    return result; 
}

#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark - Navigation Related

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *destination = segue.destinationViewController;
    if ([destination respondsToSelector:@selector(setDelegate:)]){
        [destination setValue:self forKey:@"delegate"];
    }
    if ([destination respondsToSelector:@selector(setRecord:)]){
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        //        NSLog(@"%d->%d", indexPath.section, indexPath.row);
        NSString *date_str = [sortedDateList objectAtIndex:indexPath.section];
        NSArray *records4DateList = [runHistoryList objectForKey:date_str];
        User_Running_History *record4Date = [records4DateList objectAtIndex:indexPath.row];
        [destination setValue:record4Date forKey:@"record"];
    }
}

-(IBAction)backAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^(){}];
}


@end
