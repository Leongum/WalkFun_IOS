//
//  RORCheckBox.h
//  RevolUtioN
//
//  Created by leon on 13-9-18.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RORUtils.h"

@interface RORCheckBox : UIButton
{
    BOOL isChecked;
	id target;
	SEL fun;
}
@property (nonatomic,assign) BOOL isChecked;

-(IBAction) checkBoxClicked;
-(void)setTarget:(id)tar fun:(SEL )ff;
@end
