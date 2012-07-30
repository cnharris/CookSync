//
//  AudioController.h
//  CookingApp
//
//  Created by Christopher Harris on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioController : NSObject
{
    AVAudioPlayer *bellPlayer;
    AVAudioPlayer *boxingPlayer;
}

@property (nonatomic, retain) AVAudioPlayer *bellPlayer;
@property (nonatomic, retain) AVAudioPlayer *boxingPlayerStart;
@property (nonatomic, retain) AVAudioPlayer *boxingPlayerEnd;

- (void)setupSounds;
- (void)playBell;
- (void)playBoxingStart;
- (void)playBoxingEnd;
- (void)stopBell;
- (void)stopBoxing;

@end
