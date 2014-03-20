//
//  Animations.h
//
//  Created by Pulkit Kathuria on 10/8/12.
//  Copyright (c) 2012 Pulkit Kathuria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define degreesToRadians(x) (M_PI*x/180.0)

@interface Animations : UIViewController{
}

+ (void)zoomOut: (UIView *)view andAnimationDuration: (float) duration andWait:(BOOL) wait;
+ (void)zoomIn: (UIView *)view andAnimationDuration: (float) duration andWait:(BOOL) wait;
+ (void)buttonPressAnimate: (UIView *)view andAnimationDuration: (float) duration andWait:(BOOL) wait;

+ (void)fadeIn: (UIView *)view andAnimationDuration: (float) duration toAlpha:(double)newAlpha andWait:(BOOL) wait;
+ (void)fadeOut: (UIView *)view andAnimationDuration: (float) duration fromAlpha:(double)oldAlpha andWait:(BOOL) wait;

+ (void) moveLeft: (UIView *)view andAnimationDuration: (float) duration andWait:(BOOL) wait andLength:(float) length;
+ (void) moveRight: (UIView *)view andAnimationDuration: (float) duration andWait:(BOOL) wait andLength:(float) length;

+ (void) moveUp: (UIView *)view andAnimationDuration: (float) duration andWait:(BOOL) wait andLength:(float) length;
+ (void) moveDown: (UIView *)view andAnimationDuration: (float) duration andWait:(BOOL) wait andLength:(float) length;

+ (void) rotate: (UIView *)view andAnimationDuration: (float) duration andWait:(BOOL) wait andAngle:(int) angle;

+ (void) frameAndShadow: (UIView *) view;

+ (void) frameAndShadow: (UIView *) view withColor:(UIColor *)color andOpacity:(float)opacity;

+ (void) removeFrameAndShadow: (UIView *) view;

+ (void) shadowOnView: (UIView *) view andShadowType: (NSString *) shadowType;

+ (void) background: (UIView *) view andImageFileName: (NSString *) filename;
+ (void) roundedCorners: (UIView *) view;

@end
