//
//  INStepCounting.h
//  InertiaNavigation
//
//  Created by Bjorn on 13-8-12.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INConstant.h"
#define SC_WINDOW_SIZE 20

@interface INStepCounting : NSObject{
//    double gAccTrend, lAccTrend;
//    int p;
//    BOOL gHasPeak, lHasPeak;
    double gWindow[SC_WINDOW_SIZE], lWindow[SC_WINDOW_SIZE];
    int head, tail, lastGPeak, lPeak, totalPoints;
//    double gPeakSum, lPeakSum;
//    int duration;
}

@property (strong, nonatomic) NSMutableArray *levelAccList;
@property (strong, nonatomic) NSMutableArray *gAccList;
@property (nonatomic) NSInteger counter;
//@property (nonatomic) NSInteger dSum;
//@property (nonatomic) double maxZAcc;
@property (nonatomic) double rtStepFrequency;


-(void)pushNewLAcc:(double)lAcc GAcc:(double)gAcc speed:(double)v;
@end
