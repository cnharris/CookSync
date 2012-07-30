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
@synthesize boxingPlayerStart;
@synthesize boxingPlayerEnd;

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
    boxingPlayerStart = [[AVAudioPlayer alloc] initWithContentsOfURL:boxingUrl error:&bxerror];
    boxingPlayerEnd = [[AVAudioPlayer alloc] initWithContentsOfURL:boxingUrl error:&bxerror];
	bellPlayer.numberOfLoops = 0;
    boxingPlayerStart.numberOfLoops = 0;
    boxingPlayerEnd.numberOfLoops = 2;
    
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

- (void)playBoxingStart
{
    [boxingPlayerStart play];
}

- (void)playBoxingEnd
{
    [boxingPlayerEnd play];
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
