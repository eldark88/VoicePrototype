//
//  PlaybackManager.h
//  VoicePrototype
//
//  Created by Bastion on 8/19/13.
//  Copyright (c) 2013 FlowTelligent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

extern NSString * const PlaybackManagerDidStartPlayingNotification;
extern NSString * const PlaybackManagerDidStopPlayingNotification;
extern NSString * const PlaybackManagerDidPausePlayingNotification;
extern NSString * const PlaybackManagerDidFinishPlayingNotification;
extern NSString * const PlaybackManagerErrorPlayingNotification;

@interface PlaybackManager : NSObject <AVAudioPlayerDelegate>

+ (id)sharedManager;
- (void)playWithURL:(NSURL*)url;
- (void)play;
- (void)pause;
- (void)stop;
- (NSTimeInterval)currentTime;
- (void)setCurrentTime:(NSTimeInterval)currentTime;
- (NSTimeInterval)duration;
- (NSString*)durationPastLabel;
- (NSString*)durationLeftLabel;
- (NSString*)durationLabel;
- (BOOL)isPlaying;

@end
