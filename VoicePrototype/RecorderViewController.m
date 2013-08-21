//
//  RecorderViewController.m
//  VoicePrototype
//
//  Created by Bastion on 8/18/13.
//  Copyright (c) 2013 FlowTelligent. All rights reserved.
//

#import "RecorderViewController.h"
#import "RecordingManager.h"
#import "PlaybackManager.h"

@interface RecorderViewController ()

@property(nonatomic,retain)UIButton *recordButton;
@property(nonatomic,retain)UIButton *playButton;
- (void)didClickRecordButton:(id)sender;
- (void)didClickPlayButton:(id)sender;

@end

@implementation RecorderViewController

@synthesize recordButton;
@synthesize playButton;

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
    
    recordButton = [[UIButton alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 100.0f, 40.0f)];
    [recordButton setTitle:@"Record" forState:UIControlStateNormal];
    [recordButton addTarget:self action:@selector(didClickRecordButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:recordButton];
    
    playButton = [[UIButton alloc] initWithFrame:CGRectMake(150.0f, 10.0f, 100.0f, 40.0f)];
    [playButton setTitle:@"Play" forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(didClickPlayButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playButton];
}

- (void)didClickRecordButton:(id)sender
{
    NSLog(@"didClickRecordButton sender = %@", sender);
    
    if (![[RecordingManager sharedManager] isRecording]) {
        [[RecordingManager sharedManager] startRecording];
        [recordButton setTitle:@"Recording" forState:UIControlStateNormal];
    }
    else {
        [[RecordingManager sharedManager] stopRecording];
        [recordButton setTitle:@"Record" forState:UIControlStateNormal];
    }
}

- (void)didClickPlayButton:(id)sender
{
    NSLog(@"didClickPlayButton sender = %@", sender);
    
    [[PlaybackManager sharedManager] playWithURL:[[RecordingManager sharedManager] url]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
