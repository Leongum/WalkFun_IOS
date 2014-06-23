//
//  ReadyToGoViewController.m
//  WalkFun
//
//  Created by Bjorn on 14-3-25.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "ReadyToGoViewController.h"

@interface ReadyToGoViewController ()

@end

@implementation ReadyToGoViewController
@synthesize selectedItem, selectedFriend;

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

    self.backButton.alpha = 0;
    
    // Do any additional setup after loading the view.
    mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:[NSBundle mainBundle]];
    
    NSMutableDictionary *userInfoPList = [RORUserUtils getUserInfoPList];
    NSDate *itemDate = [RORDBCommon getDateFromId:[userInfoPList objectForKey:@"LatestUseItemDate"]];
    NSNumber *latestUseItemId = [RORDBCommon getNumberFromId:[userInfoPList objectForKey:@"LatestUseItemId"]];
    NSDateFormatter *formattter = [[NSDateFormatter alloc] init];
    [formattter setDateFormat:@"yyyyMMdd"];
    NSNumber *itemDateNum = [RORDBCommon getNumberFromId:[formattter stringFromDate:itemDate]];
    NSNumber *todayNum = [RORDBCommon getNumberFromId:[formattter stringFromDate:[NSDate date]]];
    if (itemDateNum.intValue == todayNum.intValue){
        todayItem = [RORVirtualProductService fetchVProduct:latestUseItemId];
    } else
        todayItem = nil;
    
    //加载用户个人信息
    userBase = [RORUserServices fetchUser:[RORUserUtils getUserId]];
    self.baseFightLabel.text = [NSString stringWithFormat:@"%d", userBase.userDetail.fight.intValue];
    self.basePowerLabel.text = [NSString stringWithFormat:@"%d", userBase.userDetail.power.intValue];
    self.extraFightLabel.text = [NSString stringWithFormat:@"%d",userBase.userDetail.fightPlus.intValue];
    self.extraPowerLabel.text = [NSString stringWithFormat:@"%d",userBase.userDetail.powerPlus.intValue];
    
    
    [RORUtils setFontFamily:APP_FONT forView:self.view andSubViews:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    fightAdded = 0;
    powerAdded = 0;
    
    if (selectedFriend){
        self.friendLabel.text = selectedFriend.nickName;
        fightAdded += (selectedFriend.userDetail.fight.intValue +
                       selectedFriend.userDetail.fightPlus.intValue)/5;
        [self.cancelFriendButton setBackgroundImage:[UIImage imageNamed:@"running_ready_del.png"] forState:UIControlStateNormal];
    } else {
        self.friendLabel.text = @"带个伙伴";
        [self.cancelFriendButton setBackgroundImage:[UIImage imageNamed:@"running_ready_add.png"] forState:UIControlStateNormal];
    }
    
    if (selectedItem){
        self.itemLabel.text = selectedItem.productName;
        self.itemImage.image = [RORVirtualProductService getImageOf:selectedItem];
        [self.cancelBuffButton setBackgroundImage:[UIImage imageNamed:@"running_ready_del.png"] forState:UIControlStateNormal];
        
        [self calculateItemEffect];
        self.extraFightLabel.text = [NSString stringWithFormat:@"%d",fightAdded];
        self.extraPowerLabel.text = [NSString stringWithFormat:@"%d", powerAdded];
    } else {
        if (todayItem){
            self.itemLabel.text = todayItem.productName;
            self.itemImage.image = [RORVirtualProductService getImageOf:todayItem];
        } else {
            self.itemLabel.text = @"加强一下";
            self.itemImage.image = [UIImage imageNamed:@"running_ready_item_default.png"];
        }
        [self.cancelBuffButton setBackgroundImage:[UIImage imageNamed:@"running_ready_add.png"] forState:UIControlStateNormal];
        
        self.extraFightLabel.text = [NSString stringWithFormat:@"%d",fightAdded + userBase.userDetail.fightPlus.intValue];
        self.extraPowerLabel.text = [NSString stringWithFormat:@"%d",userBase.userDetail.powerPlus.intValue];
    }
    [MobClick beginLogPageView:@"ReadyToGoViewController"];
    [MTA trackPageViewBegin:@"ReadyToGoViewController"];
}

-(void)viewDidAppear:(BOOL)animated{
    [self checkFirstStartInstruction];
    
    [super viewDidAppear:animated];
}

-(void)checkFirstStartInstruction{
    startInstruction = [[InstructionCoverView alloc]initWithFrame:self.view.bounds thisKey:InstructionOrder_toString[1]  andActiveRegionFrame:self.startButton.frame];
    [startInstruction addNoteText:@"点“出发”就可以开始记录走路了！"];
    [startInstruction addTriggerForerunnerKey:InstructionOrder_toString[0] minLevel:0];
    [startInstruction addAction:self withSelector:@selector(startAction:)];
    [startInstruction setOnlyChoice:NO];
    [coverViewQueue addObject:startInstruction];
}

