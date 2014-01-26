//
//  RORMapPoint.m
//  RevolUtioN
//
//  Created by Beyond on 13-6-17.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORMapPoint.h"

@implementation RORMapPoint
@synthesize x, y;

- (id) initWithString:(NSString *)currentPointString{
    self = [super init];
    if (self) {
        // Custom initialization
        NSArray* latLonArr = [currentPointString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
        if (latLonArr.count == 1){
            x = [[latLonArr objectAtIndex:0] doubleValue];
            y = [[latLonArr objectAtIndex:1] doubleValue];
        } else {
            NSLog(@"Parse error (from String to RORPoint).");
        }
    }
    return self;
}

- (id) initWithCoordinate:(CLLocationCoordinate2D )loc{
    self = [super init];
    if (self) {
        x = loc.latitude;
        y = loc.longitude;
    }
    return self;
}

- (NSString *) toString{
    return [NSString stringWithFormat:@"%lf,%lf", x, y];
}

@end
