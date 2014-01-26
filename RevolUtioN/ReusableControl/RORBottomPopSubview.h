//
//  RORBottomPopSubview.h
//  RevolUtioN
//
//  Created by Bjorn on 13-8-21.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>

#define POPVIEW_LABEL_TAG 1
#define POPVIEW_BOARD_TAG 2
#define POPVIEW_BUTTON_TAG 3
#define POPVIEW_BG_TAG 4

@interface RORBottomPopSubview : UIControl

-(IBAction)popView:(id)sender;
-(IBAction)hideView:(id)sender;

@end
