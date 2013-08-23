//
//  PlaybackManager.h
//  VoicePrototype
//
//  Created by Bastion on 8/19/13.
//  Copyright (c) 2013 FlowTelligent. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const PlaybackManagerDidStartPlayingNotification;
extern NSString * const PlaybackManagerDidStopPlayingNotification;
extern NSString * const PlaybackManagerDidPausePlayingNotification;

@interface PlaybackManager : NSObject

+ (id)sharedManager;
- (void)playWithURL:(NSURL*)url;
- (void)pause;
- (void)stop;
- (NSTimeInterval)currentTime;
- (NSTimeInterval)duration;
- (NSString*)durationPast;
- (NSString*)durationLeft;
- (BOOL)isPlaying;

@end
