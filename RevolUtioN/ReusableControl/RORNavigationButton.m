//
//  RORNavigationButton.m
//  WalkFun
//
//  Created by Bjorn on 14-1-16.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "RORNavigationButton.h"
#import "RORViewController.h"

@implementation RORNavigationButton
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initButtonInteraction];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self){
        [self initButtonInteraction];
    }
    return self;
}

-(void)initButtonInteraction{
    [super initButtonInteraction];
//    [self removeTarget:self action:@selector(pressOn:) forControlEvents:UIControlEventTouchDown];
//    [self addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(touchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
}

-(IBAction)pressOn:(id)sender{
    [super pressOn:sender];
    [SVProgressHUD showWithStatus:nil maskType:SVProgressHUDMaskTypeClear];
}

-(IBAction)touchUpOutside:(id)sender{
    [SVProgressHUD dismiss];
}



@end
