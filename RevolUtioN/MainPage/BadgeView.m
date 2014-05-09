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
        [self setFriendFightWin:friendFightWin];
    }
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
    [self setBackgroundColor: [UIColor clearColor]];
    
    //徽章图片
    badgeImageView = [[UIImageView alloc]initWithFrame:self.bounds];
    [self addSubview:badgeImageView];
    
    //荣誉点数
    badgeLabel = [[StrokeLabel alloc]initWithFrame:self.bounds];
    [badgeLabel setFont:[UIFont systemFontOfSize:7.f / 16.f * CGRectGetWidth(self.bounds)]];
    badgeLabel.lineWidth = 3.f / 32.f * CGRectGetWidth(self.bounds);
    [badgeLabel setTextColor:[UIColor whiteColor]];
    [badgeLabel setBackgroundColor:[UIColor clearColor]];
    [badgeLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:badgeLabel];
    
    [RORUtils setFontFamily:APP_FONT forView:self andSubViews:YES];
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
