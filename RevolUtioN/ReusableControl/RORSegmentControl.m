//
//  RORSegmentControl.m
//  RevolUtioN
//
//  Created by Bjorn on 13-9-16.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORSegmentControl.h"

#define SEGMENT_BUTTON_WIDTH 75
#define SEGMENT_BUTTON_HEIGHT 30

@implementation RORSegmentControl
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

- (id)initWithSegmentNumber:(NSInteger)num{
    self = [self initWithFrame:CGRectMake(0, 0, SEGMENT_BUTTON_WIDTH * num, SEGMENT_BUTTON_HEIGHT) andSegmentNumber:num];
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
        
        RORSegmentButton *btn = [[RORSegmentButton alloc]initWithFrame:CGRectMake(i*frame.size.width/count, 0, frame.size.width/count, frame.size.height) Style:style image:nil selectionColor:[UIColor whiteColor] andIndex:i];
        btn.selected = (i == selectionIndex);
        [btn refreshAppearence:btn];
        [btn addTarget:self action:@selector(touchInside:) forControlEvents:UIControlEventTouchUpInside];
        [segment addObject:btn];
        [self addSubview:btn];
    }
    return self;
}

-(void)selectSegmentAtIndex:(NSInteger)index
{
    selectionIndex = index;
    [self touchInside:[self.subviews objectAtIndex:index]];
}

-(IBAction)touchInside:(id)sender
{
    RORSegmentButton *seg_btn = (RORSegmentButton *)sender;
    for (RORSegmentButton *seg in self.subviews)
    {
        if (seg.seg_index!= seg_btn.seg_index)
            seg.selected = NO;
        else {
            seg.selected = YES;
            selectionIndex = [self.subviews indexOfObject:seg];
        }
        [seg refreshAppearence:seg];
    }
    [self sendNotification];
}

-(void)sendNotification{
    if ([delegate respondsToSelector:@selector(SegmentValueChanged:)]){
        [delegate SegmentValueChanged:selectionIndex];
    }
}

-(void)setSegmentTitle:(NSString*)text withIndex:(NSInteger)index
{
    if (index>=count)
        return;
    RORSegmentButton *seg_btn = (RORSegmentButton *)[self.subviews objectAtIndex:index];
    [seg_btn setTitle:text forState:UIControlStateNormal];
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
