//
//  RecordingHistoryViewController.m
//  VoicePrototype
//
//  Created by Bastion on 8/22/13.
//  Copyright (c) 2013 FlowTelligent. All rights reserved.
//

#import "RecordingHistoryViewController.h"
#import <CoreData/CoreData.h>
#import "RecordingDatabase.h"
#import "Recording.h"
#import "PlaybackManager.h"
#import <QuartzCore/QuartzCore.h>
#import "PlayerViewController.h"

@interface RecordingHistoryViewController ()

@property(nonatomic,retain)NSArray * recordings;
@property(nonatomic,retain)RecordingDatabase *recordingDatabase;
@property(nonatomic,retain)UITableView *tableView;
@property(nonatomic,retain)UIButton *recordButton;
@property(nonatomic,retain)PlayerViewController *playerViewController;

- (void)didClickRecordButton:(id)sender;

@end

@implementation RecordingHistoryViewController

@synthesize recordings;
@synthesize recordingDatabase;
@synthesize tableView;
@synthesize recordButton;
@synthesize playerViewController;

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
    
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 50.0f, 320.0f, 430.0f)];
    tableView.dataSource = self;
    tableView.delegate = self;
    
    [self.view addSubview:tableView];
    
    
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 50.0f)];
    headerView.backgroundColor = [UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:237.0f/255.0f alpha:1.0f];
    [self.view addSubview:headerView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 49.0f, 320.0f, 1.0f)];
    lineView.backgroundColor = [UIColor colorWithRed:104.0f/255.0f green:119.0f/255.0f blue:142.0f/255.0f alpha:1.0F];
    [headerView addSubview:lineView];
    
    
    recordButton = [[UIButton alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 100.0f, 30.0f)];
    recordButton.backgroundColor = [UIColor redColor];
    [recordButton setTitle:@"Record" forState:UIControlStateNormal];
    recordButton.layer.cornerRadius = 5.0f;
    [recordButton addTarget:self action:@selector(didClickRecordButton:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:recordButton];
    
    /*
    
    cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(210.0f, 10.0f, 100.0f, 30.0f)];
    cancelButton.backgroundColor = [UIColor colorWithRed:104.0f/255.0f green:119.0f/255.0f blue:142.0f/255.0f alpha:1.0F];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    cancelButton.layer.cornerRadius = 5.0f;
    [cancelButton addTarget:self action:@selector(didClickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    [promptView addSubview:cancelButton];
    */
    
    
    
    
    recordingDatabase = [[RecordingDatabase alloc] init];
    
    // fetch all assets from sqlite
    NSFetchRequest * recordingFetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Recording"];
    NSSortDescriptor *sortByIndex = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    [recordingFetchRequest setSortDescriptors:[NSArray arrayWithObject:sortByIndex]];
    recordings = [recordingDatabase.managedObjectContext executeFetchRequest:recordingFetchRequest error:nil];
    
    [self.tableView reloadData];
    
    
    
    
    playerViewController = [[PlayerViewController alloc] init];
    CGRect frame = playerViewController.view.frame;
    frame.size.height = 100.0f;
    frame.origin.y = 480.0f - frame.size.height;
    playerViewController.view.frame = frame;
    
    [self.view addSubview:playerViewController.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - DataSource
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return recordings.count;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    Recording *recording = [recordings objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm a"];
    
    
    NSDateFormatter* dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"MM/dd/YY"];
    
    cell.textLabel.text = [dateFormatter stringFromDate:recording.date];
    cell.detailTextLabel.text = [dateFormatter2 stringFromDate:recording.date];
    return cell;
}

#pragma mark - Delegate
- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Recording *recording = [recordings objectAtIndex:indexPath.row];
    
    [[PlaybackManager sharedManager] playWithURL:[NSURL URLWithString:recording.url]];
}


#pragma mark - 

- (void)didClickRecordButton:(id)sender
{
    [[PlaybackManager sharedManager] stop];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
