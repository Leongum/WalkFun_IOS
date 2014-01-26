//
//  INTimeWindow.h
//  InertiaNavigation
//
//  Created by Bjorn on 13-7-23.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INDeviceStatus.h"
#define SIZE_OF_TIMEWINDOW 7

@interface INTimeWindow : NSObject{
    INDeviceStatus *dList[SIZE_OF_TIMEWINDOW];
    double sum_a;
}

@property (nonatomic, strong) NSMutableArray *content;
@property (nonatomic) NSInteger count;
@property (nonatomic) NSInteger head;
@property (nonatomic) NSInteger timeCounter;

-(BOOL)pushStatus:(INDeviceStatus *)status;
-(INDeviceStatus *)pullAvailableStatus;
-(id)init;
@end
