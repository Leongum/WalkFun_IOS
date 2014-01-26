//
//  RORCustomShareViewToolbar.m
//  RevolUtioN
//
//  Created by leon on 13-8-19.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORCustomShareViewToolbar.h"
#import <ShareSDK/ShareSDK.h>
#import <AGCommon/UIImage+Common.h>
#import <AGCommon/UIColor+Common.h>
#import "RORCustomShareItemView.h"

#define ITEM_ID @"item"

@implementation RORCustomShareViewToolbar

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _appDelegate = (RORAppDelegate *)[UIApplication sharedApplication].delegate;
        
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textColor = [UIColor darkGrayColor];
        _textLabel.text = SHARE_TO_PLATFORM_LIST;
        _textLabel.font = [UIFont boldSystemFontOfSize:12];
        [_textLabel sizeToFit];
        
        _textLabel.frame = CGRectMake(3.0, 0.0, _textLabel.frame.size.width + 3, self.frame.size.height);
        _textLabel.contentMode = UIViewContentModeCenter;
        [self addSubview:_textLabel];
        
        _tableView = [[CMHTableView alloc] initWithFrame:CGRectMake(_textLabel.frame.size.width + _textLabel.frame.origin.x +3.0, 0.0, self.frame.size.width - (_textLabel.frame.size.width + _textLabel.frame.origin.x), self.frame.size.height)];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.itemWidth = 40;
        _tableView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_tableView];
        
        _oneKeyShareListArray = [[NSMutableArray alloc] initWithObjects:
                                 [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                  @"type",
                                  [NSNumber numberWithBool:NO],
                                  @"selected",
                                  nil],
                                 [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                  @"type",
                                  [NSNumber numberWithBool:NO],
                                  @"selected",
                                  nil],
                                 [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  SHARE_TYPE_NUMBER(ShareTypeRenren),
                                  @"type",
                                  [NSNumber numberWithBool:NO],
                                  @"selected",
                                  nil],
                                 nil];
        
        
        
    }
    return self;
}

- (void)dealloc
{
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
    _tableView = nil;
}

- (NSArray *)selectedClients
{
    NSMutableArray *clients = [NSMutableArray array];
    
    for (int i = 0; i < [_oneKeyShareListArray count]; i++)
    {
        NSDictionary *item = [_oneKeyShareListArray objectAtIndex:i];
        if ([[item objectForKey:@"selected"] boolValue])
        {
            [clients addObject:[item objectForKey:@"type"]];
        }
    }
    
    return clients;
}

#pragma mark - CMHTableViewDataSource

- (NSInteger)itemNumberOfTableView:(CMHTableView *)tableView
{
    return [_oneKeyShareListArray count];
}

- (UIView<ICMHTableViewItem> *)tableView:(CMHTableView *)tableView itemForIndexPath:(NSIndexPath *)indexPath
{
    RORCustomShareItemView *itemView = (RORCustomShareItemView *)[tableView dequeueReusableItemWithIdentifier:ITEM_ID];
    if (itemView == nil)
    {
        itemView = [[RORCustomShareItemView alloc] initWithReuseIdentifier:ITEM_ID
                                                      clickHandler:^(NSIndexPath *indexPath) {
                                                          if (indexPath.row < [_oneKeyShareListArray count])
                                                          {
                                                              NSMutableDictionary *item = [_oneKeyShareListArray objectAtIndex:indexPath.row];
                                                              ShareType shareType = [[item objectForKey:@"type"] integerValue];
                                                              if ([ShareSDK hasAuthorizedWithType:shareType])
                                                              {
                                                                  BOOL selected = ! [[item objectForKey:@"selected"] boolValue];
                                                                  [item setObject:[NSNumber numberWithBool:selected] forKey:@"selected"];
                                                                  [_tableView reloadData];
                                                              }
                                                              else
                                                              {
                                                                  id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                                                                                       allowCallback:YES
                                                                                                                       authViewStyle:SSAuthViewStyleFullScreenPopup
                                                                                                                        viewDelegate:_appDelegate.viewDelegate
                                                                                                             authManagerViewDelegate:nil];
                                                                  
                                                                  [authOptions setPowerByHidden:true];
                                                                  
                                                                  [ShareSDK getUserInfoWithType:shareType
                                                                                    authOptions:authOptions
                                                                                         result:^(BOOL result, id<ISSUserInfo> userInfo, id<ICMErrorInfo> error) {
                                                                                             if (result)
                                                                                             {
                                                                                                 [item setObject:[NSNumber numberWithBool:YES] forKey:@"selected"];
                                                                                                 [_tableView reloadData];
                                                                                             }
                                                                                             else
                                                                                             {
                                                                                                 if ([error errorCode] != -103)
                                                                                                 {
                                                                                                     
                                                                                                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:ALERT_VIEW_TITEL message:SNS_BIND_ERROR delegate:nil cancelButtonTitle:CANCEL_BUTTON otherButtonTitles:nil];
                                                                                                     [alertView show];
                                                                                                 }
                                                                                             }
                                                                                         }];
                                                              }
                                                          }
                                                      }];
    }
    
    if (indexPath.row < [_oneKeyShareListArray count])
    {
        NSDictionary *item = [_oneKeyShareListArray objectAtIndex:indexPath.row];
        UIImage *icon = [ShareSDK getClientIconWithType:[[item objectForKey:@"type"] integerValue]];
        itemView.iconImageView.image = icon;
        
        if ([[item objectForKey:@"selected"] boolValue])
        {
            itemView.iconImageView.alpha = 1;
        }
        else
        {
            itemView.iconImageView.alpha = 0.5;
        }
    }
    
    return itemView;
}


@end
