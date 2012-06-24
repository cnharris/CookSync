//
//  AudioController.m
//  CookingApp
//
//  Created by Christopher Harris on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AudioController.h"

@implementation AudioController

@synthesize bellPlayer;
@synthesize boxingPlayer;

- (id)init
{
    [self setupSounds];
    return self;
}

- (void)setupSounds
{
    NSURL *bellUrl = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/bell.mp3", [[NSBundle mainBundle] resourcePath]]];
    NSURL *boxingUrl = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/boxingbell.mp3", [[NSBundle mainBundle] resourcePath]]];
    
	NSError *berror;
    NSError *bxerror;
	bellPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:bellUrl error:&berror];
    boxingPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:boxingUrl error:&bxerror];
	bellPlayer.numberOfLoops = 0;
    boxingPlayer.numberOfLoops = 2;
    
	if (bellPlayer == nil){
		NSLog(@"%@",[berror description]);
	} else {
		[bellPlayer prepareToPlay];
    }
    
    if (boxingPlayer == nil){
		NSLog(@"%@",[bxerror description]);
    } else {
		[boxingPlayer prepareToPlay];
    }
}

- (void)playBell
{
    [bellPlayer play];
}

- (void)playBoxing
{
    [boxingPlayer play];
}

- (void)stopBell
{
    [bellPlayer stop];
}

- (void)stopBoxing
{
    [boxingPlayer stop];
}

@end
