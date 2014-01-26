//
//  RORSegmentButton.m
//  RevolUtioN
//
//  Created by Bjorn on 13-9-16.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORSegmentButton.h"

@implementation RORSegmentButton
@synthesize  seg_index, selected, selectedImage, selectedColor;

- (id)initWithFrame:(CGRect)frame Style:(NSInteger)style image:(UIImage*)image selectionColor:(UIColor *)color andIndex:(NSInteger)index
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.adjustsImageWhenHighlighted = NO;
        self.adjustsImageWhenDisabled = NO;
        selectedImage = image;
        selectedColor = color;
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        seg_index = index;
        selected = NO;
        seg_style = style;
        [self setBackgroundColor:[UIColor clearColor]];
        [self setBackgroundImage:[self imageForStyle:style andSelection:NO] forState:UIControlStateNormal];
        [self setTitleColor:[self titleColorForStyle:style andSelection:NO] forState:UIControlStateNormal];
//        [self.titleLabel setFont:[UIFont fontWithName:CHN_PRINT_FONT size:13]];
        [self.titleLabel setFont:[UIFont systemFontOfSize:13]];
        
        [self addTarget:self action:@selector(pressOn:) forControlEvents:UIControlEventTouchDown];
//        sound = [[RORPlaySound alloc]initForPlayingSoundEffectWith:@"segment.mp3"];
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

-(UIImage *)imageForStyle:(NSInteger)style andSelection:(BOOL)isSelected
{
    if (isSelected) {
        return selectedImage;
    }
    return nil;
}

-(UIColor *)titleColorForStyle:(NSInteger)style andSelection:(BOOL)isSelected{
    if (isSelected) {
        return selectedColor;
    }
    return [UIColor darkGrayColor];
}

-(IBAction)refreshAppearence:(id)sender{
//    selected = !selected;
    [self setBackgroundImage:[self imageForStyle:seg_style andSelection:selected] forState:UIControlStateNormal];
    [self setTitleColor:[self titleColorForStyle:seg_style andSelection:selected] forState:UIControlStateNormal];
}

-(IBAction)pressOn:(id)sender{
//    [sound play];
}
@end
