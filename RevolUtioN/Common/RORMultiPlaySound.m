//
//  RORMultiPlaySound.m
//  WalkFun
//
//  Created by leon on 13-12-28.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORMultiPlaySound.h"

@implementation RORMultiPlaySound

-(id)init{
    self = [super init];
    if (self) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    }
    
    return self;
}

- (void)addFileNametoQueue:(NSString*)fileName {
    if(fileNameQueue == nil){
        fileNameQueue = [[NSMutableArray alloc] init];
    }
    [fileNameQueue addObject:fileName];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (index < fileNameQueue.count) {
        [self play:index];
    } else {
        fileNameQueue = nil;
        index = 0;
    }
}
- (void)play{
    
    if (!player.playing){
        [self play:0];
    }
}

- (void)play:(int)i {
    if(fileNameQueue != nil){
        player = [[AVAudioPlayer alloc]initWithData:[NSData dataWithContentsOfFile:[fileNameQueue objectAtIndex:i]] error:nil];
//        player = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:[fileNameQueue objectAtIndex:i] ofType:nil]] error:nil];
        player.delegate = self;
        [player setVolume:1];
        [player prepareToPlay];
        [player play];
        index++;
    }
}

- (void)stop {
    if (player.playing) [player stop];
}

- (void)dealloc {
    fileNameQueue = nil;
    player = nil;
}
@end
