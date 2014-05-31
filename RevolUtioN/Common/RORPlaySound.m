//
//  RORPlaySound.m
//  RevolUtioN
//
//  Created by Bjorn on 13-9-14.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORPlaySound.h"

@implementation RORPlaySound
-(id)initForPlayingVibrate
{
    self = [super init];
    if (self) {
        soundID = kSystemSoundID_Vibrate;
    }
    return self;
}

-(id)initForPlayingSystemSoundEffectWith:(NSString *)resourceName ofType:(NSString *)type
{
    self = [super init];
    if (self) {
        NSString *path = [[NSBundle bundleWithIdentifier:@"com.apple.UIKit"] pathForResource:resourceName ofType:type];
        if (path) {
            SystemSoundID theSoundID;
            OSStatus error =  AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &theSoundID);
            if (error == kAudioServicesNoError) {
                soundID = theSoundID;
            }else {
                NSLog(@"Failed to create sound ");
            }
        }
    }
    return self;
}

-(id)initForPlayingSoundEffectWith:(NSString *)filename
{
    return [self initForPlayingSoundEffectWith:filename withType:AVAudioSessionCategoryPlayback];
}


-(id)initForPlayingSoundEffectWith:(NSString *)filename withType:(NSString *)type
{
    self = [super init];
    if (self) {
        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
        if (fileURL != nil)
        {
            AVAudioSession *session = [AVAudioSession sharedInstance];
            [session setActive:YES error:nil];
            [session setCategory:type error:nil];
            
            player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
            [player prepareToPlay];
            [player setVolume:1];
        }
    }
    return self;
}

-(void)play
{
    
//    AudioServicesPlaySystemSound(soundID);
    [player play]; //播放
    
}

-(void)dealloc
{
    AudioServicesDisposeSystemSoundID(soundID);
}
@end