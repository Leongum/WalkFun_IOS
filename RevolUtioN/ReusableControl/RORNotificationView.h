//
//  RORNotificationView.h
//  RevolUtioN
//
//  Created by Bjorn on 13-9-5.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    RORNOTIFICATION_TYPE_NORMAL = 0,
    RORNOTIFICATION_TYPE_IMPORTANT
} RORNOTIFICATION_TYPE ;

@interface RORNotificationView : UIControl{
    UIView *backgroundView;
    UILabel *messageLabel;
    NSString *message;
}
-(void)popNotification:(id)delegate Message:(NSString *)msg;
-(void)popNotification:(id)delegate Message:(NSString *)msg andType:(RORNOTIFICATION_TYPE)type;

@end
