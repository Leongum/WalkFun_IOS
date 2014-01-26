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
@synthesize mapView, routeLine, routeLineView ,routes;

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
    
    [self center_map];
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
        }
    }
    region.center.latitude = (maxLat + minLat)/2;
    region.center.longitude = (maxLon + minLon)/2;
    region.span.latitudeDelta = maxLat - minLat + 0.001;
    region.span.longitudeDelta = maxLon - minLon + 0.001;
    
    [mapView setRegion:region animated:YES];
}

- (void)drawLineWithLocationArray:(NSArray *)locationArray withStyle:(NSInteger)style
{
    
    int pointCount = [locationArray count];
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
    
    //    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"PIN_ANNOTATION"];
    //    if(annotationView == nil) {
    //        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
    //                                                          reuseIdentifier:@"PIN_ANNOTATION"];
    //    }
    //    annotationView.canShowCallout = YES;
    //    annotationView.pinColor = MKPinAnnotationColorRed;
    //    annotationView.animatesDrop = YES;
    //    annotationView.highlighted = YES;
    //    annotationView.draggable = YES;
    //    return annotationView;
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    // 处理我们自定义的Annotation
    if ([annotation isKindOfClass:[RORMapAnnotation class]]) {
        //        RORMapAnnotation *travellerAnnotation = (RORMapAnnotation *)annotation;
        //        static NSString* travellerAnnotationIdentifier = @"TravellerAnnotationIdentifier";
        static NSString *identifier = @"currentLocation";
        //        SVPulsingAnnotationView *pulsingView = (SVPulsingAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        MKPinAnnotationView* pulsingView = (MKPinAnnotationView *)
        [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (!pulsingView)
        {
            // if an existing pin view was not available, create one
            pulsingView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            //            MKAnnotationView* customPinView = [[MKAnnotationView alloc]
            //                                                initWithAnnotation:annotation reuseIdentifier:identifier];
            //加展开按钮
            //            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            //            [rightButton addTarget:self
            //                            action:@selector(showDetails:)
            //                  forControlEvents:UIControlEventTouchUpInside];
            //            pulsingView.rightCalloutAccessoryView = rightButton;
            //
            UIImage *image;
            if ([annotation isKindOfClass:[RORStartAnnotation class]])
                image = [UIImage imageNamed:@"start_annotation.png"];
            else
                image = [UIImage imageNamed:@"end_annotation.png"];
            
            pulsingView.image = image;
            pulsingView.canShowCallout = YES;
            //
            //            UIImageView *headImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:travellerAnnotation.headImage]];
            //            pulsingView.leftCalloutAccessoryView = headImage; //设置最左边的头像
            return pulsingView;
        }
        else
        {
            pulsingView.annotation = annotation;
        }
        return pulsingView;
    }
    
    return nil;
}
@end
