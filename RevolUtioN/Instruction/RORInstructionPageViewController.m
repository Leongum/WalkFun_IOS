//
//  RORInstructionPageViewController.m
//  WalkFun
//
//  Created by Bjorn on 13-10-18.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORInstructionPageViewController.h"

@interface RORInstructionPageViewController ()

@end

@implementation RORInstructionPageViewController
@synthesize contentViews;

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
    self.backButton.alpha = 0;
    
	// Do any additional setup after loading the view.
    
	// Do any additional setup after loading the view.
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i <2; i++)
		[controllers addObject:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"running_countdown_2.png"]]];
    
    self.contentViews = controllers;
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:[NSBundle mainBundle]];
//    listViewController =  [storyboard instantiateViewControllerWithIdentifier:@"historyListViewController"];
//    statisticsViewController = [storyboard instantiateViewControllerWithIdentifier:@"historyStatisticsViewController"];
    
//    [contentViews replaceObjectAtIndex:1 withObject:statisticsViewController];
    //    userInfoRunHistoryView = [[RORUserRunHistoryViewController alloc]initWithPageNumber:1];
    //    [contentViews replaceObjectAtIndex:1 withObject:userInfoRunHistoryView];
    //    self.historyInStoryboard = [[RORUserRunHistoryViewController alloc]initWithPageNumber:1];
//    [contentViews replaceObjectAtIndex:0 withObject:listViewController];
    
    NSInteger numberPages = contentViews.count;
    // a page is the width of the scroll view
    
    self.scrollView.contentSize =
    CGSizeMake(CGRectGetWidth(self.scrollView.frame) * numberPages, 0);
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    
    self.pageControl.numberOfPages = numberPages;
    self.pageControl.currentPage = 0;
    
    [self loadPage:0];
    [self loadPage:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loadPage:(NSInteger)page{
    
    UIImageView *imageView = (UIImageView *)[contentViews objectAtIndex:page];
    CGRect frame = self.scrollView.frame;
    frame.origin.x = CGRectGetWidth(frame) * page;
    frame.origin.y = 0;
    imageView.frame = frame;
    
    //let the page controller know which page switch button it should have
    //    if (page ==0){
    //        viewController.page = PAGE_POINTER_RIGHT;
    //    } else if (page == contentViews.count-1){
    //        viewController.page = PAGE_POINTER_LEFT;
    //    } else{
    //        viewController.page = PAGE_POINTER_LEFT + PAGE_POINTER_RIGHT;
    //    }
    //
    //    //add button action
    //    if (viewController.formerButton != nil)
    //        [viewController.formerButton addTarget:self action:@selector(gotoFormerPage) forControlEvents:UIControlEventTouchUpInside];
    //    if (viewController.nextButton != nil)
    //        [viewController.nextButton addTarget:self action:@selector(gotoNextPage) forControlEvents:UIControlEventTouchUpInside];
    
    //    [self addChildViewController:viewController];
    [self.scrollView addSubview:imageView];
    //    [viewController didMoveToParentViewController:self];
    
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


@end
