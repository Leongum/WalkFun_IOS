//
//  InstructionCoverView.h
//  WalkFun
//
//  Created by Bjorn on 14-5-21.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "CoverView.h"
#import "RORUtils.h"

#define INSTRUCTION_SIZE_HEADIMAGE 100

@interface InstructionCoverView : CoverView{
    UIControl *activeRegion;
    UILabel *noteTextLabel;
    UIImageView *headImageView;
}

@property (nonatomic, strong) id delegate;

@property (nonatomic) CGRect activeRegionFrame;
@property (nonatomic, strong) NSString *thisKey;
@property (nonatomic, strong) NSString *forerunnerKey;
@property (nonatomic) int minLevel;
@property (nonatomic) int maxLevel;
@property (nonatomic) BOOL onlyChoice;

- (id)initWithFrame:(CGRect)frame thisKey:(NSString *)key andActiveRegionFrame:(CGRect)arf;
-(void)addNoteText:(NSString *)nt;
-(void)addTriggerForerunnerKey:(NSString *)frk minLevel:(int)ml;
-(void)addAction:(id)target withSelector:(SEL)action;

@end
