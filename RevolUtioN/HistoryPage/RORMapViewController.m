//
//  RORMapViewController.m
//  RevolUtioN
//
//  Created by Beyond on 13-6-5.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORMapViewController.h"
#import "RORMapAnnotation.h"
#import <Foundation/Foundation.h>

#define ROUTE_NORMAL 0
#define ROUTE_SHADOW 1

@interface RORMapViewController ()

@end

@implementation RORMapViewController
@synthesize mapView, routeLine, routeLineView ,routes, eventList;
@synthesize record;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.backButton.alpha = 0;
    
    [self.BACKButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    CLLocation *startLoc=nil;
    CLLocation *endLoc=nil;
    for (int j = 0; j<routes.count; j++){
        NSArray *routePoints = [routes objectAtIndex:j];
        
        if (routePoints.count == 0 || routePoints == nil)
            continue;
        if (startLoc==nil){
            startLoc = [routePoints objectAtIndex:0];
            RORStartAnnotation *annotation = [[RORStartAnnotation alloc]initWithCoordinate:startLoc.coordinate];
            annotation.title = @"起点";
            [mapView addAnnotation:annotation];
        }
        endLoc = [routePoints objectAtIndex:routePoints.count-1];
        int couter = 4;
        while (couter-- > 0) {
            improvedRoute = [[NSMutableArray alloc]init];
            [improvedRoute addObject:[routePoints objectAtIndex:0]];
            for (int i=0; i<routePoints.count-1; i++){
                CLLocation *locnext = [routePoints objectAtIndex:i+1];
                CLLocation *locpre = [routePoints objectAtIndex:i];
                
                CLLocationCoordinate2D Q,R;
                Q.latitude = 0.75 * locpre.coordinate.latitude + 0.25 * locnext.coordinate.latitude;
                Q.longitude = 0.75 * locpre.coordinate.longitude + 0.25 * locnext.coordinate.longitude;
                R.latitude = 0.25 * locpre.coordinate.latitude + 0.75 * locnext.coordinate.latitude;
                R.longitude = 0.25 * locpre.coordinate.longitude + 0.75 * locnext.coordinate.longitude;
                
                [improvedRoute addObject:[[CLLocation alloc]initWithLatitude:Q.latitude longitude:Q.longitude]];
                [improvedRoute addObject:[[CLLocation alloc]initWithLatitude:R.latitude longitude:R.longitude]];
            }
            [improvedRoute addObject:[routePoints objectAtIndex:routePoints.count-1]];
            routePoints = improvedRoute;
        }
        improvedRoute = [[NSMutableArray alloc]init];
        for (int i=0; i<routePoints.count; i++){
            CLLocation *loc = [routePoints objectAtIndex:i];
            [improvedRoute addObject:[[CLLocation alloc]initWithLatitude:loc.coordinate.latitude - 0.00002 longitude:loc.coordinate.longitude]];
        }
        [self drawLineWithLocationArray:improvedRoute withStyle:ROUTE_SHADOW];
        [self drawLineWithLocationArray:routePoints withStyle:ROUTE_NORMAL];
    }
    ROREndAnnotation *annotation = [[ROREndAnnotation alloc]initWithCoordinate:endLoc.coordinate];
    annotation.title = @"终点";
    [mapView addAnnotation:annotation];
    
    for (Walk_Event *we in eventList) {
        CLLocationCoordinate2D eventCoor;
        eventCoor.latitude = we.lati.doubleValue;
        eventCoor.longitude = we.longi.doubleValue;
        
        if ([we.eType isEqualToString:RULE_Type_Fight] || [we.eType isEqualToString:RULE_Type_Fight_Friend]){
            RORFightAnnotation *anno = [[RORFightAnnotation alloc]initWithCoordinate:eventCoor];
            anno.title = [NSString stringWithFormat:@"战斗%@",we.eWin.intValue>0?@"胜利":@"失败"];
            [mapView addAnnotation:anno];
        } else {
            Action_Define *actionEvent = [RORSystemService fetchActionDefine:we.eId];
            if ([actionEvent.actionName rangeOfString:@"金币"].location != NSNotFound) {//金币事件
                CoinAnnotation *anno = [[CoinAnnotation alloc]initWithCoordinate:eventCoor];
                anno.title = actionEvent.actionName;
                [mapView addAnnotation:anno];
            } else {//普通事件
                EventAnnotation *anno = [[EventAnnotation alloc]initWithCoordinate:eventCoor];
                anno.title = actionEvent.actionName;
                [mapView addAnnotation:anno];
            }
        }
    }
    
    [self center_map];
    
    [RORUtils setFontFamily:APP_FONT forView:self.view andSubViews:YES];
}

