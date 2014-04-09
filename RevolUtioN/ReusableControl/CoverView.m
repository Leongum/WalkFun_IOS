//
//  CoverView.m
//  WalkFun
//
//  Created by Bjorn on 14-2-15.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "CoverView.h"
#import "FTAnimation.h"
#import "Animations.h"

@implementation CoverView
@synthesize bgImage, delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
//        [self addTarget:self action:@selector(bgTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

//-(void)setBgImage:(UIImage *)image{
//    bgImage = image;
//    [self addCoverBgImage];
//}

-(void)addCoverBgImage{
    UIImage *image = [RORUtils captureScreen];
    bgImage = [UIUtils grayscale:image type:1];
    if (!bgImageView){
        bgImageView = [[UIImageView alloc]initWithImage:bgImage];
        bgImageView.frame = self.frame;
        bgImageView.center = CGPointMake(bgImageView.frame.size.width/2, bgImageView.frame.size.height/2);
        bgImageView.alpha = 1;
        [self addSubview:bgImageView];
        [self sendSubviewToBack:bgImageView];
    } else {
        bgImageView.image = bgImage;
    }
}

-(void)addCoverBgImage:(UIImage *)bg{
    if (!bgImageView){
        bgImageView = [[UIImageView alloc]initWithImage:bg];
        bgImageView.frame = self.frame;
        bgImageView.center = CGPointMake(bgImageView.frame.size.width/2, bgImageView.frame.size.height/2);
        bgImageView.alpha = 1;
        [self addSubview:bgImageView];
        [self sendSubviewToBack:bgImageView];
    } else {
        bgImageView.image = bg;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(IBAction)appear:(id)sender{
    self.alpha = 1;
    [Animations fadeIn:self andAnimationDuration:0.2 toAlpha:1 andWait:NO];
    [bgImageView fadeIn:0.3 delegate:self startSelector:nil stopSelector:@selector(addBgAction:)];
}

-(IBAction)addBgAction:(id)sender{
    [self addTarget:self action:@selector(bgTap:) forControlEvents:UIControlEventTouchUpInside];
}

-(IBAction)bgTap:(id)sender{
    [self fadeOut:0.2 delegate:self startSelector:nil stopSelector:@selector(afterDismissed:)];
}

-(IBAction)afterDismissed:(id)sender{
    [delegate coverViewDidDismissed:self];
    [self removeFromSuperview];
}


@end
