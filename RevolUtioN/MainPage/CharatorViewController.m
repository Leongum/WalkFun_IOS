//
//  CharatorViewController.m
//  WalkFun
//
//  Created by Bjorn on 14-2-28.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "CharatorViewController.h"

@interface CharatorViewController ()

@end

@implementation CharatorViewController
@synthesize userBase;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    charatorImageView = (UIImageView *)[self.view viewWithTag:1];
    charatorBumpImageView = (UIImageView *)[self.view viewWithTag:2];
    maleGrassImageView = (UIImageView *)[self.view viewWithTag:3];
    
    onFaceView = (UIView *)[self.view viewWithTag:101];
    frontCharatorView = (UIView *)[self.view viewWithTag:100];
    flowContainerView = (UIView *)[self.view viewWithTag:102];
    
    GROUND_SIZE_WIDTH = frontCharatorView.frame.size.width;
    FRONT_HEIGHT = frontCharatorView.frame.size.height;
    FACE_HEIGHT = onFaceView.frame.size.height;
    FACE_WIDTH = onFaceView.frame.size.width;
    VASE_SIZE_HEIGHT = flowContainerView.frame.size.height;
    VASE_SIZE_WIDTH = flowContainerView.frame.size.width;
    
    fatPV = nil;
    fightPV = nil;
    
    haveBump = NO;
    
    if (!userBase)
        self.view.alpha = 0;
}

-(THProgressView *)newProgressView:(UIView *)v{
    THProgressView *processView = [[THProgressView alloc] initWithFrame:v.frame];
    processView.borderTintColor = [UIColor blackColor];
    processView.progressTintColor = [UIColor blackColor];
    [processView setProgress:0.f];
    [self.view addSubview:processView];
    [self.view sendSubviewToBack:processView];
    return processView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (userBase) {
        self.view.alpha = 1;
        for (UIView *view in [onFaceView subviews])
            [view removeFromSuperview];
        for (UIView *view in [frontCharatorView subviews])
            [view removeFromSuperview];
        for (UIView *view in [flowContainerView subviews])
            [view removeFromSuperview];
        [self displayCharator];
        [self displayItems];
        [self displayProgresses];
        charatorBumpImageView.alpha = haveBump;
    }
    if (!fatPV){
        fatPVFrameView = (UILabel *)[self.view viewWithTag:200];
        fightPVFrameView = (UILabel *)[self.view viewWithTag:201];
        fatPV = [self newProgressView:fatPVFrameView];
//        fightPV = [self newProgressView:fightPVFrameView];
        [self.view bringSubviewToFront:fatPVFrameView];
//        [self.view bringSubviewToFront:fightPVFrameView];
    }
}


#pragma mark - display methods

-(void)displayProgresses{
    if (userBase.userId.intValue == [RORUserUtils getUserId].intValue){
        [fatPV setProgress:((double)[RORUserUtils getUserPowerLeft])/(userBase.userDetail.power.doubleValue + userBase.userDetail.powerPlus.doubleValue)];
        fatPVFrameView.text = [NSString stringWithFormat:@"%d/%d", [RORUserUtils getUserPowerLeft], userBase.userDetail.power.intValue + userBase.userDetail.powerPlus.intValue];
    } else {
        fatPVFrameView.text = [NSString stringWithFormat:@"%d", userBase.userDetail.power.intValue + userBase.userDetail.powerPlus.intValue];
        [fatPV setProgress:1];
    }
    //todo
//    [fightPV setProgress:userBase.userDetail.fight.doubleValue/300.f];
    if (userBase.userDetail.fightPlus.intValue>0){
        fightPVFrameView.text = [NSString stringWithFormat:@"%d+%d",userBase.userDetail.fight.intValue, userBase.userDetail.fightPlus.intValue];
    } else {
        fightPVFrameView.text = [NSString stringWithFormat:@"%d",userBase.userDetail.fight.intValue];
    }
}