- (void)viewDidUnload{
    [self setMapView:nil];
    [self setRouteLine:nil];
//    [locationManager stopUpdatingLocation];
    [super viewDidUnload];
}


//center the route line
- (void)center_map{
    MKCoordinateRegion region;
    CLLocationDegrees maxLat = -90;
    CLLocationDegrees maxLon = -180;
    CLLocationDegrees minLat = 90;
    CLLocationDegrees minLon = 180;
    int count = 0;
    for (NSArray *routePoints in routes){
        for (int i=0; i<routePoints.count; i++){
            CLLocation *currentLocation = [routePoints objectAtIndex:i];
            if (currentLocation.coordinate.latitude > maxLat)
                maxLat = currentLocation.coordinate.latitude;
            if (currentLocation.coordinate.longitude > maxLon)
                maxLon = currentLocation.coordinate.longitude;
            if (currentLocation.coordinate.latitude < minLat)
                minLat = currentLocation.coordinate.latitude;
            if (currentLocation.coordinate.longitude < minLon)
                minLon = currentLocation.coordinate.longitude;
            count++;
        }
    }
    region.center.latitude = (maxLat + minLat)/2;
    region.center.longitude = (maxLon + minLon)/2;
    region.span.latitudeDelta = maxLat - minLat + 0.001;
    region.span.longitudeDelta = maxLon - minLon + 0.001;
    if (count)
        [mapView setRegion:region animated:YES];
}

- (void)drawLineWithLocationArray:(NSArray *)locationArray withStyle:(NSInteger)style
{
    
    NSUInteger pointCount = [locationArray count];
    CLLocationCoordinate2D *coordinateArray = (CLLocationCoordinate2D *)malloc(pointCount * sizeof(CLLocationCoordinate2D));
    
    for (int i = 0; i < pointCount; ++i) {
        CLLocation *location = [locationArray objectAtIndex:i];
        coordinateArray[i] = [location coordinate];
    }
    
    if (style == ROUTE_NORMAL)
        routeLine = [MKPolyline polylineWithCoordinates:coordinateArray count:pointCount];
    else
        self.routeLineShadow = [MKPolyline polylineWithCoordinates:coordinateArray count:pointCount];
    
//    MKMapRect rect = [routeLine boundingMapRect];
//    [mapView setVisibleMapRect:MKMapRectMake(rect.origin.x-1000, rect.origin.y-1000, rect.size.width+2000, rect.size.height+2000)];
    
    if (style == ROUTE_NORMAL)
        [mapView addOverlay:routeLine];
    else
        [mapView addOverlay:self.routeLineShadow];
    
    free(coordinateArray);
    coordinateArray = NULL;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MKMapViewDelegate

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    MKOverlayView* overlayView = nil;
    
    if(overlay == self.routeLine)
    {
        //if we have not yet created an overlay view for this overlay, create it now.
        //        if(nil == self.routeLineView)
        //        {
        self.routeLineView = [[MKPolylineView alloc] initWithPolyline:self.routeLine];
//        self.routeLineView.fillColor = [UIColor colorWithRed:223 green:8 blue:50 alpha:1];
        self.routeLineView.strokeColor = [UIColor colorWithRed:(46.0/255.0) green:(170.0/255.0) blue:(218.0/255.0) alpha:1];
        self.routeLineView.lineWidth = 10;
        //        }
        overlayView = self.routeLineView;

    } else if (overlay == self.routeLineShadow){
        self.routeLineShadowView = [[MKPolylineView alloc] initWithPolyline:self.routeLineShadow];
        //        self.routeLineView.fillColor = [UIColor colorWithRed:223 green:8 blue:50 alpha:1];
        self.routeLineShadowView.strokeColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        self.routeLineShadowView.lineWidth = 11;
        //        }

        overlayView = self.routeLineShadowView;
    }
    
    return overlayView;
    
}


