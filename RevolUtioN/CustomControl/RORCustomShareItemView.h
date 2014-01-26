//
//  RORCustomShareItemView.h
//  RevolUtioN
//
//  Created by leon on 13-8-19.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AGCommon/CMHTableViewItem.h>


@interface RORCustomShareItemView : CMHTableViewItem
{
@private
    UIImageView *_iconImageView;
    id _clickHandler;
}

/**
 *	@brief	图标视图
 */
@property (nonatomic,readonly) UIImageView *iconImageView;


/**
 *	@brief	初始化列表项
 *
 *	@param 	reuseIdentifier 	复用标识
 *  @param  clickHandler    点击事件处理器
 *
 *	@return	列表项对象
 */
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
                 clickHandler:(void(^)(NSIndexPath *indexPath))clickHandler;



@end
