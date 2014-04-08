//
//  ReportViewController.h
//  WalkFun
//
//  Created by Bjorn on 14-4-4.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "RORViewController.h"
#import "CoverView.h"
#import "StrokeLabel.h"

@interface ReportViewController : RORViewController{
    NSString *winText;
    NSString *expText;
    NSString *coinText;
    NSString *itemText;
}

@property (strong, nonatomic) IBOutlet StrokeLabel *winLabel;
@property (strong, nonatomic) IBOutlet StrokeLabel *expLabel;
@property (strong, nonatomic) IBOutlet StrokeLabel *coinLabel;
@property (strong, nonatomic) IBOutlet StrokeLabel *itemLabel;

-(void)customInit:(NSString *)win Exp:(NSString *)exp Coin:(NSString *)coin andItem:(NSString *)item;
@end
