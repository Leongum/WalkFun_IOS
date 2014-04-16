//
//  MissionDoneCongratsViewController.h
//  WalkFun
//
//  Created by Bjorn on 14-4-3.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "PooViewController.h"
#import "RORViewController.h"

@interface MissionDoneCongratsViewController : PooViewController{
    UIView *titleView;
}

@property (strong, nonatomic) IBOutlet StrokeLabel *missionNameLabel;
@end
