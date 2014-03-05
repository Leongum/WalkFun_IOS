//
//  RORChallengeViewController.m
//  RevolUtioN
//
//  Created by Bjorn on 13-8-21.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORChallengeViewController.h"
#import "RORMissionServices.h"
#import "Animations.h"
#import "FTAnimation.h"
#import "RORMissionServices.h"
#import "RORRunHistoryServices.h"

#define CELL_TITLE_TAG 1
#define CELL_LEVEL_TAG 2
#define CELL_SEX_TAG 3

#define COVERVIEW_LABEL_TAG 1
#define COVERVIEW_BOARD_TAG 2
#define COVERVIEW_BUTTON_TAG 3
#define COVERVIEW_BG_TAG 4

#define LEVELTABLE_FRAME CGRectMake(17.5, 120, 285, 240)

@interface RORChallengeViewController ()

@end

@implementation RORChallengeViewController
@synthesize contentList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initUIControls];
}

-(void)initUIControls{
    
    levelTable = [[RORChallengeLevelView alloc]initWithFrame:self.contentFrameView.frame andNumberOfColumns:6];
    [levelTable setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin];
    [levelTable addTarget:self action:@selector(coverViewBgTap:) forControlEvents:UIControlEventTouchUpInside];
    //    levelTable.backgroundColor=[UIColor whiteColor];//[UIColor colorWithRed:231/255 green:8/255 blue:53/255 alpha:1];
    [self.coverView addSubview:levelTable];
    
//    [RORUtils setFontFamily:CHN_PRINT_FONT forView:self.coverView andSubViews:YES];
//    [RORUtils setFontFamily:ENG_WRITTEN_FONT forView:levelTable andSubViews:YES];
}

-(void)initUIControlsAppearance{
    self.coverView.alpha =0;
    self.backButton.alpha = 1;
}

-(void)loadChallengeTable{
//    NSArray *gradeList = selectedChallenge.challengeList;
//    User_Running_History *thisRecord = [RORRunHistoryServices fetchBestRunHistoryByMissionId:selectedChallenge.missionId withUserId:[RORUserUtils getUserId]];
//    NSInteger userThisGrade = thisRecord?thisRecord.missionGrade.integerValue:GRADE_F;
//    [levelTable setCurrentLevel:userThisGrade];
//    for (int i=0; i<gradeList.count; i++){
//        double thisGrade = ((NSNumber *)[[gradeList objectAtIndex:i] valueForKey:@"time"]).doubleValue;
//        if (i == userThisGrade)
//            thisGrade = thisRecord.duration.doubleValue;
//        UILabel *label = (UILabel*)[levelTable viewWithTag:i+1];
//        label.text = [RORUtils transSecondToStandardFormat:thisGrade];
//    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initUIControlsAppearance];
    [self loadContentList];
    [self.tableView reloadData];
}

-(void)loadContentList{
    //contentList = [RORMissionServices fetchMissionList:Challenge];
//    contentList = [[NSMutableArray alloc]init];
//    [contentList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"1 km", @"title", @"B", @"level", nil]];
//    [contentList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"2 km", @"title", @"A", @"level", nil]];
//    [contentList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"3 km", @"title", @"S", @"level", nil]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCoverView:nil];
    [self setTableView:nil];
    [self setLevelRequirementTable:nil];
    [super viewDidUnload];
}

- (IBAction)levelTableTap:(id)sender {
    [self hideCoverView];
}

-(IBAction)coverViewBgTap:(id)sender{
    [self hideCoverView];
}

-(void)hideCoverView{
    self.coverView.alpha = 0;
//    [Animations fadeOut:self.coverView andAnimationDuration:0.3 fromAlpha:1 andWait:NO];
    self.backButton.alpha = 1;
//    [Animations fadeIn:self.backButton andAnimationDuration:0.3 toAlpha:1 andWait:YES];
}

-(void)showCoverView{
    self.coverView.alpha = 1;
    self.backButton.alpha = 0;
//    [self.coverView fadeIn:0.1 delegate:nil];

//    [Animations fadeIn:self.coverView andAnimationDuration:0.3 toAlpha:1 andWait:NO];
//    [Animations fadeOut:self.backButton andAnimationDuration:0.1 fromAlpha:1 andWait:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *destination = segue.destinationViewController;
    if ([destination respondsToSelector:@selector(setDelegate:)]){
        [destination setValue:self forKey:@"delegate"];
    }

    if ([destination respondsToSelector:@selector(setRunMission:)]){
        [destination setValue:selectedChallenge forKey:@"runMission"];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return contentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"plainCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    Mission *challenge = (Mission *)[contentList objectAtIndex:indexPath.row];
    
    UILabel *titleLabel = (UILabel*)[cell viewWithTag:CELL_TITLE_TAG];
    titleLabel.text = challenge.missionName;
    UILabel *levelLabel = (UILabel *)[cell viewWithTag:CELL_LEVEL_TAG];
    //User_Running_History *best = [RORRunHistoryServices fetchBestRunHistoryByMissionId:challenge.missionId withUserId:[RORUserUtils getUserId]];
//    if (best)
//        levelLabel.text = MissionGradeEnum_toString[best.missionGrade.integerValue];
//    else
//        levelLabel.text = @"?";
    
    NSMutableDictionary *settinglist = [RORUserUtils getUserSettingsPList];
    NSString *sex = [settinglist valueForKey:@"sex"];
    UILabel *sexLabel = (UILabel*)[cell viewWithTag:CELL_SEX_TAG];
    if ([sex isEqualToString:@"女"]){
        sexLabel.text = @"女子";
    } else {
        sexLabel.text = @"男子";
    }
    
    return cell;
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
    selectedChallenge = (Mission *)[contentList objectAtIndex:indexPath.row];
    
    UILabel *titleLabel = (UILabel*)[self.coverView viewWithTag:COVERVIEW_LABEL_TAG];
    titleLabel.text = selectedChallenge.missionName;

    if (self.coverView.alpha==0){
        [self loadChallengeTable];
        [self showCoverView];
    }
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
