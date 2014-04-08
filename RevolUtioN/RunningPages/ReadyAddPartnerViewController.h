//
//  ReadyAddPartnerViewController.h
//  WalkFun
//
//  Created by Bjorn on 14-3-25.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "RORViewController.h"

@interface ReadyAddPartnerViewController : RORViewController{
    NSArray *contentList;
    NSMutableDictionary *cdDict;
}

@property (strong, nonatomic) id delegate;


@end
