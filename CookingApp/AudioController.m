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
@synthesize marimbaPlayer;

- (id)init
{
    [self setupSounds];
    return self;
}

- (void)setupSounds
{
    NSURL *bellUrl = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/bell.mp3", [[NSBundle mainBundle] resourcePath]]];
    NSURL *marimbaUrl = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/marimba.mp3", [[NSBundle mainBundle] resourcePath]]];
    
	NSError *berror;
    NSError *merror;
	bellPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:bellUrl error:&berror];
    marimbaPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:marimbaUrl error:&merror];
	bellPlayer.numberOfLoops = 0;
    marimbaPlayer.numberOfLoops = 0;
    
	if (bellPlayer == nil){
		NSLog(@"%@",[berror description]);
	} else {
		[bellPlayer prepareToPlay];
    }
    
    if (marimbaPlayer == nil){
		NSLog(@"%@",[merror description]);
    } else {
		[marimbaPlayer prepareToPlay];
    }
}

- (void)playBell
{
    [bellPlayer play];
}

- (void)playMarimba
{
    [marimbaPlayer play];
}

- (void)stopBell
{
    [bellPlayer stop];
}

- (void)stopMarimba
{
    [marimbaPlayer stop];
}



@end
