//
//  RORCheckBox.m
//  RevolUtioN
//
//  Created by leon on 13-9-18.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORCheckBox.h"

@implementation RORCheckBox

@synthesize isChecked;

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    // Initialization code
    self.contentHorizontalAlignment  = UIControlContentHorizontalAlignmentLeft;
    [self setImage:[UIImage imageNamed:@"switch_off.png"] forState:UIControlStateNormal];
    [self addTarget:self action:@selector(checkBoxClicked) forControlEvents:UIControlEventTouchUpInside];
    return self;
}

-(void)setTarget:(id)tar fun:(SEL)ff
{
	target=tar;
	fun=ff;
}
-(void)setIsChecked:(BOOL)check
{
	isChecked=check;
	if (check) {
		[self setImage:[UIImage imageNamed:@"switch_on.png"] forState:UIControlStateNormal];
		
	}
	else {
		[self setImage:[UIImage imageNamed:@"switch_off.png"] forState:UIControlStateNormal];
	}
}

-(IBAction) checkBoxClicked
{
	if(self.isChecked ==NO){
		self.isChecked =YES;
		[self setImage:[UIImage imageNamed:@"switch_on.png"] forState:UIControlStateNormal];
		
	}else{
		self.isChecked =NO;
		[self setImage:[UIImage imageNamed:@"switch_off.png"] forState:UIControlStateNormal];
		
	}
    SuppressPerformSelectorLeakWarning(
        [target performSelector:fun withObject:self]
    );
}

- (void)dealloc {
	target=nil;
}
@end
