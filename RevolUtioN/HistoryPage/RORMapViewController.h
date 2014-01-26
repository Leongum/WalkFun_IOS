//
//  RORMapViewController.h
//  RevolUtioN
//
//  Created by Beyond on 13-6-5.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "RORViewController.h"
#import "RORStartAnnotation.h"
#import "ROREndAnnotation.h"

@interface RORMapViewController : RORViewController<MKMapViewDelegate>{
    NSMutableArray *improvedRoute;
}
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) MKPolyline *routeLine;
@property (strong, nonatomic) MKPolyline *routeLineShadow;
@property (retain, nonatomic) NSMutableArray *routes;
@property (retain, nonatomic) MKPolylineView *routeLineView;
@property (retain, nonatomic) MKPolylineView *routeLineShadowView;


@end