-(void)calculateItemEffect{
    NSDictionary *effectDict = [RORUtils explainActionEffetiveRule:selectedItem.effectiveRule];
    if ([[effectDict allKeys] containsObject:RULE_Fight_Add]){
        NSNumber *value = [effectDict valueForKey:RULE_Fight_Add];
        fightAdded += value.intValue;
    }
    if ([[effectDict allKeys] containsObject:RULE_Fight_Percent]){
        NSNumber *value = [effectDict valueForKey:RULE_Fight_Percent];
        fightAdded += userBase.userDetail.fight.intValue * value.intValue / 100;
    }
    if ([[effectDict allKeys] containsObject:RULE_Physical_Power_Add]){
        NSNumber *value = [effectDict valueForKey:RULE_Physical_Power_Add];
        powerAdded += value.intValue;
    }
    if ([[effectDict allKeys] containsObject:RULE_Physical_Power_Percent]){
        NSNumber *value = [effectDict valueForKey:RULE_Physical_Power_Percent];
        powerAdded += userBase.userDetail.power.intValue * value.intValue / 100;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *destination = segue.destinationViewController;
    if ([destination respondsToSelector:@selector(setDelegate:)]){
        [destination setValue:self forKey:@"delegate"];
    }
}

- (IBAction)startAction:(id)sender {
    
    [MobClick event:@"goClick"];
    [MTA trackCustomKeyValueEvent:@"goClick" props:nil];
    User_Base *toThisUser = [RORUserServices fetchUser:[RORUserUtils getUserId]];
    if (!toThisUser)
        toThisUser = [RORUserServices syncUserInfoById:[RORUserUtils getUserId]];
    [self startIndicator:self];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (selectedItem){
            Action_Define *action = [RORSystemService fetchActionDefineByPropId:selectedItem.productId];
            isSucceeded = [RORFriendService createAction:toThisUser.userId withActionToUserName:toThisUser.nickName withActionId:action.actionId];
        } else
            isSucceeded = YES;
        if (selectedFriend) {
            //记录选择的伙伴id
            [RORUserUtils writeToUserInfoPList:[NSDictionary dictionaryWithObjectsAndKeys:selectedFriend.userId, @"thisWalkFriendId", nil]];
        } else {
            [RORUserUtils writeToUserInfoPList:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:-1], @"thisWalkFriendId", nil]];
        }
        
        userBase = [RORUserServices syncUserInfoById:[RORUserUtils getUserId]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            CoverView *coverView = (CoverView *)self.view;
            [coverView bgTap:self];
            if (isSucceeded){
                [self endIndicator:self];
                if (selectedItem){         //如果选择在这里对自己使用道具
                    NSMutableDictionary *userInfoPList = [RORUserUtils getUserInfoPList];
                    [userInfoPList setObject:[NSDate date] forKey:@"LatestUseItemDate"];
                    [userInfoPList setObject:selectedItem.productId forKey:@"LatestUseItemId"];
                    [RORUserUtils writeToUserInfoPList:userInfoPList];
                }
                [self performSegueWithIdentifier:@"StartWalkingAction" sender:self];
            } else {
                [self sendAlart:@"网络错误，无法使用道具"];
            }
        });
    });
    
}

- (IBAction)cancelBuffAction:(id)sender {
    if (selectedItem){
        selectedItem = nil;
        [self viewWillAppear:NO];
    } else {
        [MobClick event:@"itemEnhanceClick"];
        [MTA trackCustomKeyValueEvent:@"itemEnhanceClick" props:nil];
        UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"ReadyUseItemViewController"];
        if ([viewController respondsToSelector:@selector(setDelegate:)]){
            [viewController setValue:self forKey:@"delegate"];
        }
        [[self parentViewController] presentViewController:viewController animated:YES completion:^(){}];
    }
}

- (IBAction)cancelFriendAction:(id)sender {
//    //等级限制
//    if (userBase.userDetail.level.intValue<3){
//        [self sendAlart:@"等级3解锁"];
//        return;
//    }
    if (selectedFriend){
        selectedFriend = nil;
        [self viewWillAppear:NO];
    } else {
        [MobClick event:@"withFriendClick"];
        [MTA trackCustomKeyValueEvent:@"withFriendClick" props:nil];
        UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"ReadyAddPartnerViewController"];
        if ([viewController respondsToSelector:@selector(setDelegate:)]){
            [viewController setValue:self forKey:@"delegate"];
        }
        [[self parentViewController] presentViewController:viewController animated:YES completion:^(){}];

    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ReadyToGoViewController"];
}

-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [MTA trackPageViewEnd:@"ReadyToGoViewController"];
}

@end
