//
//  CoverView.h
//  WalkFun
//
//  Created by Bjorn on 14-2-15.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIUtils.h"

@protocol WFCoverViewDelegate
@optional
- (void) coverViewDidDismissed:(id)view;
@end

@interface CoverView : UIControl{
    UIImageView *bgImageView;
}

@property (strong, nonatomic) id delegate;
@property (strong, nonatomic)     UIImage *bgImage;

-(IBAction)appear:(id)sender;
-(IBAction)bgTap:(id)sender;
//-(void)addCoverBgImage;
-(void)addCoverBgImage:(UIImage *)bg grayed:(BOOL)grayed;

@end
