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
#import "RORChallengeCongratsCoverView.h"
#import "RORStartAnnotation.h"
#import "ROREndAnnotation.h"

@interface RORHistoryDetailViewController : RORViewController <MKMapViewDelegate>{
    NSMutableArray *improvedRoute;
    BOOL expanded;
    double centerLoc;
    
    NSArray *eventList;
    NSArray *eventTimeList;
}
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UIView *testContainer;

@property (weak, nonatomic) RORViewController *delegate;

@property (weak, nonatomic) IBOutlet UILabel *stepLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (strong, nonatomic) User_Running_History *record;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end
