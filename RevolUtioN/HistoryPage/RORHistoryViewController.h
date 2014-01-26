//
//  RORHistoryViewController.h
//  RevolUtioN
//
//  Created by Beyond on 13-6-7.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RORPageViewController.h"

typedef enum {DISTANCE = 1, DURATION = 2, VALID = 3, LEVEL = 4} controlInHistoryTableCell;

@interface RORHistoryViewController : RORPageViewController{
    NSMutableArray *stampList;
    NSIndexPath *bottomIndexPath;
    BOOL scrolled;
    NSMutableDictionary *hasRotated;
}

@property (weak, nonatomic) IBOutlet UIButton *syncButtonItem;
@property (strong, nonatomic) NSMutableDictionary *runHistoryList;
@property (strong, nonatomic) NSMutableArray *dateList;
@property (strong, nonatomic) NSArray *sortedDateList;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *noHistoryMessageLabel;

- (void)refreshTable;
@end
