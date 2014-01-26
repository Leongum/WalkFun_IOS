//
//  RORPageViewController.h
//  RevolUtioN
//
//  Created by Bjorn on 13-9-10.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RORViewController.h"

#define NEXT_PAGE_POINTER_SIZE 44

#define PAGE_POINTER_LEFT 1
#define PAGE_POINTER_RIGHT 2

@interface RORPageViewController : RORViewController{
}

@property (nonatomic) NSInteger page;
@property (strong, nonatomic) UIButton *formerButton;
@property (strong, nonatomic) UIButton *nextButton;
@end
