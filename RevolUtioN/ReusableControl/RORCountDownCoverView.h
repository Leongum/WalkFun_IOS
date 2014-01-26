//
//  RORCountDownCoverView.h
//  RevolUtioN
//
//  Created by Bjorn on 13-9-19.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>

#define COUNTDOWN_IMAGE_FRAME CGRectMake(0,0,320,460)

@interface RORCountDownCoverView : UIControl{
//    UIControl *bgView;
    UIImageView *bgView;
    UIImageView *contentImageView;
}

@property (nonatomic) NSInteger count;

-(void)doAnimation;
-(void)show;
-(void)hide;

@end
