//
//  RORHistoryPageViewController.m
//  RevolUtioN
//
//  Created by Bjorn on 13-8-19.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORHistoryPageViewController.h"
#import "RORPageViewController.h"
#import "FTAnimation.h"
#import "RORUserServices.h"

#define FILTER_TABLECELL_TITLE 1
#define FILTER_TABLECELL_IMAGE 2

@interface RORHistoryPageViewController ()

@end

@implementation RORHistoryPageViewController
@synthesize contentViews, statisticsViewController, listViewController, filter;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)syncAction:(id)sender {
    //sync runningHistory
    BOOL synced = [RORRunHistoryServices syncRunningHistories:[RORUserUtils getUserId]];
    BOOL updated = [RORRunHistoryServices uploadRunningHistories];
    [RORUserServices syncUserInfoById:[RORUserUtils getUserId]];
    if(synced && updated){
        [self sendSuccess:SYNC_DATA_SUCCESS];
        [listViewController refreshTable];
        [statisticsViewController viewWillAppear:NO];
    }
    else{
        [self sendAlart:SYNC_DATA_FAIL];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self loadChecked];
    
	// Do any additional setup after loading the view.
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i <3; i++)
		[controllers addObject:[NSNull null]];

    self.contentViews = controllers;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:[NSBundle mainBundle]];
    listViewController =  [storyboard instantiateViewControllerWithIdentifier:@"historyListViewController"];
    statisticsViewController = [storyboard instantiateViewControllerWithIdentifier:@"historyStatisticsViewController"];
    
    [contentViews replaceObjectAtIndex:1 withObject:statisticsViewController];
    //    userInfoRunHistoryView = [[RORUserRunHistoryViewController alloc]initWithPageNumber:1];
    //    [contentViews replaceObjectAtIndex:1 withObject:userInfoRunHistoryView];
    //    self.historyInStoryboard = [[RORUserRunHistoryViewController alloc]initWithPageNumber:1];
    [contentViews replaceObjectAtIndex:0 withObject:listViewController];
    
    NSInteger numberPages = contentViews.count;
    // a page is the width of the scroll view
    
    self.scrollView.contentSize =
    CGSizeMake(CGRectGetWidth(self.scrollView.frame) * numberPages, 0);
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    
    self.pageControl.numberOfPages = numberPages;
    self.pageControl.currentPage = 0;

//    self.formerPageButton.frame = [self nextPagePointLeftFrame];
//    self.nextPageButton.frame = [self nextPagePointRigheFrame];
    self.formerPageButton.alpha = 0;
    self.nextPageButton.alpha = 0;
    
    [self loadPage:0];
    [self loadPage:1];
    [self loadPage:2];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self.pageControl popIn:0.5 delegate:self];
//    [self.pageControl elastic:0.5 delegate:self];
//    if (self.pageControl.currentPage != 1){
//        [self gotoNextPage:self];
//    }
    if (!((NSNumber *)[RORUserUtils hasStatisticsPageAppeared]).boolValue){
        [self gotoNextPage:self];
        [RORUserUtils statisticsPageDidAppeared];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.pageControl.currentPage = [RORUserUtils getStatisticsDefaultPage].integerValue;
    [self gotoPage:NO];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [RORUserUtils saveStatisticsDefaultPage:self.pageControl.currentPage];
}

-(CGRect)nextPagePointLeftFrame{
    CGRect rx = [ UIScreen mainScreen ].applicationFrame;
    return CGRectMake(0, rx.size.height/2-NEXT_PAGE_POINTER_SIZE/2, NEXT_PAGE_POINTER_SIZE, NEXT_PAGE_POINTER_SIZE);
}

-(CGRect)nextPagePointRigheFrame{
    CGRect rx = [ UIScreen mainScreen ].applicationFrame;
    return CGRectMake(rx.size.width-NEXT_PAGE_POINTER_SIZE, rx.size.height/2-NEXT_PAGE_POINTER_SIZE/2, NEXT_PAGE_POINTER_SIZE, NEXT_PAGE_POINTER_SIZE);
}

-(void)loadChecked{
    self.coverView.alpha = 0;
    isChecked[0] = YES;
    isChecked[1] = YES;
    isChecked[2] = YES;
    [self updateFilter];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setPageControl:nil];
    [self setFilterTableView:nil];
    [self setCoverView:nil];
    [self setFormerPageButton:nil];
    [self setNextPageButton:nil];
    [super viewDidUnload];
}

