//
//  RecordingManager.h
//  VoicePrototype
//
//  Created by Bastion on 8/18/13.
//  Copyright (c) 2013 FlowTelligent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordingManager : NSObject

+ (id)sharedManager;
- (void)startRecording;
- (void)stopRecording;
- (void)pauseRecording;
- (void)cancelRecording;
- (NSTimeInterval)recordingTime;
- (NSString*)recordingTimeString;
- (BOOL)isRecording;
- (NSError*)error;
- (NSURL*)url;

@end
