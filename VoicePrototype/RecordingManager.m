//
//  RecordingManager.m
//  VoicePrototype
//
//  Created by Bastion on 8/18/13.
//  Copyright (c) 2013 FlowTelligent. All rights reserved.
//

#import "RecordingManager.h"
#import <AVFoundation/AVFoundation.h>

@interface RecordingManager ()

@property(nonatomic,retain)AVAudioRecorder *audioRecorder;
@property(nonatomic,retain)NSURL *currentURL;
@property(nonatomic,retain)NSError *error;

- (NSURL*)generateNewURL;
- (AVAudioRecorder*)createAudioRecorder;

@end

@implementation RecordingManager

@synthesize audioRecorder;
@synthesize currentURL;
@synthesize error;

+ (id)sharedManager {
    static RecordingManager *sharedRecordingManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedRecordingManager = [[self alloc] init];
    });
    return sharedRecordingManager;
}

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}


- (void)startRecording
{
    if (audioRecorder.recording) {
        [audioRecorder stop];
    }
    
    [self createAudioRecorder];
    
    [audioRecorder record];
}

- (void)stopRecording
{
    if (audioRecorder.recording) {
        [audioRecorder stop];
    }
}

- (void)pauseRecording
{
    if (audioRecorder.recording) {
        [audioRecorder pause];
    }
}

- (void)cancelRecording
{
    if (audioRecorder.recording) {
        [audioRecorder deleteRecording];
    }
}

- (NSTimeInterval)recordingTime
{
    return audioRecorder.currentTime;
}

- (BOOL)isRecording
{
    return audioRecorder.recording;
}

- (NSError*)error
{
    return error;
}

- (NSURL*)url
{
    return currentURL;
}

#pragma mark - Private Methods

- (NSURL*)generateNewURL
{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = dirPaths[0];
    
    NSUInteger currentTime = [[NSDate date] timeIntervalSince1970];
    NSString *fileName = [NSString stringWithFormat:@"Recording-%i.caf", currentTime];
    
    NSString *soundFilePath = [docsDir stringByAppendingPathComponent:fileName];
    
    currentURL = [NSURL fileURLWithPath:soundFilePath];
    
    return currentURL;
}

- (AVAudioRecorder*)createAudioRecorder
{
    NSError *localError = nil;
    NSDictionary *settings = [NSDictionary
                              dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:AVAudioQualityMin], AVEncoderAudioQualityKey,
                              [NSNumber numberWithInt:16], AVEncoderBitRateKey,
                              [NSNumber numberWithInt: 2], AVNumberOfChannelsKey,
                              [NSNumber numberWithFloat:44100.0], AVSampleRateKey,
                              nil];
    audioRecorder = [[AVAudioRecorder alloc] initWithURL:[self generateNewURL] settings:settings error:&localError];
    
    if (localError) {
        error = localError;
        return nil;
    }
    
    return audioRecorder;
}

@end