-(void)loadPage:(NSInteger)page{

    RORPageViewController *viewController = (RORPageViewController *)[contentViews objectAtIndex:page];
    CGRect frame = self.scrollView.frame;
    frame.origin.x = CGRectGetWidth(frame) * page;
    frame.origin.y = 0;
    viewController.view.frame = frame;
    
    //let the page controller know which page switch button it should have
    if (page ==0){
        viewController.page = PAGE_POINTER_RIGHT;
    } else if (page == contentViews.count-1){
        viewController.page = PAGE_POINTER_LEFT;
    } else{
        viewController.page = PAGE_POINTER_LEFT + PAGE_POINTER_RIGHT;
    }
    
    //add button action
    if (viewController.formerButton != nil)
        [viewController.formerButton addTarget:self action:@selector(gotoFormerPage) forControlEvents:UIControlEventTouchUpInside];
    if (viewController.nextButton != nil)
        [viewController.nextButton addTarget:self action:@selector(gotoNextPage) forControlEvents:UIControlEventTouchUpInside];
    
    [self addChildViewController:viewController];
    [self.scrollView addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
    
    [listViewController refreshTable];
}

-(IBAction)gotoFormerPage:(id)sender{
    self.pageControl.currentPage--;
    [self gotoPage:YES];
}

-(IBAction)gotoNextPage:(id)sender{
    self.pageControl.currentPage++;
    [self gotoPage:YES];
}

#pragma mark UIScrollViewDelegate

// at the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
//    if (self.pageControl.currentPage <=1)
//        self.formerPageButton.alpha = scrollView.contentOffset.x/pageWidth / 2;
//    if (self.pageControl.currentPage >=contentViews.count-2)
//        self.nextPageButton.alpha = (pageWidth * (contentViews.count-1) - scrollView.contentOffset.x)/pageWidth /2;
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSUInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}

- (void)gotoPage:(BOOL)animated
{
    NSInteger page = self.pageControl.currentPage;
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
//    [self loadUserInfoBasicPage:0];
//    [self loadUserInfoRunHistoryPage:1];
//    [self loadUserInfoDoneMissionsPage:2];
//    [self loadPage:0];
//    [self loadPage:1];
//    
	// update the scroll view to the appropriate page
    CGRect bounds = self.scrollView.bounds;
    CGPoint offset;
    offset.x = CGRectGetWidth(bounds) * page;
    offset.y = 0;
    [self.scrollView setContentOffset:offset animated:YES];
//    bounds.origin.x = CGRectGetWidth(bounds) * page;
//    bounds.origin.y = 0;
//    [self.scrollView scrollRectToVisible:bounds animated:animated];
}

- (IBAction)changePage:(id)sender {
    [self gotoPage:YES];    // YES = animate
}

-(void)updateFilter{
    filter = [[NSMutableArray alloc]init];
    if (isChecked[0])
    //    [filter addObject:[NSNumber numberWithInteger:NormalRun]];
    if (isChecked[2])
    //    [filter addObject:[NSNumber numberWithInteger:Challenge]];
    if (isChecked[1]){
     //   [filter addObject:[NSNumber numberWithInteger:SimpleTask]];
     //   [filter addObject:[NSNumber numberWithInteger:ComplexTask]];
    }
        
}

- (IBAction)showFilter:(id)sender {
    self.coverView.alpha = 1 - self.coverView.alpha;
    if (self.coverView.alpha ==0){
//        [Animations fadeOut:self.coverView andAnimationDuration:0.3 fromAlpha:1 andWait:NO];
        [self updateFilter];
        [listViewController refreshTable];
        [statisticsViewController viewWillAppear:NO];
        [Animations moveRight:self.syncButton andAnimationDuration:0 andWait:NO andLength:40];
    } else {
//        self.coverView.alpha = 1;
//        [Animations fadeIn:self.coverView andAnimationDuration:0.3 toAlpha:1 andWait:NO];
        [Animations moveLeft:self.syncButton andAnimationDuration:0 andWait:NO andLength:40];
    }
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return sizeof(isChecked);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"plainCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel *title = (UILabel*)[cell viewWithTag:FILTER_TABLECELL_TITLE];
    UIImageView *check = (UIImageView*)[cell viewWithTag:FILTER_TABLECELL_IMAGE];
    check.alpha = 0;
    if (isChecked[indexPath.row]){
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        check.alpha = 1;
    }
    switch (indexPath.row) {
        case 0:
            title.text = @"随便跑跑";
            break;
        case 1:
            title.text = @"训练";
            break;
        case 2:
            title.text = @"比赛";
        default:
            break;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    isChecked[indexPath.row] = YES;
    [cell viewWithTag:FILTER_TABLECELL_IMAGE].alpha = 1;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    isChecked[indexPath.row] = NO;
    [cell viewWithTag:FILTER_TABLECELL_IMAGE].alpha = 0;
}
@end
