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
        itemIconImageView = [[UIImageView alloc]initWithFrame:frame];
        itemIconImageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self addSubview:itemIconImageView];
        
        itemQuantityLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 20)];
        [itemQuantityLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [itemQuantityLabel setBackgroundColor:[UIColor redColor]];
        [self addSubview:itemQuantityLabel];
        
    }
    return self;
}

-(void)fillContentWith:(User_Prop *)newUserItem{
    userItem = newUserItem;
    item = [RORVirtualProductService fetchVProduct:userItem.productId];
    
    //todo
    NSURL *imageUrl = [NSURL URLWithString:item.picLink];
    UIImage *iconImage = [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:imageUrl]];
    [itemIconImageView setImage:iconImage];
    itemQuantityLabel.text = [NSString stringWithFormat:@"x %@",userItem.ownNumber];
}


@end
