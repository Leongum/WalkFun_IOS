//
//  RORMapPoint.h
//  RevolUtioN
//
//  Created by Beyond on 13-6-17.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface RORMapPoint : NSObject
@property (nonatomic) double x;
@property (nonatomic) double y;

-(id) initWithString : (NSString *) str;
-(id) initWithCoordinate :(CLLocationCoordinate2D ) loc;
-(NSString *) toString ;

@end
