//
//  RORGetReadyViewController.h
//  RevolUtioN
//
//  Created by Beyond on 13-5-16.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "User_Running_History.h"
#import "INTimeWindow.h"
#import "INKalmanFilter.h"
#import "INStepCounting.h"
#import "RORViewController.h"
#import "Mission.h"
#import "RORRunningBaseViewController.h"

@interface RORRunningViewController : RORRunningBaseViewController<MKMapViewDelegate> {
    BOOL MKwasFound;
    User_Running_History *runHistory;
}

@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *endButton;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (strong, nonatomic) IBOutlet RORNavigationButton *saveButton;
@property (strong, nonatomic) IBOutlet UIView *dataContainer;

@property (nonatomic) vec_3 inDistance;

@property (nonatomic) NSInteger timerCount;

@property (retain, nonatomic) MKPolylineView *routeLineView;
@property (retain, nonatomic) MKPolylineView *routeLineShadowView;
@property (strong, nonatomic) MKPolyline *routeLineShadow;

@property (strong, nonatomic) NSDate *startTime;
@property (strong, nonatomic) NSDate *endTime;
@property (strong, nonatomic) User_Running_History* record;

@property (nonatomic) BOOL doCollect;

//@property (strong, nonatomic) Mission *runMission;
@property (weak, nonatomic) IBOutlet UIControl *coverView;

//- (IBAction)expandAction:(id)sender;
//- (IBAction)collapseAction:(id)sender;
- (IBAction)startButtonAction:(id)sender;
- (IBAction)endButtonAction:(id)sender;

- (IBAction)btnCoverInside:(id)sender;
- (IBAction)btnSaveRun:(id)sender;
- (IBAction)btnDeleteRunHistory:(id)sender;
- (void)saveRunInfo;
-(void)creatRunningHistory;

@end
