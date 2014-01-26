//
//  RORShareCoverViewController.h
//  WalkFun
//
//  Created by Bjorn on 13-12-24.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RORViewController.h"

@interface RORShareCoverViewController : UIViewController{
    id parent;
    BOOL weixinSharing;
}

@property (retain, nonatomic) UIImage *shareImage;
@property (strong, nonatomic) NSString *shareMessage;
@property (strong, nonatomic) IBOutlet UIImageView *shareImageView;
@property (strong, nonatomic) IBOutlet UILabel *shareTitleView;
@property (strong , nonatomic ) NSString *shareTitle;

+(void)present2SharePagefrom:(UIViewController*)delegate withImage:(UIImage *)image andMessage:(NSString *)msg;

@end
