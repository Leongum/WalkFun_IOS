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

    [contentLabel moveUp:2 length:-100 delegate:self startSelector:@selector(contentFadeOutAnimation:) stopSelector:@selector(afterDismissed:)];
}

-(IBAction)contentFadeOutAnimation:(id)sender{
    [contentLabel fadeOut:1 delegate:self startSelector:nil stopSelector:@selector(startNextAnimation:)];
}

-(IBAction)startNextAnimation:(id)sender{
}

-(IBAction)afterDismissed:(id)sender{
    [self removeFromSuperview];
}
@end
