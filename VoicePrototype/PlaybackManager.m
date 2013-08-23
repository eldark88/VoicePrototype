//
//  PlaybackManager.m
//  VoicePrototype
//
//  Created by Bastion on 8/19/13.
//  Copyright (c) 2013 FlowTelligent. All rights reserved.
//

#import "PlaybackManager.h"
#import <AVFoundation/AVFoundation.h>

NSString * const PlaybackManagerDidStartPlayingNotification = @"PlaybackManagerDidStartPlayingNotification";
NSString * const PlaybackManagerDidStopPlayingNotification = @"PlaybackManagerDidStopPlayingNotification";
NSString * const PlaybackManagerDidPausePlayingNotification = @"PlaybackManagerDidPausePlayingNotification";

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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PlaybackManagerDidStartPlayingNotification object:nil];
}

- (void)pause
{
    if (audioPlayer.playing) {
        [audioPlayer pause];
        [[NSNotificationCenter defaultCenter] postNotificationName:PlaybackManagerDidPausePlayingNotification object:nil];
    }
}

- (void)stop
{
    if (audioPlayer.playing) {
        [[NSNotificationCenter defaultCenter] postNotificationName:PlaybackManagerDidStopPlayingNotification object:nil];
        [audioPlayer stop];
    }
}

- (NSTimeInterval)currentTime
{
    return audioPlayer.currentTime;
}

- (NSTimeInterval)duration
{
    return audioPlayer.duration;
}

- (NSString*)durationPast
{
    //NSLog(@"currentTime = %f, duration = %f", self.currentTime, self.duration);
    NSDate *durationDate = [NSDate dateWithTimeIntervalSince1970:self.currentTime];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"mm:ss"];
    return [dateFormatter stringFromDate:durationDate];
}

- (NSString*)durationLeft
{
    NSDate *durationDate = [NSDate dateWithTimeIntervalSince1970:self.duration-self.currentTime];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"mm:ss"];
    return [dateFormatter stringFromDate:durationDate];
}

- (BOOL)isPlaying
{
    return audioPlayer.playing;
}

@end
