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
NSString * const PlaybackManagerDidFinishPlayingNotification = @"PlaybackManagerDidFinishPlayingNotification";
NSString * const PlaybackManagerErrorPlayingNotification = @"PlaybackManagerErrorPlayingNotification";

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
    audioPlayer.delegate = self;
    error = localError;
    
    [audioPlayer play];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PlaybackManagerDidStartPlayingNotification object:nil];
}

- (void)play
{
    if (!audioPlayer.playing) {
        [audioPlayer play];
    }
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

- (void)setCurrentTime:(NSTimeInterval)currentTime
{
    audioPlayer.currentTime = currentTime;
}

- (NSTimeInterval)duration
{
    return audioPlayer.duration;
}

- (NSString*)durationPastLabel
{
    //NSLog(@"currentTime = %f, duration = %f", self.currentTime, self.duration);
    NSDate *durationDate = [NSDate dateWithTimeIntervalSince1970:self.currentTime];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"mm:ss"];
    return [dateFormatter stringFromDate:durationDate];
}

- (NSString*)durationLeftLabel
{
    NSDate *durationDate = [NSDate dateWithTimeIntervalSince1970:self.duration-self.currentTime];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"mm:ss"];
    return [dateFormatter stringFromDate:durationDate];
}

- (NSString*)durationLabel
{
    NSDate *durationDate = [NSDate dateWithTimeIntervalSince1970:self.duration];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"mm:ss"];
    return [dateFormatter stringFromDate:durationDate];
}

- (BOOL)isPlaying
{
    return audioPlayer.playing;
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [[NSNotificationCenter defaultCenter] postNotificationName:PlaybackManagerDidFinishPlayingNotification object:nil];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    [[NSNotificationCenter defaultCenter] postNotificationName:PlaybackManagerErrorPlayingNotification object:nil];
}

@end
