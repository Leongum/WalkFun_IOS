//
//  RORTrainingHistoryShareView.m
//  Cyberace
//
//  Created by Bjorn on 13-12-21.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "HistoryShareView.h"

@implementation HistoryShareView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

-(void)add:(UIView *)view2add{
    view2add.center = CGPointMake(view2add.frame.size.width/2, self.frame.size.height + view2add.frame.size.height/2);
    [self addSubview:view2add];
//    [contentViewList addObject:view2add];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y
                            , view2add.frame.size.width, self.frame.size.height+view2add.frame.size.height);
}

-(UIImage *)getImage{
    self.backgroundColor = [UIColor clearColor];
    int pieceHeight = 245;
    int pieceWidth = 320;
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height+115);
    
    for (int i=0; i<self.bounds.size.height/pieceHeight + 1; i++) {
        UIImageView *paperPieceImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"history_share_mid.png"]];
        paperPieceImageView.frame = CGRectMake(0, i*pieceHeight, pieceWidth, pieceHeight);
        [self addSubview:paperPieceImageView];
        [self sendSubviewToBack:paperPieceImageView];
    }
//    UIImageView *bottomBgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"history_share_bottom.png"]];
//    bottomBgImageView.frame = CGRectMake(0, 0, 320, 115);
//    [self add:bottomBgImageView];
    
    for (UIView *v in [self subviews]){
        v.center = CGPointMake(v.center.x, v.center.y+115);
    }
    UIImageView *topBgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"history_share_top.png"]];
    topBgImageView.frame = CGRectMake(0, 0, 320, 115);
    [self addSubview:topBgImageView];
    
    return [RORUtils getImageFromView:self];
}

@end
