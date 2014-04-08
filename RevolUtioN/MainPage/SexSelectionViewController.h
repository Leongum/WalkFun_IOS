//
//  SexSelectionViewController.h
//  WalkFun
//
//  Created by Bjorn on 14-2-25.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "RORViewController.h"
#import "RORUserServices.h"

@interface SexSelectionViewController : RORViewController{
    NSString *userSex;
}

@property (strong, nonatomic) IBOutlet UIImageView *bgImage;
@end
