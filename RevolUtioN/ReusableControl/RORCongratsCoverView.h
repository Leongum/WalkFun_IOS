//
//  RORCongratsCoverView.h
//  RevolUtioN
//
//  Created by Bjorn on 13-9-26.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RORRunHistoryServices.h"

@interface RORCongratsCoverView : UIControl{
    UILabel *titleLabel;
UIImageView *bgView;
    
UILabel *extraAwardLabel;
UILabel *awardTitleLabel;
}


-(IBAction)show:(id)sender;
-(IBAction)hide:(id)sender;
@end
