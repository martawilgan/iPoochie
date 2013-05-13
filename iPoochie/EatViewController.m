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
@synthesize timeInView;
@synthesize pointsLabel;
@synthesize bagsLabel;
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
int gBagsOfChow = 0;

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
    //self.motionManager = [[CMMotionManager alloc] init];
    
     AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.motionManager = [appDelegate motionManager];
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
                     // Change image for shake if chow available
                     if(gIndex <= 8 && gBagsOfChow > 0)
                     {
                         // Make bubble hidden
                         if(gIndex == 0)
                         {
                             [self performSelectorOnMainThread:@selector(hideBubble) withObject:nil waitUntilDone:NO];
                         }
                         
                         // Change bowl image view
                         [bowlImageView performSelectorOnMainThread:@selector(setImage:)
                                                         withObject:shakes[gIndex]
                                                      waitUntilDone:NO];
                         gIndex++;
                     }
                     else if(gIndex > 8 && gBagsOfChow > 0)
                     {
                         fullBowl = YES;
                         [self performSelectorOnMainThread:@selector(showInfoBubbleWith:)
                                                withObject:@"Bowl is full"
                                             waitUntilDone:NO];
                         
                     }
                     else if(gBagsOfChow == 0)
                     {
                         [self performSelectorOnMainThread:@selector(showNoChowAlert:) withObject:nil waitUntilDone:NO];
                     }
                         
                 }
                 
             }
         }
     }];
    
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Grab points and number of bags of chow from plist through app delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *gameData = [[NSMutableDictionary alloc]
                                     initWithContentsOfFile: [appDelegate gameDataPath]];
    NSMutableDictionary *itemsData = [[NSMutableDictionary alloc]
                                     initWithContentsOfFile: [appDelegate itemsDataPath]];    
    points = [gameData objectForKey:@"points"];    
    NSArray *amounts = [itemsData objectForKey:@"amounts"];
    NSNumber *bags = [amounts objectAtIndex:0];
    gBagsOfChow = [bags intValue];
    
    // Update the labels text
    pointsLabel.text =
        [NSString stringWithFormat:@"Points: %@", points];
    bagsLabel.text =
        [NSString stringWithFormat:@"Bags of chow: %i", gBagsOfChow];
    
    // Start the time in view
    timeInView = [NSDate date];
    
    [self showInfoBubble]; // show the info bubble
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

-(void)showInfoBubble
{
    [self.infoBubbleImageView setHidden:NO];
    [self.infoBubbleLabel setHidden:NO];
    
    infoBubbleImageView.image = [UIImage imageNamed:@"orangeBubble.png"];
    
    if(gBagsOfChow == 0)
    {
        infoBubbleLabel.text = @"Buy bag of chow first!";
    }
    else
    {
        infoBubbleLabel.text = @"Shake screen to fill bowl";
    }
}

-(void)useBag
{
    // Decrement bags of chow
    gBagsOfChow--;
    
    // Grab the amounts array from plist
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *itemsData = [[NSMutableDictionary alloc]
                                      initWithContentsOfFile: [appDelegate itemsDataPath]];
    NSMutableArray *amounts = [itemsData objectForKey:@"amounts"];
    
    // Create NSNumber object with current number of bags of chow
    NSNumber *bags = [NSNumber numberWithInt:gBagsOfChow];
    
    // Replace old number of bags of chow
    [amounts replaceObjectAtIndex:0 withObject:bags];
    
    // Write back to plist
    [itemsData setObject:amounts
                  forKey:@"amounts"];
    [itemsData writeToFile:[appDelegate itemsDataPath] atomically:NO];
    
    // Update bags of chow label
    bagsLabel.text =
        [NSString stringWithFormat:@"Bags of chow: %i", gBagsOfChow];
    
    // Show info bubble
    [self showInfoBubble];
}

-(void)showInfoBubbleWith:(NSString *) message
{
    [self.infoBubbleImageView setHidden:NO];
    [self.infoBubbleLabel setHidden:NO];
    
    infoBubbleLabel.text = [NSString stringWithFormat:@"%@", message];
}

// Hide bubble image and label
-(void)hideBubble
{
    [self.infoBubbleImageView setHidden:YES];
    [self.infoBubbleLabel setHidden:YES];
}

-(void)showNoChowAlert:(NSString *)string
{
    // Create alert for no bags of chow available
    NSString *message = @"You must buy more bags of chow from the store before you can feed your pet.";
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry! No more chow!"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
    [self playAlertSound];
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
    [gameData setObject:@"eat" forKey:@"lastViewName"];
    [gameData setObject:time
                 forKey:@"lastViewTime"];
    
    [gameData writeToFile:[appDelegate gameDataPath] atomically:NO];
    
    // go back
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Update energry by 5%, if possible
-(void) updateEnergy
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *gameData = [[NSMutableDictionary alloc]
                                     initWithContentsOfFile: [appDelegate gameDataPath]];
    NSNumber *energy = [gameData objectForKey:@"energy"];

    int percentage = [energy intValue];
    percentage += 5;
    
    // Make sure not more than 100
    if(percentage > 100)
    {
        percentage = 100;
    }
    
    energy = [NSNumber numberWithInt:percentage];
    
    // Write back to plist
    [gameData setObject:energy
                 forKey:@"energy"];
    [gameData writeToFile:[appDelegate gameDataPath] atomically:NO];
}

// Let the puppy eat if bowl is full
-(IBAction)eat:(id)sender
{
    if(fullBowl == YES)
    {
        [self hideBubble];
        [self playHappyBarkSound];
        [self animateEating];
        
        // Update energry
        [self updateEnergy];
    
        // Clear bowl after timer and update number of bags avaialable
        [NSTimer scheduledTimerWithTimeInterval:3.0 target:self
                                   selector:@selector(clearBowl:)
                                   userInfo:nil repeats:NO];
    }
    else
    {
        // Create alert message
        NSString *message;
        
        if(gBagsOfChow > 0)
        {
            message = @"You must shake the screen to make the bowl full first";
        }
        else if(gBagsOfChow == 0)
        {
            message = @"You have no chow! You must buy a bag of chow from the store first";
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        [self playAlertSound];
    }
}

-(void) playAlertSound
{
    // Play sound
    NSString *path = [ [NSBundle mainBundle] pathForResource:@"alert" ofType:@"wav"];
    SystemSoundID theSound;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &theSound);
    AudioServicesPlaySystemSound (theSound);
}

-(void) playHappyBarkSound
{
    // Play sound
    NSString *path = [ [NSBundle mainBundle] pathForResource:@"happy_bark" ofType:@"wav"];
    SystemSoundID theSound;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &theSound);
    AudioServicesPlaySystemSound (theSound);
}

// Clear the bowl and update number of bags available
-(void)clearBowl:(NSTimer*)inTimer
{
    [inTimer invalidate];
    inTimer = nil;
    
    bowlImageView.image = empty;
    fullBowl = NO;
    gIndex = 0;
    [self useBag];
    [self showInfoBubble];
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

@end
