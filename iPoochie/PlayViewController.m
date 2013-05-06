//
//  PlayViewController.m
//  iPoochie
//
//  Created by marta wilgan on 4/29/13.
//  Copyright (c) 2013 NYU. All rights reserved.
//

#import "PlayViewController.h"
#import "playView.h"
#import "AppDelegate.h"

#define kUpdateInterval     (1.0f/60.0f)

@interface PlayViewController ()

@end

@implementation PlayViewController
@synthesize points;
@synthesize pointsLabel;
@synthesize motionManager;
@synthesize play;
@synthesize timeInView;

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
    // Do any additional setup after loading the view from its nib.
    
    self.motionManager = [[CMMotionManager alloc] init];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    motionManager.accelerometerUpdateInterval = kUpdateInterval;
    [motionManager startAccelerometerUpdatesToQueue:queue withHandler:
     ^(CMAccelerometerData *accerlerometerData, NSError *error)
     {
         [(playView*)self.play setAcceleration:accerlerometerData.acceleration];
         [self.play performSelectorOnMainThread:@selector(update) withObject:nil waitUntilDone:NO];
         [self performSelectorOnMainThread:@selector(updatePoints) withObject:nil waitUntilDone:NO];
         
     }];
}

-(void) viewDidUnload
{
    [super viewDidUnload];
    self.points = nil;
    self.pointsLabel = nil;
    self.motionManager = nil;
    self.backButton = nil;
    self.play = nil;
    self.backButton = nil;
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Grab points from plist through app delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *gameData = [[NSMutableDictionary alloc]
                                     initWithContentsOfFile: [appDelegate gameDataPath]];
    points = [gameData objectForKey:@"points"];
    
    // Update the points label text
    pointsLabel.text =
    [NSString stringWithFormat:@"Points: %@", points];
    
    // Start the time in view
    timeInView = [NSDate date];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) updatePoints
{
    // Keep track of points shown 
    NSNumber *oldPoints = points;
    
    // Grab points from plist through app delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *gameData = [[NSMutableDictionary alloc]
                                     initWithContentsOfFile: [appDelegate gameDataPath]];
    points = [gameData objectForKey:@"points"];
    
    // Update the points label text if necessary
    if([oldPoints intValue] < [points intValue])
    {
        pointsLabel.text =
            [NSString stringWithFormat:@"Points: %@", points];
    }

}

// Go back to interactViewController
-(IBAction)goBack: (id)sender
{
    // Find how much time was spent in view
    NSNumber *time = [NSNumber numberWithDouble:
                      [[NSDate date] timeIntervalSinceDate:self.timeInView]];
    
    // Update lastViewName to play and save time spent in view
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *gameData = [[NSMutableDictionary alloc]
                                     initWithContentsOfFile: [appDelegate gameDataPath]];
    [gameData setObject:@"play" forKey:@"lastViewName"];
    [gameData setObject:time
                 forKey:@"lastViewTime"];
    
    [gameData writeToFile:[appDelegate gameDataPath] atomically:NO];
    
    // go back
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
