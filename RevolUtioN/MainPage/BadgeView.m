//
//  BadgeView.m
//  WalkFun
//
//  Created by Bjorn on 14-4-21.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "BadgeView.h"

@implementation BadgeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customInit];
    }
    [RORUtils setFontFamily:APP_FONT forView:self andSubViews:YES];
    return self;
}

- (id)initWithFrame:(CGRect)frame andFightWin:(NSNumber *)friendFightWin
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customInit];
    }
    [RORUtils setFontFamily:APP_FONT forView:self andSubViews:YES];
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self customInit];
    }
    return self;
}

-(void)customInit{
    //徽章图片
    badgeImageView = [[UIImageView alloc]initWithFrame:self.bounds];
    [self addSubview:badgeImageView];
    
    //荣誉点数
    badgeLabel = [[StrokeLabel alloc]initWithFrame:self.bounds];
    [badgeLabel setFont:[UIFont systemFontOfSize:14]];
    [badgeLabel setTextColor:[UIColor whiteColor]];
}

-(void)setFriendFightWin:(NSNumber *)friendFightWin{
    badgeImageView.image = [RORUserUtils getImageForUserBadge:friendFightWin];
    badgeLabel.text = [NSString stringWithFormat:@"%d", friendFightWin.intValue%20];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
