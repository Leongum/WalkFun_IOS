//
//  RORCustomShareItemView.m
//  RevolUtioN
//
//  Created by leon on 13-8-19.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORCustomShareItemView.h"

#define ICON_WIDTH 30.0
#define ICON_HEIGHT 30.0

@implementation RORCustomShareItemView

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier clickHandler:(void(^)(NSIndexPath *indexPath))clickHandler
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - ICON_WIDTH) / 2, (self.frame.size.height - ICON_HEIGHT) / 2, ICON_WIDTH, ICON_HEIGHT)];
        _iconImageView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:_iconImageView];
        
        _clickHandler = [clickHandler copy];
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    if (_clickHandler)
    {
        ((void(^)(NSIndexPath *indexPath))_clickHandler)(self.indexPath);
    }
}

@end
