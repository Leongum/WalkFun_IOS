//
//  NoteAnimationCoverView.h
//  WalkFun
//
//  Created by Bjorn on 14-5-27.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "CoverView.h"
#import "RORUtils.h"
#import "MissionCongratsLabel.h"

@interface NoteAnimationCoverView : CoverView{
    MissionCongratsLabel *contentLabel;
}

- (id)initWithFrame:(CGRect)frame andNoteText:(NSString *)t;

@end
