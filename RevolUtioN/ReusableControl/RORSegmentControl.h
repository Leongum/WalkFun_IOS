//
//  RORSegmentControl.h
//  RevolUtioN
//
//  Created by Bjorn on 13-9-16.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RORSegmentButton.h"
#import "RORUtils.h"

@protocol CustomSegmentedControlDelegate
@optional
- (void) SegmentValueChanged:(NSUInteger)segmentIndex;
@end

@interface RORSegmentControl : UIControl{
    int count;
}

//@property (nonatomic) NSInteger count;
@property (strong, nonatomic) id delegate;

@property (strong, nonatomic) NSMutableArray *segment;
@property (nonatomic) NSInteger selectionIndex;

- (id)initWithSegmentNumber:(NSInteger)num;
- (id)initWithFrame:(CGRect)frame andSegmentNumber:(NSInteger)num;
-(void)setSegmentTitle:(NSString*)text withIndex:(NSInteger)index;
-(void)selectSegmentAtIndex:(NSInteger)index;
@end
