//
//  BadgeView.h
//  WalkFun
//
//  Created by Bjorn on 14-4-21.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RORViewController.h"

@interface BadgeView : UIControl{
    UIImageView *badgeImageView;
    StrokeLabel *badgeLabel;
}

@property (strong, nonatomic) NSNumber *friendFightWin;

-(void)setFriendFightWin:(NSNumber *)friendFightWin;

@end
