//
//  RORCustomShareViewController.h
//  RevolUtioN
//
//  Created by leon on 13-8-19.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AGCommon/CMImageView.h>
#import <ShareSDK/ShareSDK.h>
#import "RORCustomShareViewToolbar.h"
#import "RORViewController.h"
#import "User_Running_History.h"

@interface RORCustomShareViewController : RORViewController<UITextViewDelegate>{
    BOOL isTyping;
}
@property (weak, nonatomic) IBOutlet UITextView *txtShareContent;
@property (weak, nonatomic) IBOutlet UILabel *lblContentCount;
@property (weak, nonatomic) IBOutlet RORCustomShareViewToolbar *shareBar;
@property (retain, nonatomic) UIImage *shareImage;
@property (strong, nonatomic) NSString *shareMessage;


- (IBAction)shareContentAction:(id)sender;

@end
