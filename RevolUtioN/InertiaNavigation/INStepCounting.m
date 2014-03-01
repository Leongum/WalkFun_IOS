//
//  INStepCounting.m
//  InertiaNavigation
//
//  Created by Bjorn on 13-8-12.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "INStepCounting.h"
#define MAX_SLOWRUN_SPEED 16/3.6
#define MAX_WALK_SPEED 6/3.6


@implementation INStepCounting
@synthesize gAccList, levelAccList, counter, rtStepFrequency;

-(id)init{
    self = [super init];
    counter = 0;
//    gAccTrend = 0;
//    lAccTrend = 0;
//    p=0;
    gAccList = [[NSMutableArray alloc]init];
    levelAccList = [[NSMutableArray alloc]init];

    totalPoints = 0;
    head = 0;
    tail = 0;
//    duration = 0;
//    dSum = 0;
    
    return self;
}

-(void)pushNewLAcc:(double)lAcc GAcc:(double)gAcc speed:(double)v{
    
     //push new point into window
    gWindow[tail] = gAcc;
    lWindow[tail] = lAcc;
    tail = [self pointerMoveRight:tail];
    if (head == tail)
        head = [self pointerMoveRight:tail];
    totalPoints++;
    //dequeue one step if exist
    if (totalPoints>4)
        [self checkStep:v];
}

-(void)checkStep:(double)v{
    double maxFrequency = MIN_STEP_TIME / delta_T;
    //double slowrunFrequency = 0.3 / delta_T;
    
    if (totalPoints - lastGPeak < maxFrequency)
            return;
    
    [self updateGAccPeak:v];
}

-(void)oneStepFound{
    counter++;
    NSLog(@"Steps: %d", counter);
    
//    head = tail-1;
    
}

-(void)updateGAccPeak:(double)v{
    double now = gWindow[[self pointerMoveLeft:tail for:3]];
    double pre = gWindow[[self pointerMoveLeft:tail for:4]];
    double before = gWindow[[self pointerMoveLeft:tail for:5]];
    double next = gWindow[[self pointerMoveLeft:tail for:2]];
    double far = gWindow[[self pointerMoveLeft:tail for:1]];
    
    if (now<pre && now<before && now<next && now<far){
        if (pre<before || next<far){

            double stepTime = (totalPoints -1 - lastGPeak) * delta_T;
            rtStepFrequency = 60/stepTime;
            double minGAcc = THRESHOLD_GACC;
//            if (v<=6/3.6 ){//|| rtStepFrequency <= 100){
//                minGAcc = THRESHOLD_GACC;
//            }
//            else if ((v>MAX_WALK_SPEED && v <= MAX_SLOWRUN_SPEED) ){// || (rtStepFrequency >100 && rtStepFrequency <= 200)){
//                minGAcc = -2;
//            }
//            else if (v>16/3.6){// || rtStepFrequency > 200){
//                minGAcc = -5;
//            }
            
            if (now < minGAcc && stepTime >= 0.27 && now > -17){
                NSLog(@"%f", now);
                [self oneStepFound];
            }
            lastGPeak = totalPoints -1;
        }
    }
    
}

-(void)updateLAccPeak{
}

-(int)pointerMoveLeft:(int)pointer for:(int)num{
    return (pointer - (num%SC_WINDOW_SIZE) + SC_WINDOW_SIZE) % SC_WINDOW_SIZE;
}

-(int)pointerMoveLeft:(int)pointer{
    return [self pointerMoveLeft:pointer for:1];
}

-(int)pointerMoveRight:(int)pointer for:(int)num{
    return (pointer + num) % SC_WINDOW_SIZE;
}

-(int)pointerMoveRight:(int)pointer{
    return [self pointerMoveRight:pointer for:1];
}



@end

