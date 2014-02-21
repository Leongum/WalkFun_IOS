//
//  RORMainViewController.m
//  WalkFun
//
//  Created by Bjorn on 14-2-14.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "RORMainViewController.h"

@interface RORMainViewController ()

@end

@implementation RORMainViewController
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
    
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i <PAGE_QUANTITY; i++)
		[controllers addObject:[NSNull null]];
    
    self.contentViews = controllers;
    mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:[NSBundle mainBundle]];
    UIStoryboard *friendStoryboard = [UIStoryboard storyboardWithName:@"FriendsStoryboard" bundle:[NSBundle mainBundle]];
    
    firstViewController =  [mainStoryboard instantiateViewControllerWithIdentifier:@"firstViewContoller"];
    friendViewController =  [friendStoryboard instantiateViewControllerWithIdentifier:@"FriendsMainViewController"];
    UIStoryboard *itemStoryboard = [UIStoryboard storyboardWithName:@"ItemsStoryboard" bundle:[NSBundle mainBundle]];
    itemViewController =  [itemStoryboard instantiateViewControllerWithIdentifier:@"ItemsMainViewController"];

    [contentViews replaceObjectAtIndex:0 withObject:itemViewController];
    [contentViews replaceObjectAtIndex:2 withObject:friendViewController];
    [contentViews replaceObjectAtIndex:1 withObject:firstViewController];

    NSInteger numberPages = contentViews.count;
    // a page is the width of the scroll view
    
    self.scrollView.contentSize =
    CGSizeMake(CGRectGetWidth(self.scrollView.frame) * numberPages, 0);
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    
    self.pageControl.numberOfPages = numberPages;
    self.pageControl.currentPage = 1;
    
    for (int i=0; i<PAGE_QUANTITY; i++)
        [self loadPage:i];
    
//    [self loadPage:1];
//    [self loadPage:2];
    
    [self gotoPage:NO];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([RORUserUtils getUserId].integerValue<0) {
        UIViewController *loginViewController =  [mainStoryboard instantiateViewControllerWithIdentifier:@"RORLoginViewController"];
        [self presentViewController:loginViewController animated:NO completion:^(){}];
    } else {
        for (int i=0; i<PAGE_QUANTITY; i++){
            UIViewController *controller =(UIViewController *)[contentViews objectAtIndex:i];
            [controller viewWillAppear:NO];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loadPage:(NSInteger)page{
    MainPageViewController *controller =(MainPageViewController *)[contentViews objectAtIndex:page];
    UIView *view = controller.view;
    CGRect frame = self.scrollView.frame;
    frame.origin.x = CGRectGetWidth(frame) * page;
    frame.origin.y = 0;
    view.frame = frame;
    
    [self addChildViewController:controller];
    [self.scrollView addSubview:view];
    [controller didMoveToParentViewController:self];
    [controller setPage:page];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
//    if (self.pageControl.currentPage <=1)
//        self.formerPageButton.alpha = scrollView.contentOffset.x/pageWidth / 2;
//    if (self.pageControl.currentPage >=contentViews.count-2)
//        self.nextPageButton.alpha = (pageWidth * (contentViews.count-1) - scrollView.contentOffset.x)/pageWidth /2;
    [self refreshPageTitles:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSUInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [self refreshPageTitles:scrollView];
    self.pageControl.currentPage = page;
}

-(void)refreshPageTitles:(UIScrollView *)scrollView{
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    for (int i=0; i<PAGE_QUANTITY; i++){
        MainPageViewController *controller =(MainPageViewController *)[contentViews objectAtIndex:i];
        double offset = self.scrollView.contentOffset.x - i*pageWidth;
        [controller refreshTitleLayout:offset];
    }
}

- (void)gotoPage:(BOOL)animated
{
    NSInteger page = self.pageControl.currentPage;
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)

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

- (IBAction)missionAction:(id)sender {
    [self sendSuccess:@"同步成功"];
}

- (IBAction)settingsAction:(id)sender {
    UIViewController *moreViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"moreViewController"];
    [self presentViewController:moreViewController animated:YES completion:^(){}];
}

@end
