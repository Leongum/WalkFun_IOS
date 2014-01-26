//
//  RORNormalButton.h
//  RevolUtioN
//
//  Created by Bjorn on 13-8-23.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RORPlaySound.h"

@interface RORNormalButton : UIButton{
    CGRect originFrame;
    UIImage *normal_bg;
    RORPlaySound *sound;
}

@property (strong, nonatomic) id delegate;

-(void)initButtonInteraction;
-(IBAction)pressOn:(id)sender;

@end