//#pragma mark Map View Delegate Methods
- (MKAnnotationView *) mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>) annotation {
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    if ([annotation isKindOfClass:[RORStartAnnotation class]]) {
        static NSString *identifier = @"startLocation";
        MKPinAnnotationView* pulsingView = (MKPinAnnotationView *)
        [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (!pulsingView)
        {
            pulsingView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            pulsingView.image = [UIImage imageNamed:@"start_annotation.png"];
            pulsingView.frame = CGRectMake(pulsingView.frame.origin.x, pulsingView.frame.origin.y, 30, 30);
            pulsingView.canShowCallout = YES;
            return pulsingView;
        } else {
            pulsingView.annotation = annotation;
        }
        return pulsingView;
    }
    if ([annotation isKindOfClass:[ROREndAnnotation class]]) {
        static NSString *identifier = @"endLocation";
        MKPinAnnotationView* pulsingView = (MKPinAnnotationView *)
        [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (!pulsingView)
        {
            pulsingView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            
            pulsingView.image = [UIImage imageNamed:@"end_annotation.png"];
            pulsingView.frame = CGRectMake(pulsingView.frame.origin.x, pulsingView.frame.origin.y, 30, 30);
            pulsingView.canShowCallout = YES;
            return pulsingView;
        } else {
            pulsingView.annotation = annotation;
        }
        return pulsingView;
    }
    if ([annotation isKindOfClass:[RORFightAnnotation class]]) {
        static NSString *identifier = @"fightLocation";
        MKPinAnnotationView* pulsingView = (MKPinAnnotationView *)
        [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (!pulsingView)
        {
            pulsingView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            pulsingView.image = [UIImage imageNamed:@"fight_icon.png"];
            pulsingView.frame = CGRectMake(pulsingView.frame.origin.x, pulsingView.frame.origin.y, 25, 25);
            pulsingView.canShowCallout = YES;
            return pulsingView;
        } else {
            pulsingView.annotation = annotation;
        }
        return pulsingView;
    }
    if ([annotation isKindOfClass:[EventAnnotation class]]) {
        static NSString *identifier = @"eventLocation";
        MKPinAnnotationView* pulsingView = (MKPinAnnotationView *)
        [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (!pulsingView)
        {
            pulsingView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            pulsingView.image = [UIImage imageNamed:@"event_icon.png"];
            pulsingView.frame = CGRectMake(pulsingView.frame.origin.x, pulsingView.frame.origin.y, 25, 25);
            pulsingView.canShowCallout = YES;
            return pulsingView;
        } else {
            pulsingView.annotation = annotation;
        }
        return pulsingView;
    }
    if ([annotation isKindOfClass:[CoinAnnotation class]]) {
        static NSString *identifier = @"coinLocation";
        MKPinAnnotationView* pulsingView = (MKPinAnnotationView *)
        [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (!pulsingView)
        {
            pulsingView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            pulsingView.image = [UIImage imageNamed:@"coin.png"];
            pulsingView.frame = CGRectMake(pulsingView.frame.origin.x, pulsingView.frame.origin.y, 10, 10);
            pulsingView.canShowCallout = YES;
            return pulsingView;
        } else {
            pulsingView.annotation = annotation;
        }
        return pulsingView;
    }
    
    return nil;
}
@end
