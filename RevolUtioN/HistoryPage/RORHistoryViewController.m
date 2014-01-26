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
#import "RORHistoryPageViewController.h"
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

- (void)viewDidLoad
{
    scrolled = NO;
    [super viewDidLoad];
    //syncButtonItem.enabled = ([RORUtils hasLoggedIn]!=nil);
//    [self initTableData];
//    [RORUtils setFontFamily:CHN_PRINT_FONT forView:self.noHistoryMessageLabel andSubViews:NO];
    self.noHistoryMessageLabel.text = NO_HISTORY;// @"真的一次都没有跑过耶";
    self.noHistoryMessageLabel.alpha = 0;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self setRandomStampArc];
//    if (!scrolled) {
//        NSString *date_str = [sortedDateList objectAtIndex:sortedDateList.count-1];
//        NSArray *records4Date = [runHistoryList objectForKey:date_str];
//        bottomIndexPath = [NSIndexPath indexPathForRow:records4Date.count-1 inSection:sortedDateList.count-1];
//
//        [self.tableView scrollToRowAtIndexPath:bottomIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
//        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//        scrolled = YES;
//    }
}

-(void)setRandomStampArc{
    
    for (NSIndexPath *indexPath in stampList){

        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

        NSString *date_str = [sortedDateList objectAtIndex:indexPath.section];
        NSArray *records4DateList = [runHistoryList objectForKey:date_str];
        User_Running_History *record4Date = [records4DateList objectAtIndex:indexPath.row];

        UIView *isValidImage = [cell viewWithTag:VALID];
        isValidImage.center = CGPointMake(record4Date.duration .integerValue%50+155, ((int)(record4Date.avgSpeed.doubleValue*1024))%20+30);
        [Animations rotate:isValidImage andAnimationDuration:0 andWait:NO andAngle:record4Date.duration.integerValue%60-30];
        [isValidImage fallIn:.2f delegate:self];
        isValidImage.alpha = 1;
    }
}

-(void)hideStamps{
    for (UITableViewCell *cell in stampList){
        //        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        UIView *isValidImage = [cell viewWithTag:VALID];
        isValidImage.alpha = 0;
    }
}

-(void)initTableData{
    hasRotated = [[NSMutableDictionary alloc]init];
    
    NSMutableArray *filter = ((RORHistoryPageViewController*)[self parentViewController]).filter;
    
    runHistoryList = [[NSMutableDictionary alloc] init];
    dateList = [[NSMutableArray alloc] init];
    

    NSArray *fetchObject = [RORRunHistoryServices fetchRunHistoryByUserId:[RORUserUtils getUserId]];
    if (fetchObject>0){
        [self showContent];
        for (User_Running_History *historyObj in fetchObject) {
            NSNumber *missionType = (NSNumber *)[historyObj valueForKey:@"missionTypeId"];
            
            if (![filter containsObject:missionType]) {
                continue;
            }
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
    
    stampList = [[NSMutableArray alloc]init];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshTable];
//    [self hideStamps];
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
    distanceLabel.text = [NSString stringWithFormat:@"%@",[RORUtils outputDistance:record4Date.distance.doubleValue]];
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

//    if (record4Date.valid.integerValue>0 && record4Date.missionTypeId.integerValue == Challenge){
////        isValidImage.alpha = 0;
//        [isValidImage setImage:[UIImage imageNamed:MissionGradeImageEnum_toString[record4Date.missionGrade.integerValue]]];
//        isValidImage.center = CGPointMake(record4Date.duration .integerValue%30+155, ((int)(record4Date.avgSpeed.doubleValue*1024))%20+30);
//        [Animations rotate:isValidImage andAnimationDuration:0 andWait:NO andAngle:record4Date.duration.integerValue%10-5];
//
//            isValidImage.alpha = 1;
//        [cell setHighlighted:YES];
//    } else
        isValidImage.alpha = 0;
    bottomIndexPath = indexPath;
    return cell;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *result = nil;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 22)];
    label.text = (NSString *)[sortedDateList objectAtIndex:section];
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = [UIColor darkGrayColor];
    label.backgroundColor = [UIColor clearColor];
//    [RORUtils setFontFamily:ENG_WRITTEN_FONT forView:label andSubViews:YES];
//    //将UILabel向右移动10个点，沿y轴向下移动5个点
//    label.frame = CGRectMake(label.frame.origin.x + 10.0f,5.0f,label.frame.size.width, label.frame.size.height);
    //container的宽度比UILabel多出是个像素这些像素用于缩进
//    CGRect resultFrame = CGRectMake(0.0f, 0.0f,
//                                    label.frame.size.height,
//                                    label.frame.size.width + 10.0f);
    result = [[UIView alloc] initWithFrame:label.frame];
    [result addSubview:label];
    return result; 
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section>0) return;
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
////        NSLog(@"%d", indexPath.row);
//        NSString *date_str = [dateList objectAtIndex:indexPath.section];
//        NSMutableArray *records4DateList = [runHistoryList objectForKey:date_str];
//        [records4DateList removeObjectAtIndex:indexPath.row];
//        [runHistoryList setObject:records4DateList forKey:date_str];
//        
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationRight];
//    }
//}


@end
