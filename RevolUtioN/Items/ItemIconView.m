//
//  ItemIconView.m
//  WalkFun
//
//  Created by Bjorn on 14-2-17.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "ItemIconView.h"

@implementation ItemIconView
@synthesize userItem;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        itemIconBgImageView = [[UIImageView alloc]initWithFrame:frame];
        itemIconBgImageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        itemIconBgImageView.image = [UIImage imageNamed:@"item_icon_cell.png"];
        [self addSubview:itemIconBgImageView];

        itemIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 12, 47, 47)];
//        itemIconImageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self addSubview:itemIconImageView];
        
        itemQuantityLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, self.frame.size.height-21, CGRectGetWidth(frame)-40, 20)];
        [itemQuantityLabel setFont:[UIFont boldSystemFontOfSize:13]];
        [itemQuantityLabel setBackgroundColor:[UIColor clearColor]];
        [itemQuantityLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:itemQuantityLabel];
        
    }
    return self;
}

-(void)fillContentWith:(User_Prop *)newUserItem{
    userItem = newUserItem;
    item = [RORVirtualProductService fetchVProduct:userItem.productId];
    
    //todo
//    NSURL *imageUrl = [NSURL URLWithString:item.picLink];
//    UIImage *iconImage = [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:imageUrl]];
    UIImage *iconImage = [RORVirtualProductService getImageOf:item];
    [itemIconImageView setImage:iconImage];
    itemQuantityLabel.text = [NSString stringWithFormat:@"x %@",userItem.ownNumber];
}


@end
