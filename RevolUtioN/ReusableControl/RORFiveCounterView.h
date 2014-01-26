//
//  RORFiveCounterView.h
//  WalkFun
//
//  Created by Bjorn on 13-10-16.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RORConstant.h"

@interface RORFiveCounterView : UIView{
    UIImageView *imageView;
    UILabel *labelView;
}

- (id)initWithFrame:(CGRect)frame andNumber:(NSInteger)number;
-(void)setNewNumber:(NSInteger)number;

@end
