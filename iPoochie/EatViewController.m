//
//  EatViewController.m
//  iPoochie
//
//  Created by marta wilgan on 4/29/13.
//  Copyright (c) 2013 NYU. All rights reserved.
//

#import "EatViewController.h"
#import "AppDelegate.h"

@interface EatViewController ()

@end

@implementation EatViewController
@synthesize points;
@synthesize pointsLabel;
@synthesize bowlImageView;
@synthesize petImageView;
@synthesize motionManager;
@synthesize fullBowl;
@synthesize full;
@synthesize empty;
@synthesize shakes;
@synthesize infoBubbleImageView;
@synthesize infoBubbleLabel;

int gIndex = 0;

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
    
    // Set the images
    self.empty = [UIImage imageNamed:@"Shake0.gif"];
    self.full = [UIImage imageNamed:@"Shake9.gif"];
    
    // Make bowl empty
    bowlImageView.image = empty;
    
    // Create the shakes array
    NSArray *shakesArray = [NSArray arrayWithObjects:
                            [UIImage imageNamed:@"Shake1.gif"],
                            [UIImage imageNamed:@"Shake2.gif"],
                            [UIImage imageNamed:@"Shake3.gif"],
                            [UIImage imageNamed:@"Shake4.gif"],
                            [UIImage imageNamed:@"Shake5.gif"],
                            [UIImage imageNamed:@"Shake6.gif"],
                            [UIImage imageNamed:@"Shake7.gif"],
                            [UIImage imageNamed:@"Shake8.gif"],
                            [UIImage imageNamed:@"Shake9.gif"],
                            nil];
    self.shakes = shakesArray;
    
    gIndex = 0; // current index of the shakes array
    
    // Shakes motion - fill up bowl while shake detected
    self.motionManager = [[CMMotionManager alloc] init];
    motionManager.accelerometerUpdateInterval = kUpdateInterval;
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [motionManager startAccelerometerUpdatesToQueue:queue
                                        withHandler:
     ^(CMAccelerometerData *accelerometerData, NSError *error){
         if(error)
         {
             [motionManager stopAccelerometerUpdates];
         }
         else
         {
             if(!fullBowl)
             {
                 CMAcceleration acceleration = accelerometerData.acceleration;
                 
                 if(acceleration.x > kAccelerationThreshold
                    || acceleration.y > kAccelerationThreshold
                    || acceleration.z > kAccelerationThreshold)
                 {
                     // Change image for shake
                     if(gIndex <= 8 )
                     {
                         // Make bubble hidden
                         if(gIndex == 0)
                         {
                             [self performSelectorOnMainThread:@selector(hideBubble:) withObject:nil waitUntilDone:NO];
                         }
                         
                         // Change bowl image view
                         [bowlImageView performSelectorOnMainThread:@selector(setImage:)
                                                         withObject:shakes[gIndex]
                                                      waitUntilDone:NO];
                         gIndex++;
                     }
                     else
                     {
                         fullBowl = YES;
                         [bowlImageView performSelectorOnMainThread:@selector(setImage:)
                                                         withObject:full
                                                      waitUntilDone:NO];
                     }
                         
                 }
                 
             }
         }
     }];
    
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidUnload
{
    [super viewDidUnload];
    self.bowlImageView = nil;
    self.motionManager = nil;
    self.empty = nil;
    self.full = nil;
    
}

// Hide bubble image and label
-(void)hideBubble:(NSString *)string
{
    [self.infoBubbleImageView setHidden:YES];
    [self.infoBubbleLabel setHidden:YES];
}

// Go back to interactViewController
-(IBAction)goBack: (id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Let the puppy eat if bowl is full
-(IBAction)eat:(id)sender
{
    if(fullBowl == YES)
    {
        [self animateEating];
    
        // Clear bowl after timer
        [NSTimer scheduledTimerWithTimeInterval:3.0 target:self
                                   selector:@selector(clearBowl:)
                                   userInfo:nil repeats:NO];
    }
    else
    {
        // Create alert for not enough points to purchase
        NSString *message = @"You must shake the screen to make the bowl full first";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
}

// Clear the bowl
-(void)clearBowl:(NSTimer*)inTimer
{
    [inTimer invalidate];
    inTimer = nil;
    
    bowlImageView.image = empty;
    fullBowl = NO;
    gIndex = 0;
}


// Create animation for puppy to appear to be getting ready to eat
-(void) animateGoingToEat
{
    petImageView.animationImages =  [NSArray arrayWithObjects:
                                     [UIImage imageNamed:@"goingToEat1.png"],
                                     [UIImage imageNamed:@"goingToEat2.png"],
                                     nil];
    
    petImageView.animationDuration = 1.0;
    petImageView.animationRepeatCount = 1;
    [petImageView startAnimating];
    
}

// Create animation for puppy to appear to be eating
-(void) animateEating
{
    petImageView.animationImages =  [NSArray arrayWithObjects:
                                     [UIImage imageNamed:@"goingToEat1.png"],
                                     [UIImage imageNamed:@"goingToEat2.png"],
                                     [UIImage imageNamed:@"eating1.png"],
                                     [UIImage imageNamed:@"eating2.png"],
                                     [UIImage imageNamed:@"eating3.png"],
                                     [UIImage imageNamed:@"eating4.png"],
                                     [UIImage imageNamed:@"eating5.png"],
                                     [UIImage imageNamed:@"eating6.png"],
                                     [UIImage imageNamed:@"goingToEat2.png"],
                                     [UIImage imageNamed:@"goingToEat1.png"],
                                     nil];
    
    
    petImageView.animationDuration = 3.0;
    petImageView.animationRepeatCount = 1;
    [petImageView startAnimating];
}

// Create animation for puppy to appear to stop eating
-(void) animateStopEating
{
    petImageView.animationImages =  [NSArray arrayWithObjects:
                                     [UIImage imageNamed:@"goingToEat2.png"],
                                     [UIImage imageNamed:@"goingToEat1.png"],
                                     nil];
    
    petImageView.animationDuration = 1.0;
    petImageView.animationRepeatCount = 1;
    [petImageView startAnimating];
}


@end
