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
@property(nonatomic,retain)UIProgressView *durationProgressView;
@property(nonatomic,retain)UILabel *durationPastLabel;
@property(nonatomic,retain)UILabel *durationLeftLabel;
@property(nonatomic,retain)NSTimer *durationTimer;

- (void)handleNotification:(NSNotification*)notification;
- (void)handleTimerCallback;

@end

@implementation PlayerViewController

@synthesize playButton;
@synthesize pauseButton;
@synthesize durationProgressView;
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
    
    playButton = [[UIButton alloc] initWithFrame:CGRectMake(30.0f, 20.0f, 16.0f, 18.0f)];
    [playButton setImage:playImage forState:UIControlStateNormal];
    [self.view addSubview:playButton];
    
    pauseButton = [[UIButton alloc] initWithFrame:CGRectMake(30.0f, 20.0f, 10.0f, 16.0f)];
    [pauseButton setImage:pauseImage forState:UIControlStateNormal];
    pauseButton.hidden = YES;
    [self.view addSubview:pauseButton];
    
    
    durationProgressView = [[UIProgressView alloc] initWithFrame:CGRectMake(60.0f, 25.0f, 230.0f, 30.0f)];
    durationProgressView.progressTintColor = [UIColor redColor];
    durationProgressView.progress = 0.0f;
    [self.view addSubview:durationProgressView];
    
    
    
    durationLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.0f, 32.0f, 50.0f, 20.0f)];
    durationLeftLabel.textColor = [UIColor colorWithRed:104.0f/255.0f green:119.0f/255.0f blue:142.0f/255.0f alpha:1.0F];
    durationLeftLabel.backgroundColor = [UIColor clearColor];
    durationLeftLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    durationLeftLabel.text = @"00:00";
    durationLeftLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:durationLeftLabel];
    
    
    durationPastLabel = [[UILabel alloc] initWithFrame:CGRectMake(250.0f, 32.0f, 50.0f, 20.0f)];
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
        durationTimer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(handleTimerCallback) userInfo:nil repeats:YES];
        [durationTimer fire];
    }
    else if (notification.name==PlaybackManagerDidStopPlayingNotification) {

    }
    else if (notification.name==PlaybackManagerDidPausePlayingNotification) {
    
    }
}

#pragma mark - Timer Callback
- (void)handleTimerCallback
{
    PlaybackManager *playbackManager = [PlaybackManager sharedManager];
    if ([playbackManager isPlaying]) {
        durationLeftLabel.text = [playbackManager durationLeft];
        durationPastLabel.text = [playbackManager durationPast];
        durationProgressView.progress = [playbackManager currentTime]/[playbackManager duration];
    }
    else {
        durationProgressView.progress = 0.0f;
        [durationTimer invalidate];
    }
}

@end
