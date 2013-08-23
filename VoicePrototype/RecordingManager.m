//
//  RecordingManager.m
//  VoicePrototype
//
//  Created by Bastion on 8/18/13.
//  Copyright (c) 2013 FlowTelligent. All rights reserved.
//

#import "RecordingManager.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreData/CoreData.h>
#import "Recording.h"
#import "RecordingDatabase.h"

@interface RecordingManager ()

@property(nonatomic,retain)AVAudioRecorder *audioRecorder;
@property(nonatomic,retain)NSURL *currentURL;
@property(nonatomic,retain)NSError *error;
@property(nonatomic)NSTimeInterval pausedTime;
@property(nonatomic,retain)RecordingDatabase *recordingDatabase;

- (NSURL*)generateNewURL;
- (AVAudioRecorder*)createAudioRecorder;

@end

@implementation RecordingManager

@synthesize audioRecorder;
@synthesize currentURL;
@synthesize error;
@synthesize pausedTime;
@synthesize recordingDatabase;

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
        recordingDatabase = [[RecordingDatabase alloc] init];
    }
    return self;
}


- (void)startRecording
{
    if (audioRecorder.recording) {
        [audioRecorder stop];
    }
    
    [self createAudioRecorder];
    
    NSLog(@"audioRecorder.currentTime = %f", pausedTime);
    if (pausedTime) {
        [audioRecorder recordAtTime: pausedTime];
    }
    else {
        [audioRecorder record];
    }
}

- (void)stopRecording
{
    NSTimeInterval duration = [self recordingTime];
    //if (audioRecorder.recording) {
        [audioRecorder stop];
        pausedTime = 0.0f;
    //}
    
    Recording * recording = [NSEntityDescription insertNewObjectForEntityForName: @"Recording" inManagedObjectContext: self.recordingDatabase.managedObjectContext];
    recording.url = [currentURL absoluteString];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    recording.title = [dateFormatter stringFromDate:[NSDate date]];
 
    recording.duration = [NSNumber numberWithDouble:duration];
    recording.date = [NSDate date];
    
    [self.recordingDatabase.managedObjectContext save:nil];
}

- (void)pauseRecording
{
    if (audioRecorder.recording) {
        pausedTime = [self recordingTime];
        [audioRecorder pause];
    }
}

- (void)cancelRecording
{
    //if (audioRecorder.recording) {
        [audioRecorder stop];
        [audioRecorder deleteRecording];
        pausedTime = 0.0f;
    //}
}

- (NSTimeInterval)recordingTime
{
    return pausedTime + audioRecorder.currentTime;
}

-(NSString *)recordingTimeString
{
    NSTimeInterval interval = [self recordingTime];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    
    return formattedDate;
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
