//
//  CoverView.h
//  WalkFun
//
//  Created by Bjorn on 14-2-15.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoverView : UIControl{
    UIImageView *bgImageView;
}

-(IBAction)appear:(id)sender;
-(IBAction)bgTap:(id)sender;
@end
