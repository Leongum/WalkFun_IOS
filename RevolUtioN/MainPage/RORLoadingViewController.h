//
//  RORLoadingViewController.h
//  RevolUtioN
//
//  Created by leon on 13-8-6.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RORViewController.h"
@interface RORLoadingViewController : RORViewController{
    NSTimer *repeatingTimer;
    int timerCount;
}

@property (strong, nonatomic) IBOutlet CUSFlashLabel *loadingLabel;

@end
