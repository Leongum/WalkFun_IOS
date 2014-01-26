//
//  RORPaperSegmentControl.m
//  WalkFun
//
//  Created by Bjorn on 13-12-28.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORPaperSegmentControl.h"

@implementation RORPaperSegmentControl
@synthesize segment, selectionIndex;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andSegmentNumber:(NSInteger)num{
    self = [super initWithFrame:frame];//[RORSegmentButton buttonWithType:UIButtonTypeRoundedRect];
    //    self.frame = frame;
    [self addTarget:self action:@selector(touchInside:) forControlEvents:UIControlEventTouchDown];
    selectionIndex = 0;
    count = num;
    for (int i=0; i<num; i++)
    {
        NSInteger style = SEGMENT_STYLE_MIDDLE;
        if (i == 0)
            style = SEGMENT_STYLE_LEFT;
        else if (i == num-1)
            style = SEGMENT_STYLE_RIGHT;
        
        RORSegmentButton *btn = [[RORSegmentButton alloc]initWithFrame:CGRectMake(i*frame.size.width/count, 0, frame.size.width/count, frame.size.height) Style:style image:[UIImage imageNamed:@"seg_selected_bg.png"] selectionColor:[UIColor darkGrayColor] andIndex:i];
        btn.selected = (i == selectionIndex);
        [btn refreshAppearence:btn];
        [btn addTarget:self action:@selector(touchInside:) forControlEvents:UIControlEventTouchUpInside];
        [segment addObject:btn];
        [self addSubview:btn];
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

@end
