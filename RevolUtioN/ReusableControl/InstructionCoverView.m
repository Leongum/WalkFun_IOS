//
//  InstructionCoverView.m
//  WalkFun
//
//  Created by Bjorn on 14-5-21.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "InstructionCoverView.h"
#import "FTAnimation.h"

@implementation InstructionCoverView
@synthesize delegate;
@synthesize forerunnerKey, minLevel, onlyChoice, thisKey;

- (id)initWithFrame:(CGRect)frame thisKey:(NSString *)key  andActiveRegionFrame:(CGRect)arf{
    self = [super initWithFrame:frame];
    if (self) {
        thisKey = key;
        onlyChoice = NO;
        
        activeRegion = [[UIControl alloc]initWithFrame: arf];
        [activeRegion setBackgroundColor:[UIColor whiteColor]];
        [activeRegion addTarget:self action:@selector(bgTap:) forControlEvents:UIControlEventTouchDown];
        
        if (activeRegion.frame.origin.x>self.frame.size.height/2){
            headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.frame.size.height/2, self.bounds.size.width, 125)];
            noteTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(INSTRUCTION_SIZE_HEADIMAGE+20, self.frame.size.height/2, self.bounds.size.width-INSTRUCTION_SIZE_HEADIMAGE-20, 125)];
        } else {
            headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.frame.size.height/2-125, self.bounds.size.width, 125)];
            noteTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(INSTRUCTION_SIZE_HEADIMAGE+20, self.frame.size.height/2-125, self.bounds.size.width-INSTRUCTION_SIZE_HEADIMAGE-20, 125)];
        }
        headImageView.image = [UIImage imageNamed:@"ins_head_image.png"];
        [noteTextLabel setLineBreakMode:NSLineBreakByWordWrapping];
        noteTextLabel.numberOfLines = 3;
        
        headImageView.alpha = 0;
        noteTextLabel.alpha = 0;
        [self addSubview:activeRegion];
        [self addSubview:headImageView];
        [self addSubview:noteTextLabel];
        
        [RORUtils setFontFamily:APP_FONT forView:self andSubViews:YES];
        
        self.alpha = 0;
    }
    return self;
}

-(IBAction)appear:(id)sender{
    NSMutableDictionary *userInfo = [RORUserUtils getUserInfoPList];
    NSNumber *n;
    //如果前驱事件还未发生，则不弹出
    if (forerunnerKey){
        n = (NSNumber *)[userInfo objectForKey:forerunnerKey];
        if (!n){
            return;
        }
    }
    //如果已经弹出过，则不弹出
    n = (NSNumber *)[userInfo objectForKey:thisKey];
    if (n)
        return;
    User_Base *userBase = [RORUserServices fetchUser:[RORUserUtils getUserId]];
    //如果还没登录，则不弹出
    if (!userBase)
        return;
    //如果还未达到触发等级，则不弹出
    if (userBase.userDetail.level.intValue<minLevel)
        return;
    
    //记录为已弹出
    [userInfo setObject:[NSNumber numberWithInt:1] forKey:thisKey];
    [RORUserUtils writeToUserInfoPList:userInfo];
    
    [super appear:sender];
    headImageView.alpha = 1;
    noteTextLabel.alpha = 1;
    [headImageView slideInFrom:kFTAnimationLeft duration:0.3 delegate:self startSelector:nil stopSelector:nil];
    [noteTextLabel slideInFrom:kFTAnimationRight duration:0.3 delegate:self startSelector:nil stopSelector:nil];
}

-(void)bgTap:(id)sender{
    if (!onlyChoice || sender == activeRegion)
        [super bgTap:sender];
}

-(void)addNoteText:(NSString *)nt{
    noteTextLabel.text = nt;
}

-(void)addTriggerForerunnerKey:(NSString *)frk minLevel:(int)ml{
    forerunnerKey = frk;
    minLevel = ml;
}

-(void)addAction:(id)target withSelector:(SEL)action{
    [activeRegion addTarget:delegate action:action forControlEvents:UIControlEventTouchUpInside];
}


@end
