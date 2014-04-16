//
//  MissionStoneView.h
//  WalkFun
//
//  Created by Bjorn on 14-4-16.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MISSION_STONE_WIDTH 30
#define MISSION_STONE_OFFSET_TOP 10

@interface MissionStoneView : UIView{
    UIImageView *stoneImageView[3];
    UIImageView *lightUpImageView;
    
    int iterator;
}

-(void)showStones:(int)quantity andAnimated:(BOOL)isAnimated;
-(IBAction)stoneAnimation:(id)sender;

@end
