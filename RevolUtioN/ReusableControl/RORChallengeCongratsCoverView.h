//
//  RORChallengeCongratsCoverView.h
//  WalkFun
//
//  Created by Bjorn on 13-11-25.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORCongratsCoverView.h"
#import "RORShareService.h"

@interface RORChallengeCongratsCoverView : RORCongratsCoverView{
    NSInteger grade;
    UIImageView *levelBgImageView;
    UIImageView *levelImageView;
    UILabel *levelLabel;
}

@property (nonatomic) User_Running_History *bestRecord;

- (id)initWithFrame:(CGRect)frame andLevel:(User_Running_History*)record;
-(void)fillContent;

@end
