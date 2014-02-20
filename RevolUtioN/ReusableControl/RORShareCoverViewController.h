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

- (IBAction)btnShareToWeibo:(id)sender;

- (IBAction)btnShareToRenren:(id)sender;

- (IBAction)btnShareToTencentWeibo:(id)sender;

- (IBAction)btnShareToWeixin:(id)sender;

- (IBAction)btnShareToQQ:(id)sender;
@end
