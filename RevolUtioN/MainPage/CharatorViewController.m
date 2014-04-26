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
    faceColorIndex = 0;
    
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
        //先显示道具效果，因为有些道具效果可能影响到角色形像
        [self displayItems];
        [self displayCharator];
        [self displayProgresses];
        charatorBumpImageView.alpha = haveBump;
    }
    if (!fatPV){
        fatPVFrameView = (UILabel *)[self.view viewWithTag:200];
        fightPVFrameView = (UILabel *)[self.view viewWithTag:201];
//        fatPV = [self newProgressView:fatPVFrameView];
//        fightPV = [self newProgressView:fightPVFrameView];
//        [self.view bringSubviewToFront:fatPVFrameView];
//        [self.view bringSubviewToFront:fightPVFrameView];
    }
}


#pragma mark - display methods

-(void)displayProgresses{
    if (userBase.userId.intValue == [RORUserUtils getUserId].intValue){
        fatPVFrameView.text = [NSString stringWithFormat:@"%d/%d", [RORUserUtils getUserPowerLeft], userBase.userDetail.power.intValue + userBase.userDetail.powerPlus.intValue];
    } else {
        fatPVFrameView.text = [NSString stringWithFormat:@"%d", userBase.userDetail.power.intValue + userBase.userDetail.powerPlus.intValue];
    }
    if (userBase.userDetail.powerPlus.intValue>0){
        [fatPVFrameView setTextColor:[UIColor yellowColor]];
    } else {
        [fatPVFrameView setTextColor:[UIColor whiteColor]];
    }
    
    fightPVFrameView.text = [NSString stringWithFormat:@"%d",userBase.userDetail.fight.intValue + userBase.userDetail.fightPlus.intValue];
    if (userBase.userDetail.fightPlus.intValue>0){
        [fightPVFrameView setTextColor:[UIColor yellowColor]];
    } else {
        [fightPVFrameView setTextColor:[UIColor whiteColor]];
    }
}

-(void)refreshUserData{
    [self displayProgresses];
}

-(void)displayCharator{
    int fatInt = userBase.userDetail.fatness.integerValue;
    NSMutableString *charFileName = [[NSMutableString alloc]init];
    switch (faceColorIndex) {
        case 0:
            break;
        case 1://blaceColor
            [charFileName appendFormat:@"black_"];
            break;
        case 2://white
            [charFileName appendFormat:@"white_"];
            break;
        case 3://green
            [charFileName appendFormat:@"green_"];
            break;
        case 4://blue
            [charFileName appendFormat:@"blue_"];
            break;
        case 5://red
            [charFileName appendFormat:@"red_"];
            break;
        default:
            break;
    }
    
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
    
    charatorImageView.image = [RORUserServices getCharactorImageNamed:charFileName];
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
    
    [self rotateSubiews:onFaceView];
}

-(void)addItem:(NSNumber *)itemId withQuantity:(NSNumber *)quantity{
    Virtual_Product *item = [RORVirtualProductService fetchVProduct:itemId];
    
    //如果是石头之类的
    NSDictionary *effectDict = [RORUtils explainActionEffetiveRule:item.effectiveRule];
    if ([[effectDict allKeys] containsObject:RULE_Drop_Pot]) {
        //如果是花
        for (int i=0; i<quantity.integerValue; i++){
            [self makeNewFlowerImageView:item];
        }
    }
    if ([[effectDict allKeys] containsObject:RULE_Drop_Down]){
        for (int i=0; i<quantity.integerValue; i++){
            [self makeNewItemImageView:item];
        }
        haveBump = YES;
    }
    if ([[effectDict allKeys] containsObject:RULE_On_Face]){
        for (int i=0; i<quantity.integerValue; i++){
            [self makeNewFaceImageView:item];
        }
    }
    if ([[effectDict allKeys] containsObject:RULE_Face_Color]){
        faceColorIndex = ((NSNumber *)[effectDict objectForKey:RULE_Face_Color]).intValue;
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
    double sizeRate = (arc4random() % 20 + 80.f)/100.f;
    UIImage *thisImage = [RORVirtualProductService getRandomDropImageOf:item];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:thisImage];
    imageView.frame = CGRectMake(0, 0, thisImage.size.width*sizeRate/2, thisImage.size.height*sizeRate/2);
    imageView.center = CGPointMake(x, y-imageView.bounds.size.height/2);
    
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

-(void)rotateSubiews:(UIView *)thisView{
    NSArray *viewList = [thisView subviews];
    for (int i=0; i<viewList.count; i++){
        UIView *view = (UIView *)[viewList objectAtIndex:i];
        int roll = arc4random()%60;
        roll-=30;
        [Animations rotate:view andAnimationDuration:0 andWait:NO andAngle:roll];
    }
}

@end
