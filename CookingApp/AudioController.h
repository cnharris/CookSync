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
    AVAudioPlayer *marimbaPlayer;
}

@property (nonatomic, retain) AVAudioPlayer *bellPlayer;
@property (nonatomic, retain) AVAudioPlayer *marimbaPlayer;

- (void)setupSounds;
- (void)playBell;
- (void)playMarimba;
- (void)stopBell;
- (void)stopMarimba;

@end
