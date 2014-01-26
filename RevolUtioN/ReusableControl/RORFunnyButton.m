//
//  RORFunnyButton.m
//  RevolUtioN
//
//  Created by Bjorn on 13-8-26.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORFunnyButton.h"
#import "FTAnimation.h"

@implementation RORFunnyButton

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
    if (self){
        UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        [self addGestureRecognizer:panGes];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void) panAction:(UIPanGestureRecognizer*) recognizer{
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        originFrame = self.frame;
        normal_bg = self.currentBackgroundImage;
    }
    
    CGPoint translation = [recognizer translationInView:self];
    
//    UIImage *scared = [UIImage imageNamed:@"btn_scared.png"];
//    if (fabs(translation.x) >75 || fabs(translation.y) > 150){
//        [self setBackgroundImage:scared forState:UIControlStateNormal];
//    } else {
//        [self setBackgroundImage:normal_bg forState:UIControlStateNormal];
//    }
    double deltaX = 0, deltaY = 0;
    if (translation.x < 0)
        deltaX = translation.x/2;
    if (translation.y < 0)
        deltaY = translation.y/2;
    self.frame = CGRectMake(originFrame.origin.x + deltaX, originFrame.origin.y + deltaY, fabs(translation.x/2)+originFrame.size.width, fabs(translation.y/2)+originFrame.size.height);
    
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGContextRef gccontext = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:gccontext];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration:0.15];
        
        self.frame = originFrame;
        [self setBackgroundImage:normal_bg forState:UIControlStateNormal];
        self.transform = CGAffineTransformMakeScale(1.f, 1.f);
        
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationFinished)];
        [UIView commitAnimations];
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.15]];

        [self elastic:0.2 delegate:self];
    }
    


    //    [recognizer setTranslation:CGPointZero inView:self];
}

@end
