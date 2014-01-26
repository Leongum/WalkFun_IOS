//
//  RORChallengeViewController.h
//  RevolUtioN
//
//  Created by Bjorn on 13-8-21.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORViewController.h"
#import "RORBottomPopSubview.h"
#import "Mission.h"
#import "RORChallengeLevelView.h"

@interface RORChallengeViewController : RORViewController{
    Mission *selectedChallenge;
    RORChallengeLevelView *levelTable;
}

@property (strong, nonatomic) IBOutlet UIControl *coverView;
@property (strong, nonatomic) IBOutlet UIView *contentFrameView;
@property (strong, nonatomic) NSArray *contentList;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIControl *levelRequirementTable;
@end
