//
//  RORNormalButton.m
//  RevolUtioN
//
//  Created by Bjorn on 13-8-23.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORNormalButton.h"
#import "Animations.h"

@implementation RORNormalButton
@synthesize delegate;

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initButtonInteraction];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initButtonInteraction];
        // Initialization code
    }
    return self;
}

-(void)initButtonInteraction{
    [self addTarget:self action:@selector(pressOn:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(didPress:) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpOutside];
    self.adjustsImageWhenHighlighted = NO;
    self.showsTouchWhenHighlighted = NO;
    sound = [[RORPlaySound alloc]initForPlayingSoundEffectWith:@"button.mp3"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(IBAction)pressOn:(id)sender{
//    self.transform = CGAffineTransformMakeScale(1, 0.85);
    [Animations moveDown:self andAnimationDuration:0 andWait:NO andLength:2];
}

-(IBAction)didPress:(id)sender{
    [Animations moveUp:self andAnimationDuration:0 andWait:NO andLength:2];
    [sound play];
}

-(IBAction)touchUp:(id)sender{
//    self.transform = CGAffineTransformMakeScale(1, 1);
//    [sound play];
    [Animations moveUp:self andAnimationDuration:0 andWait:NO andLength:2];
}

-(IBAction)touchDrag:(id)sender{
    
}



@end
