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
    BOOL wasFound;
    NSArray *routes;
    UIImage *annotationImage;
    BOOL expanded;
    double centerLoc;
    
    NSMutableArray *speedList;
    
}
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) MKPolyline *routeLine;
@property (strong, nonatomic) MKPolyline *routeLineShadow;
@property (retain, nonatomic) MKPolylineView *routeLineView;
@property (retain, nonatomic) MKPolylineView *routeLineShadowView;
@property (strong, nonatomic) IBOutlet UIView *labelContainerView;
@property (strong, nonatomic) IBOutlet UIView *dataContainerView;
@property (strong, nonatomic) IBOutlet UIView *testContainer;
@property (strong, nonatomic) IBOutlet UIView *iconContainerView;

@property (weak, nonatomic) RORViewController *delegate;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
//@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (strong, nonatomic) IBOutlet UIButton *speedButton;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *energyLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *experienceLabel;
@property (weak, nonatomic) IBOutlet UILabel *bonusLabel;
@property (strong, nonatomic) User_Running_History *record;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

//@property (strong, nonatomic) IBOutlet UIControl *coverView;
@property (strong, nonatomic) IBOutlet UILabel *levelTitleLabel;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;

@property (strong, nonatomic) IBOutlet UIView *mapCoverView;
@property (strong, nonatomic) IBOutlet UILabel *dragLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
//@property (strong, nonatomic) IBOutlet UIButton *switchSpeedButton;
@property (strong, nonatomic) IBOutlet UIView *tableContrainerView;

//- (IBAction)shareToWeixin:(id)sender;

//@property (strong, nonatomic) NSNumber *distance;
//@property (strong, nonatomic) NSNumber *speed;
//@property (strong,nonatomic) NSNumber * duration;
//@property (strong,nonatomic) NSNumber * energy;
//@property (strong,nonatomic) NSNumber * weather;
//@property (strong,nonatomic) NSNumber * score;

@end
