//
//  RORMoreViewController.h
//  RevolUtioN
//
//  Created by Beyond on 13-5-25.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RORViewController.h"
#import "RORPaperSegmentControl.h"

@interface RORMoreViewController : RORViewController

@property (strong,nonatomic)NSManagedObjectContext *context;

@property (strong, nonatomic) IBOutlet UITableView *moreTableView;

@end
