//
//  INTimeWindow.m
//  InertiaNavigation
//
//  Created by Bjorn on 13-7-23.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "INTimeWindow.h"

@implementation INTimeWindow
@synthesize content, count, head, timeCounter;

-(id)init{
    //content = [[NSMutableArray alloc]init];
    count = 0;
    head = 0;
    sum_a = 0;
    timeCounter = 0;
    for (int i=0; i<SIZE_OF_TIMEWINDOW; i++)
        dList[i] = nil;
    return self;
}

-(BOOL)pushStatus:(INDeviceStatus *)status{
    if (dList[head]!= nil)
        sum_a -= dList[head].ab_mod;
    dList[head] = status;
    sum_a += status.ab_mod;
    head = (head+1)%SIZE_OF_TIMEWINDOW;
    if (count<SIZE_OF_TIMEWINDOW)
        count++;
//    [content addObject:status];
    return count >= SIZE_OF_TIMEWINDOW;
}

-(INDeviceStatus *)pullAvailableStatus{
    
    double avg_a = sum_a/SIZE_OF_TIMEWINDOW;
    double a_variance = 0.0;
    for (int i=0; i<SIZE_OF_TIMEWINDOW; i++){
        double delta_a = dList[i].ab_mod - avg_a;
        a_variance += delta_a * delta_a;
    }
    //a_variance /= SIZE_OF_TIMEWINDOW;
    INDeviceStatus *returnStatus = dList[(head+(SIZE_OF_TIMEWINDOW/2))%SIZE_OF_TIMEWINDOW];
//    if (timeCounter % 10 == 0)
//        [returnStatus setIsStill:YES];
//    else
    [returnStatus checkIsStill];//:a_variance];
    INDeviceStatus *formerStatus = dList[(head+(SIZE_OF_TIMEWINDOW/2-1))%SIZE_OF_TIMEWINDOW];
    [returnStatus updateWithVn:formerStatus.Vn];

    
    return returnStatus;
}

@end
