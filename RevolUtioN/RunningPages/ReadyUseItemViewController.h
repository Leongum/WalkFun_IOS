//
//  ReadyUseItemViewController.h
//  WalkFun
//
//  Created by Bjorn on 14-3-25.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "RORViewController.h"
#import "RORUserPropsService.h"

@interface ReadyUseItemViewController : RORViewController{
    NSMutableArray *contentList;
    NSMutableArray *itemList;
}

@property (strong, nonatomic) id delegate;
@property (strong, nonatomic)    User_Base *userBase;
@property (strong, nonatomic) IBOutlet UILabel *noItemLabel;

@end
