//
//  RORMultiPlaySound.h
//  WalkFun
//
//  Created by leon on 13-12-28.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface RORMultiPlaySound : NSObject <AVAudioPlayerDelegate> {
    AVAudioPlayer* player;
    NSMutableArray* fileNameQueue;
    int index;
}
- (void)addFileNametoQueue:(NSString*)fileName;
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;
- (void)play;
- (void)stop;

@end