//
//  RORAccountViewController.h
//  RevolUtioN
//
//  Created by Beyond on 13-6-26.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RORViewController.h"

@interface RORAccountViewController : RORViewController{

    NSMutableArray *shareTypeArray;
}

@property (strong, nonatomic) IBOutlet RORNormalButton *logoutButton;
@property (weak, nonatomic) IBOutlet UITableView *tblAutoView;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;

- (IBAction)backAction:(id)sender;
- (IBAction)logoutAction:(id)sender ;

@end
