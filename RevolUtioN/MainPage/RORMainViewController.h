//
//  RORMainViewController.h
//  WalkFun
//
//  Created by Bjorn on 14-2-14.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "RORViewController.h"
#import "MainPageViewController.h"
#import "RORUserPropsService.h"
#import "RORMissionHistoyService.h"
#import "RORRunHistoryServices.h"
#import "LevelUpCongratsViewController.h"
#import "RORMissionServices.h"
#import "CoverView.h"
#import "PooViewController.h"
#import "ReadyToGoViewController.h"


#define PAGE_QUANTITY 3

#define ALERT_TYPE_TOAPPSTORE 1
#define ALERT_TYPE_GIVEUPMISSION 2

@interface RORMainViewController : RORViewController<UIScrollViewDelegate>{
    MainPageViewController *friendViewController, *firstViewController, *itemViewController;
    UIStoryboard *mainStoryboard;
    User_Base *userBase;
    BOOL isLevelUp;
    
    double missionBoardCenterY;
    Mission *todayMission;
    BOOL isFolded;
    
    int alertType;
}
@property (strong)			CAEmitterLayer	*heartsEmitter;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UILabel *missionContentLabel;
@property (strong, nonatomic) IBOutlet UIView *missionView;

@property (strong, nonatomic) NSMutableArray *contentViews;

@end
