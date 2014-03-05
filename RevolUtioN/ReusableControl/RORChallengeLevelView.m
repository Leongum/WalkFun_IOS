//
//  RORChallengeLevelView.m
//  RevolUtioN
//
//  Created by Bjorn on 13-8-29.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORChallengeLevelView.h"

#define CURRENTLEVEL_DELTA_SIZE 25
#define LIGHT_GRAY_COLOR [UIColor colorWithWhite:220.f/255.f alpha:1]
#define FRONT_COLOR [UIColor yellowColor]

@implementation RORChallengeLevelView
@synthesize currentLevel = _currentLevel;

- (id)initWithFrame:(CGRect)frame andNumberOfColumns:(NSInteger)number
{
    //self = [self initWithFrame:frame andNumberOfColumns:number andCurrentLevel:GRADE_F];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andNumberOfColumns:(NSInteger)number andCurrentLevel:(NSInteger)level
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //_currentLevel = GRADE_F;
        self.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:231 green:8 blue:53 alpha:1];
        columns = number;
        [self initTable];
    }
    return self;
}


- (void)initTable{
    int cellHeight = self.frame.size.height/columns;
    int cellWidth = cellHeight * 3;

    for (int i=0; i<columns; i++){
        int labelWidth = cellWidth-cellHeight;
        
        CGRect labelFrame = CGRectMake(self.frame.size.width/2 - cellWidth/6, cellHeight*i, labelWidth, cellHeight);
        CGRect imageFrame = CGRectMake(self.frame.size.width/2 - cellWidth/2, cellHeight*i, cellHeight, cellHeight);

        UILabel *contentLabel = [[UILabel alloc]initWithFrame:labelFrame];
        [contentLabel setFont:[UIFont systemFontOfSize:15]];
        [contentLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [contentLabel setTag:i+1];
        [contentLabel setBackgroundColor:[UIColor clearColor]];
        [contentLabel setTextColor:LIGHT_GRAY_COLOR];
        contentLabel.textAlignment = NSTextAlignmentCenter;
        contentLabel.text = [NSString stringWithFormat:@"%d", i];
        [self addSubview:contentLabel];
        
//        UIImageView *contentImage = [[UIImageView alloc]initWithFrame:imageFrame];
        UILabel *contentImage = [[UILabel alloc]initWithFrame:imageFrame];
        [contentImage setTag:i+columns+1];
        contentImage.textAlignment = NSTextAlignmentCenter;
        //[contentImage setText:MissionGradeEnum_toString[i]];
        [contentImage setBackgroundColor:[UIColor clearColor]];
        [contentImage setTextColor:LIGHT_GRAY_COLOR];
        [contentImage setFont:[UIFont systemFontOfSize:24]];
        [self addSubview:contentImage];

//        [contentImage setImage:[UIImage imageNamed:MissionGradeImageEnum_toString[i]]];

        //        [self.tableCell addObject:contentLabel];
    }
}

-(void)setCurrentLevel:(NSInteger)level{
//    if (_currentLevel<GRADE_F) {
//        UILabel *contentLabel = (UILabel *)[self viewWithTag:_currentLevel+1];
//        UILabel *contentImage = (UILabel *)[self viewWithTag:_currentLevel+columns+1];
//
//        [contentImage setFont:[UIFont fontWithName:ENG_WRITTEN_FONT size:24]];
//        [contentLabel setFont:[UIFont fontWithName:ENG_WRITTEN_FONT size:15]];
//        contentLabel.frame = CGRectMake(contentLabel.frame.origin.x+CURRENTLEVEL_DELTA_SIZE*0.75, contentLabel.frame.origin.y+CURRENTLEVEL_DELTA_SIZE, contentLabel.frame.size.width-CURRENTLEVEL_DELTA_SIZE*2, contentLabel.frame.size.height-CURRENTLEVEL_DELTA_SIZE*2);
//        contentImage.frame = CGRectMake(contentImage.frame.origin.x+CURRENTLEVEL_DELTA_SIZE*1.25, contentImage.frame.origin.y+CURRENTLEVEL_DELTA_SIZE, contentImage.frame.size.width-CURRENTLEVEL_DELTA_SIZE*2, contentImage.frame.size.height-CURRENTLEVEL_DELTA_SIZE*2);
//        contentLabel.textColor = LIGHT_GRAY_COLOR;
//        contentImage.textColor = LIGHT_GRAY_COLOR;
//    }
//    
//    _currentLevel = level;
//    
//    if (_currentLevel<GRADE_F){
//        UILabel *contentLabel = (UILabel *)[self viewWithTag:self.currentLevel+1];
//        UILabel *contentImage = (UILabel *)[self viewWithTag:self.currentLevel+columns+1];
//
//        [contentImage setFont:[UIFont fontWithName:ENG_WRITTEN_FONT size:44]];
//        [contentLabel setFont:[UIFont fontWithName:ENG_WRITTEN_FONT size:24]];
//        contentLabel.frame = CGRectMake(contentLabel.frame.origin.x-CURRENTLEVEL_DELTA_SIZE*0.75, contentLabel.frame.origin.y-CURRENTLEVEL_DELTA_SIZE, contentLabel.frame.size.width+CURRENTLEVEL_DELTA_SIZE*2, contentLabel.frame.size.height+CURRENTLEVEL_DELTA_SIZE*2);
//        contentImage.frame = CGRectMake(contentImage.frame.origin.x-CURRENTLEVEL_DELTA_SIZE*1.25, contentImage.frame.origin.y-CURRENTLEVEL_DELTA_SIZE, contentImage.frame.size.width+CURRENTLEVEL_DELTA_SIZE*2, contentImage.frame.size.height+CURRENTLEVEL_DELTA_SIZE*2);
//        contentLabel.textColor = FRONT_COLOR;
//        contentImage.textColor = FRONT_COLOR;
//    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
