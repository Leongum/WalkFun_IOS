//
//  RORHistoryDetailViewController.h
//  RevolUtioN
//
//  Created by Beyond on 13-6-7.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import "RORRunHistoryServices.h"
#import "RORViewController.h"
#import "RORStartAnnotation.h"
#import "ROREndAnnotation.h"
#import "RORMissionHistoyService.h"
#import "CoverView.h"
#import "PooViewController.h"
#import "ItemIconView.h"

#define ICON_SIZE_ITEM 50

@interface RORHistoryDetailViewController : RORViewController <MKMapViewDelegate>{
    NSMutableArray *improvedRoute;
    BOOL expanded;
    double centerLoc;
    
    NSMutableArray *eventList;
    NSArray *eventTimeList;
    NSMutableArray *eventDisplayList;
    NSMutableArray *eventDisplayTimeList;
    
    User_Base *userBase;
}
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UIView *testContainer;

@property (weak, nonatomic) RORViewController *delegate;

@property (weak, nonatomic) IBOutlet UILabel *stepLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (strong, nonatomic) User_Running_History *record;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *sumLabel;

@property (strong, nonatomic) IBOutlet UIScrollView *itemGetScrollView;

@end
