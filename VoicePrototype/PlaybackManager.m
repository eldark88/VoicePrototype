//
//  PlaybackManager.m
//  VoicePrototype
//
//  Created by Bastion on 8/19/13.
//  Copyright (c) 2013 FlowTelligent. All rights reserved.
//

#import "PlaybackManager.h"
#import <AVFoundation/AVFoundation.h>

@interface PlaybackManager ()

@property(nonatomic,retain)AVAudioPlayer *audioPlayer;
@property(nonatomic,retain)NSURL *audioURL;
@property(nonatomic,retain)NSError *error;

@end

@implementation PlaybackManager

@synthesize audioPlayer;
@synthesize audioURL;
@synthesize error;

+ (id)sharedManager {
    static PlaybackManager *sharedPlaybackManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPlaybackManager = [[self alloc] init];
    });
    return sharedPlaybackManager;
}

- (void)playWithURL:(NSURL*)url
{
    if (audioPlayer.playing) {
        [audioPlayer stop];
    }
    
    NSError *localError = nil;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&localError];
    error = localError;
    
    [audioPlayer play];
}

- (void)pause
{
    if (audioPlayer.playing) {
        [audioPlayer pause];
    }
}

- (void)stop
{
    if (audioPlayer.playing) {
        [audioPlayer stop];
    }
}

@end
