//
//  RORCustomShareViewToolbar.h
//  RevolUtioN
//
//  Created by leon on 13-8-19.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AGCommon/CMHTableView.h>
#import "RORAppDelegate.h"
#import "RORUtils.h"

@interface RORCustomShareViewToolbar : UIView<CMHTableViewDataSource,CMHTableViewDelegate>
{
@private
    CMHTableView *_tableView;
    UILabel *_textLabel;
    
    NSMutableArray *_oneKeyShareListArray;
    RORAppDelegate *_appDelegate;
}

/**
 *	@brief	获取选中分享平台列表
 *
 *	@return	选中分享平台列表
 */
- (NSArray *)selectedClients;

@end
