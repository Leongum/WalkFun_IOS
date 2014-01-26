//
//  RORSegmentButton.h
//  RevolUtioN
//
//  Created by Bjorn on 13-9-16.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RORConstant.h"
#import "RORPlaySound.h"

#define SEGMENT_STYLE_LEFT 0
#define SEGMENT_STYLE_RIGHT 1
#define SEGMENT_STYLE_MIDDLE 2

@interface RORSegmentButton : UIButton{
//    NSInteger seg_index;
    NSInteger seg_style;
//    UILabel *titleLabel;
    RORPlaySound *sound;
}

@property (nonatomic) NSInteger seg_index;
@property (nonatomic)    BOOL selected;
@property (strong, nonatomic) UIImage *selectedImage;
@property (strong, nonatomic) UIColor *selectedColor;

-(IBAction)refreshAppearence:(id)sender;
- (id)initWithFrame:(CGRect)frame Style:(NSInteger)style image:(UIImage*)image selectionColor:(UIColor *)color andIndex:(NSInteger)index;

@end
