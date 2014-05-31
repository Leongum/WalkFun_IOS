//
//  NoteAnimationCoverView.m
//  WalkFun
//
//  Created by Bjorn on 14-5-27.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "NoteAnimationCoverView.h"
#import "FTAnimation.h"

@implementation NoteAnimationCoverView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame andNoteText:(NSString *)t{
    self = [super initWithFrame:frame];
    if (self) {
        CGPoint thisCenter = self.center;
        self.frame = CGRectMake(0, 0, self.frame.size.width, 200);
        self.center = thisCenter;
        
        contentLabel = [[MissionCongratsLabel alloc]initWithFrame:self.bounds];
        [contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [contentLabel setFont:[UIFont systemFontOfSize:24]];
        [contentLabel setTextAlignment:NSTextAlignmentCenter];
        contentLabel.numberOfLines = 0;
        contentLabel.text = t;
        
        [self addSubview:contentLabel];
        [RORUtils setFontFamily:APP_FONT forView:self andSubViews:YES];
        
        contentLabel.alpha = 0;
        self.alpha = 0;
        
        if (t.length > 6)
            delta = ((double)t.length)/6.f;
        else
            delta = 1;
    }
    return self;
}

-(IBAction)appear:(id)sender{
    self.alpha = 1;
    contentLabel.alpha = 1;
    [contentLabel fallIn:0.5 delegate:self startSelector:nil stopSelector:@selector(flyUpAnimation:)];
}

-(IBAction)flyUpAnimation:(id)sender{
    [delegate coverViewDidDismissed:self];
    [contentLabel moveUp:1.5*delta length:-100 delegate:self startSelector:@selector(contentFadeOutAnimation:) stopSelector:@selector(afterDismissed:)];
}

-(IBAction)contentFadeOutAnimation:(id)sender{
    [contentLabel fadeOut:1*delta delegate:self startSelector:nil stopSelector:nil];
}

-(IBAction)afterDismissed:(id)sender{
    [self removeFromSuperview];
}
@end
