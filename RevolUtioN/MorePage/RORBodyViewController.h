//
//  RORBodyViewController.h
//  RevolUtioN
//
//  Created by Bjorn on 13-8-27.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORViewController.h"
#import "RORBottomPopSubview.h"
#import "RORUserServices.h"
#import "RORPaperSegmentControl.h"

#define HEIGHT_PICKER 0
#define WEIGHT_PICKER 1

#define HEIGHT_PICKER_MIN 120
#define HEIGHT_PICKER_MAX 240

#define WEIGHT_PICKER_MIN 30
#define WEIGHT_PICKER_MAX 150

@interface RORBodyViewController : RORViewController{
    double newHeight, newWeight;
    NSString *newSex;
    NSIndexPath *selection;
    NSString *cache;
    BOOL isValid;
}

@property (strong, nonatomic) UIViewController *delegate;
@property (strong, nonatomic) NSManagedObjectContext *context;
//@property (strong, nonatomic) IBOutlet RORBottomPopSubview *coverView;
@property (retain, nonatomic) IBOutlet User_Base *content;
//@property (strong, nonatomic) IBOutlet UIPickerView *picker;
@property (strong, nonatomic) IBOutlet UITableView *table;

@end