-(void)displayCharator{
    int fatInt = userBase.userDetail.fatness.integerValue;
    NSMutableString *charFileName = [[NSMutableString alloc]init];
    if (fatInt<=20){
        [charFileName appendString:@"exslim_"];
    } else if (fatInt<=40) {
        [charFileName appendString:@"slim_"];
    } else if (fatInt<=60){
        [charFileName appendString:@"normal_"];
    } else if (fatInt<=80) {
        [charFileName appendString:@"fat_"];
    } else
        [charFileName appendString:@"exfat_"];
    
    if ([userBase.sex isEqualToString:@"男"]){
        [charFileName appendString:@"male.png"];
        maleGrassImageView.alpha = 1;
    } else {
        [charFileName appendString:@"female.png"];
        maleGrassImageView.alpha = 0;
    }
    
    charatorImageView.image = [UIImage imageNamed:charFileName];
}

-(void)displayItems{
    itemForDisplayDict = [RORUserUtils parsePropHavingString: userBase.userDetail.propHaving];
    for (NSNumber *itemId in [itemForDisplayDict allKeys]) {
        NSNumber *quantity = [itemForDisplayDict objectForKey:itemId];
        [self addItem:itemId withQuantity:quantity];
    }
    [self orderSubiews:onFaceView];
    [self orderSubiews:frontCharatorView];
    [self orderSubiews:flowContainerView];
}

-(void)addItem:(NSNumber *)itemId withQuantity:(NSNumber *)quantity{
    Virtual_Product *item = [RORVirtualProductService fetchVProduct:itemId];
    if ([item.productName rangeOfString:@"花"].location != NSNotFound &&
        [item.productName rangeOfString:@"花盆"].location == NSNotFound){
        //如果是花
        for (int i=0; i<quantity.integerValue; i++){
            [self makeNewFlowerImageView:item];
        }
    } else {
        //如果是石头之类的
        NSDictionary *effectDict = [RORUtils explainActionEffetiveRule:item.effectiveRule];
        if ([[effectDict allKeys] containsObject:RULE_Drop_Down]){
            for (int i=0; i<quantity.integerValue; i++){
                [self makeNewItemImageView:item];
            }
        } else if ([[effectDict allKeys] containsObject:RULE_On_Face]){
            for (int i=0; i<quantity.integerValue; i++){
                [self makeNewFaceImageView:item];
            }
        }
        haveBump = YES;
    }
}

-(void)makeNewItemImageView:(Virtual_Product *)item{
    double y = arc4random() % FRONT_HEIGHT;
    double x = arc4random() % GROUND_SIZE_WIDTH;
    double width = ITEM_SIZE_MIN + ((double)(ITEM_SIZE_MAX - ITEM_SIZE_MIN)) / ((double)FRONT_HEIGHT) * y;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, width)];

    imageView.center = CGPointMake(x, y);
    imageView.image = [RORVirtualProductService getRandomDropImageOf:item];

    [frontCharatorView addSubview:imageView];

}

-(void)makeNewFaceImageView:(Virtual_Product *)item{
    double y = arc4random() % FACE_HEIGHT;
    double x = arc4random() % FACE_WIDTH;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ONFACE_SIZE, ONFACE_SIZE)];
    
    imageView.center = CGPointMake(x, y);
    imageView.image = [RORVirtualProductService getRandomDropImageOf:item];
    
    [onFaceView addSubview:imageView];
    
}

-(void)makeNewFlowerImageView:(Virtual_Product *)item{
    double y = arc4random() % VASE_SIZE_HEIGHT;
    double x = arc4random() % VASE_SIZE_WIDTH;
    double width = arc4random() % 10 + 40;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, width)];
    imageView.center = CGPointMake(x, y-width/2);
    imageView.image = [RORVirtualProductService getRandomDropImageOf:item];
    [flowContainerView addSubview:imageView];
}

-(void)orderSubiews:(UIView *)thisView{
    NSArray *viewList = [thisView subviews];
    viewList = [viewList sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        UIView *view1 = (UIView *)obj1;
        UIView *view2 = (UIView *)obj2;
        if ( view1.frame.origin.y>view2.frame.origin.y){
            return  NSOrderedDescending;
        }
        if ( view1.frame.origin.y<view2.frame.origin.y){
            return  NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
    for (int i=0; i<viewList.count; i++){
        UIView *view = (UIView *)[viewList objectAtIndex:i];
        [thisView bringSubviewToFront:view];
    }
}


@end
