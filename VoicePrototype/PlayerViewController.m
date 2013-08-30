//
//  PlayerViewController.m
//  VoicePrototype
//
//  Created by Eldar Khalyknazarov on 23.08.13.
//  Copyright (c) 2013 FlowTelligent. All rights reserved.
//

#import "PlayerViewController.h"
#import "PlaybackManager.h"

@interface PlayerViewController ()

@property(nonatomic,retain)UIButton *playButton;
@property(nonatomic,retain)UIButton *pauseButton;
@property(nonatomic,retain)UISlider *durationSlider;
@property(nonatomic,retain)UILabel *durationPastLabel;
@property(nonatomic,retain)UILabel *durationLeftLabel;
@property(nonatomic,retain)NSTimer *durationTimer;

- (void)handleNotification:(NSNotification*)notification;
- (void)handleTimerCallback;
- (void)handlePlayButtonClick:(id)sender;
- (void)handlePauseButtonClick:(id)sender;
- (void)handleDurationSliderTouchUp:(id)sender;
- (void)handleDurationSliderTouchDown:(id)sender;

- (void)startDurationTimer;
- (void)stopDurationTimer;

- (void)play;
- (void)pause;

@end

@implementation PlayerViewController

@synthesize playButton;
@synthesize pauseButton;
@synthesize durationSlider;
@synthesize durationPastLabel;
@synthesize durationLeftLabel;
@synthesize durationTimer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIImage *pauseImage = [UIImage imageNamed:@"Images/Player/Pause"];
    UIImage *playImage = [UIImage imageNamed:@"Images/Player/Play"];
    
    playButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 60.0f, 60.0f)];
    [playButton setImage:playImage forState:UIControlStateNormal];
    playButton.imageEdgeInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    [playButton addTarget:self action:@selector(handlePlayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playButton];
    
    pauseButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 60.0f, 60.0f)];
    [pauseButton setImage:pauseImage forState:UIControlStateNormal];
    pauseButton.imageEdgeInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    [pauseButton addTarget:self action:@selector(handlePauseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    pauseButton.hidden = YES;
    [self.view addSubview:pauseButton];
    
    durationSlider = [[UISlider alloc] initWithFrame:CGRectMake(60.0f, 14.0f, 230.0f, 30.0f)];
    durationSlider.minimumTrackTintColor = [UIColor redColor];
    durationSlider.thumbTintColor = [UIColor redColor];
    [durationSlider addTarget:self action:@selector(handleDurationSliderTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [durationSlider addTarget:self action:@selector(handleDurationSliderTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:durationSlider];
    
    
    
    durationLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(53.0f, 34.0f, 50.0f, 20.0f)];
    durationLeftLabel.textColor = [UIColor colorWithRed:104.0f/255.0f green:119.0f/255.0f blue:142.0f/255.0f alpha:1.0F];
    durationLeftLabel.backgroundColor = [UIColor clearColor];
    durationLeftLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    durationLeftLabel.text = @"00:00";
    durationLeftLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:durationLeftLabel];
    
    
    durationPastLabel = [[UILabel alloc] initWithFrame:CGRectMake(247.0f, 34.0f, 50.0f, 20.0f)];
    durationPastLabel.textColor = [UIColor colorWithRed:104.0f/255.0f green:119.0f/255.0f blue:142.0f/255.0f alpha:1.0F];
    durationPastLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    durationPastLabel.backgroundColor = [UIColor clearColor];
    durationPastLabel.textAlignment = NSTextAlignmentCenter;
    durationPastLabel.text = @"00:00";
    [self.view addSubview:durationPastLabel];
    
    
    
    self.view.backgroundColor = [UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:237.0f/255.0f alpha:1.0f];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 1.0f)];
    lineView.backgroundColor = [UIColor colorWithRed:104.0f/255.0f green:119.0f/255.0f blue:142.0f/255.0f alpha:1.0F];
    [self.view addSubview:lineView];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:PlaybackManagerDidStartPlayingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:PlaybackManagerDidStopPlayingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:PlaybackManagerDidPausePlayingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:PlaybackManagerDidFinishPlayingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:PlaybackManagerErrorPlayingNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Notification Handler

- (void)handleNotification:(NSNotification*)notification
{
    if (notification.name==PlaybackManagerDidStartPlayingNotification) {
        [self startDurationTimer];
        
        playButton.hidden = YES;
        pauseButton.hidden = NO;
    }
    else if (notification.name==PlaybackManagerDidStopPlayingNotification) {
        playButton.hidden = NO;
        pauseButton.hidden = YES;
    }
    else if (notification.name==PlaybackManagerDidPausePlayingNotification) {
        playButton.hidden = YES;
        pauseButton.hidden = NO;
    }
    else if (notification.name==PlaybackManagerDidFinishPlayingNotification) {
        playButton.hidden = NO;
        pauseButton.hidden = YES;
        durationSlider.value = 0.0f;
        
        [self stopDurationTimer];
    }
    else if (notification.name==PlaybackManagerErrorPlayingNotification) {
        playButton.hidden = NO;
        pauseButton.hidden = YES;
        durationSlider.value = 0.0f;
        
        [self stopDurationTimer];
    }
}

#pragma mark - Timer Callback
- (void)handleTimerCallback
{
    PlaybackManager *playbackManager = [PlaybackManager sharedManager];
    if ([playbackManager isPlaying]) {
        durationLeftLabel.text = [playbackManager durationLeftLabel];
        durationPastLabel.text = [NSString stringWithFormat:@"-%@",[playbackManager durationPastLabel] ];
        float value = [playbackManager currentTime]/[playbackManager duration];
        [durationSlider setValue:value animated:YES];
    }
    else {
        [self stopDurationTimer];
    }
}

#pragma mark - Play/Pause button handlers

- (void)handlePlayButtonClick:(id)sender
{
    [self play];
}

- (void)handlePauseButtonClick:(id)sender
{
    [self pause];
}

- (void)handleDurationSliderTouchUp:(id)sender
{
    PlaybackManager *playbackManager = [PlaybackManager sharedManager];
 
    if (durationSlider.value==1) {
        playbackManager.currentTime = 0.0f;
        durationSlider.value = 0.0f;
        [self pause];
    }
    else {
        NSTimeInterval time = durationSlider.value * playbackManager.duration;
        playbackManager.currentTime = time;
        [self play];
        NSLog(@"time = %f", time);
    }
    
    
    
    //NSLog(@"value = %f, time = %f", durationSlider.value, time);
}

- (void)handleDurationSliderTouchDown:(id)sender
{
    [self stopDurationTimer];
}

#pragma mark - Duration Timer

- (void)startDurationTimer
{
    if (durationTimer) {
        [durationTimer invalidate];
    }
    
    durationTimer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(handleTimerCallback) userInfo:nil repeats:YES];
    [durationTimer fire];
}

- (void)stopDurationTimer
{
    [durationTimer invalidate];
}

#pragma mark - Play/Pause

- (void)play
{
    PlaybackManager *playbackManager = [PlaybackManager sharedManager];
    
    NSLog(@"currentTime = %f, duration = %f", playbackManager.currentTime, playbackManager.duration);
    if (playbackManager.currentTime>=playbackManager.duration) {
        playbackManager.currentTime = 0.1f;
    }
    else {
        [playbackManager play];
    }
    
    [self startDurationTimer];
    
    pauseButton.hidden = NO;
    playButton.hidden = YES;
}

- (void)pause
{
    [self stopDurationTimer];
    
    [[PlaybackManager sharedManager] pause];
    pauseButton.hidden = YES;
    playButton.hidden = NO;
}

@end
