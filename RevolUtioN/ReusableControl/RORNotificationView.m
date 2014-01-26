//
//  RORNotificationView.m
//  RevolUtioN
//
//  Created by Bjorn on 13-9-5.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORNotificationView.h"
#import "FTAnimation.h"
#import "Animations.h"

#define NOTE_VIEW_FRAME CGRectMake(0,0,320,25)

@implementation RORNotificationView

- (id)init{
    self = [self initWithFrame:NOTE_VIEW_FRAME];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0.8;
        // Initialization code
        backgroundView = [[UIView alloc] initWithFrame:frame];
        backgroundView.backgroundColor = [UIColor blackColor];
        backgroundView.alpha = 1;
        [self addSubview:backgroundView];
        
        messageLabel = [[UILabel alloc]initWithFrame:frame];
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        
        [messageLabel setFont:[UIFont systemFontOfSize:13]];
        [self addSubview:messageLabel];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)configType:(NSInteger)type{
    switch (type) {
        case RORNOTIFICATION_TYPE_NORMAL:
        {
            backgroundView.backgroundColor = [UIColor blackColor];
            break;
        }
        case RORNOTIFICATION_TYPE_IMPORTANT:
        {
            backgroundView.backgroundColor = [UIColor redColor];
            break;
        }
        default:
            break;
    }
}

-(void)popNotification:(id)delegate Message:(NSString *)msg{
    [self popNotification:delegate Message:msg andType:RORNOTIFICATION_TYPE_NORMAL];
}

-(void)popNotification:(id)delegate Message:(NSString *)msg andType:(RORNOTIFICATION_TYPE)type{
    [self configType:type];
    message = msg;
    messageLabel.text = message;
    [self slideInFrom:kFTAnimationTop duration:0.3 delegate:delegate];
    [Animations fadeOut:self andAnimationDuration:5 fromAlpha:1 andWait:NO];
}

@end
