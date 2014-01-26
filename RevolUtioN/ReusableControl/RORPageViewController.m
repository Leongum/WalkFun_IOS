//
//  RORPageViewController.m
//  RevolUtioN
//
//  Created by Bjorn on 13-9-10.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORPageViewController.h"

@interface RORPageViewController ()

@end

@implementation RORPageViewController
@synthesize page,formerButton,nextButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    formerButton=nil;
    nextButton = nil;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.backButton.alpha =0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setPage:(NSInteger)newPage{
    page = newPage;
//    if ((page|PAGE_POINTER_LEFT) == page){
//        formerButton = [[UIButton alloc]initWithFrame:[self nextPagePointLeftFrame]];
//        [formerButton setBackgroundImage:[UIImage imageNamed:@"red_left.png"] forState:UIControlStateNormal];
//        [self.view addSubview:formerButton];
//    }
//    if ((page|PAGE_POINTER_RIGHT) == page){
//        nextButton = [[UIButton alloc]initWithFrame:[self nextPagePointRigheFrame]];
//        [nextButton setBackgroundImage:[UIImage imageNamed:@"red_right.png"] forState:UIControlStateNormal];
//        [self.view addSubview:nextButton];
//    }
}

-(CGRect)nextPagePointLeftFrame{
    CGRect rx = [ UIScreen mainScreen ].applicationFrame;
    return CGRectMake(0, rx.size.height/2-NEXT_PAGE_POINTER_SIZE/2, NEXT_PAGE_POINTER_SIZE, NEXT_PAGE_POINTER_SIZE);
}

-(CGRect)nextPagePointRigheFrame{
    CGRect rx = [ UIScreen mainScreen ].applicationFrame;
    return CGRectMake(rx.size.width-NEXT_PAGE_POINTER_SIZE, rx.size.height/2-NEXT_PAGE_POINTER_SIZE/2, NEXT_PAGE_POINTER_SIZE, NEXT_PAGE_POINTER_SIZE);
}

@end
