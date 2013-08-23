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
#import <QuartzCore/QuartzCore.h>
#import "RecordingHistoryViewController.h"

@interface RecorderViewController ()

@property(nonatomic,retain)UIButton *recordButton;
@property(nonatomic,retain)UIButton *playButton;
@property(nonatomic,retain)UILabel *durationLabel;
@property(nonatomic,retain)UIButton *saveButton;
@property(nonatomic,retain)UIButton *cancelButton;
@property(nonatomic,retain)UIView *promptView;
@property(nonatomic,retain)NSTimer *durationTimer;
@property(nonatomic,retain)UIButton *historyButton;

- (void)didClickRecordButton:(id)sender;
- (void)didClickPlayButton:(id)sender;
- (void)didClickSaveButton:(id)sender;
- (void)didClickCancelButton:(id)sender;
- (void)didClickHistoryButton:(id)sender;

- (void)showPromptView;
- (void)hidePromptView;

- (void)durationTimerCallback;

@end

@implementation RecorderViewController

@synthesize recordButton;
@synthesize playButton;
@synthesize durationLabel;
@synthesize saveButton;
@synthesize cancelButton;
@synthesize promptView;
@synthesize durationTimer;
@synthesize historyButton;

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
    /*
    playButton = [[UIButton alloc] initWithFrame:CGRectMake(150.0f, 10.0f, 100.0f, 40.0f)];
    [playButton setTitle:@"Play" forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(didClickPlayButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playButton];
    */
    
    historyButton = [[UIButton alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 100.0f, 30.0f)];
    historyButton.backgroundColor = [UIColor colorWithRed:104.0f/255.0f green:119.0f/255.0f blue:142.0f/255.0f alpha:1.0F];
    [historyButton setTitle:@"History" forState:UIControlStateNormal];
    historyButton.layer.cornerRadius = 5.0f;
    [historyButton addTarget:self action:@selector(didClickHistoryButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:historyButton];
    
    
    durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 150.0f, self.view.frame.size.width, 60.0f)];
    durationLabel.textAlignment = NSTextAlignmentCenter;
    durationLabel.textColor = [UIColor colorWithRed:104.0f/255.0f green:119.0f/255.0f blue:142.0f/255.0f alpha:1.0F];
    durationLabel.text = [[RecordingManager sharedManager] recordingTimeString];
    durationLabel.font = [UIFont boldSystemFontOfSize:60.0f];
    durationLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:durationLabel];
    
    
    recordButton = [[UIButton alloc] initWithFrame:CGRectMake(60.0f, 220.0f, 200.0f, 50.0f)];
    [recordButton setTitle:@"Record" forState:UIControlStateNormal];
    [recordButton addTarget:self action:@selector(didClickRecordButton:) forControlEvents:UIControlEventTouchUpInside];
    recordButton.backgroundColor = [UIColor redColor];
    recordButton.layer.cornerRadius = 15.0f;
    recordButton.titleLabel.font = [UIFont boldSystemFontOfSize:32.0];
    [self.view addSubview:recordButton];
    
    
    
    self.view.backgroundColor = [UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:237.0f/255.0f alpha:1.0f];
    
    
    
    promptView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 410.0f, 320.0f, 50.0f)];
    [self.view addSubview:promptView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 1.0f)];
    lineView.backgroundColor = [UIColor colorWithRed:104.0f/255.0f green:119.0f/255.0f blue:142.0f/255.0f alpha:1.0F];
    [promptView addSubview:lineView];
    
    
    saveButton = [[UIButton alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 100.0f, 30.0f)];
    saveButton.backgroundColor = [UIColor redColor];
    [saveButton setTitle:@"Save" forState:UIControlStateNormal];
    saveButton.layer.cornerRadius = 5.0f;
    [saveButton addTarget:self action:@selector(didClickSaveButton:) forControlEvents:UIControlEventTouchUpInside];
    [promptView addSubview:saveButton];
    
    
    cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(210.0f, 10.0f, 100.0f, 30.0f)];
    cancelButton.backgroundColor = [UIColor colorWithRed:104.0f/255.0f green:119.0f/255.0f blue:142.0f/255.0f alpha:1.0F];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    cancelButton.layer.cornerRadius = 5.0f;
    [cancelButton addTarget:self action:@selector(didClickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    [promptView addSubview:cancelButton];
    
    [self hidePromptView];
    
    
    
    
}

- (void)didClickRecordButton:(id)sender
{
    NSLog(@"didClickRecordButton duration = %@", [[RecordingManager sharedManager] recordingTimeString]);
    
    if (![[RecordingManager sharedManager] isRecording]) {
        [[RecordingManager sharedManager] startRecording];
        [recordButton setTitle:@"Pause" forState:UIControlStateNormal];
        [self hidePromptView];
        
        durationTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(durationTimerCallback) userInfo:nil repeats:YES];
        [durationTimer fire];
    }
    else {
        [durationTimer invalidate];
        
        [[RecordingManager sharedManager] pauseRecording];
        [recordButton setTitle:@"Record" forState:UIControlStateNormal];
        [self showPromptView];
    }
}

- (void)didClickPlayButton:(id)sender
{
    NSLog(@"didClickPlayButton sender = %@", sender);
    
    [[PlaybackManager sharedManager] playWithURL:[[RecordingManager sharedManager] url]];
}

- (void)didClickSaveButton:(id)sender
{
    [[RecordingManager sharedManager] stopRecording];
    [durationTimer invalidate];
    durationLabel.text = [[RecordingManager sharedManager] recordingTimeString];
    
    [self hidePromptView];
}

- (void)didClickCancelButton:(id)sender
{
    [[RecordingManager sharedManager] cancelRecording];
    [durationTimer invalidate];
    durationLabel.text = [[RecordingManager sharedManager] recordingTimeString];
    
    [self hidePromptView];
}

- (void)showPromptView
{
    if (!promptView.hidden) {
        return;
    }
    
    promptView.hidden = NO;
    
    [UIView animateWithDuration:0.3f animations:^{
        CGRect frame = promptView.frame;
        frame.origin.y -= 50.0;
        promptView.frame = frame;
    } completion:^(BOOL finished) {
    }];
}

- (void)hidePromptView
{
    if (promptView.hidden) {
        return;
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        CGRect frame = promptView.frame;
        frame.origin.y += 50.0;
        promptView.frame = frame;
    } completion:^(BOOL finished) {
        promptView.hidden = YES;
    }];
}

- (void)didClickHistoryButton:(id)sender
{
    RecordingHistoryViewController * recordingHistoryViewController = [[RecordingHistoryViewController alloc] init];
    [self presentViewController:recordingHistoryViewController animated:YES completion:^{
        
    }];
}

- (void)durationTimerCallback
{
    durationLabel.text = [[RecordingManager sharedManager] recordingTimeString];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
