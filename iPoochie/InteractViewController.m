//
//  InteractViewController.m
//  iPoochie
//
//  Created by marta wilgan on 4/17/13.
//  Copyright (c) 2013 NYU. All rights reserved.
//

#import "InteractViewController.h"
#import "EatViewController.h"
#import "PetViewController.h"
#import "PlayViewController.h"
#import "WalkViewController.h"
#import "AppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>

@interface InteractViewController ()

@end

@implementation InteractViewController
@synthesize points;
@synthesize state;
@synthesize pointsLabel;
@synthesize healthLabel;
@synthesize energyLabel;
@synthesize happinessLabel;
@synthesize talkLabel;
@synthesize infoPercLabel;
@synthesize infoTypeLabel;
@synthesize healthImageView;
@synthesize energryImageView;
@synthesize happinessImageView;
@synthesize petImageView;
@synthesize talkImageView;
@synthesize infoArrowImageView;
@synthesize infoBubbleImageView;
@synthesize timingDate;


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
    
    // Update the health, energy, and happiness levels
    [self updateHealth];
    [self updateEnergy];
    [self updateHappiness];
    
    // Find the state of the pet
    state = [gameData objectForKey: @"petState"];
    
    // Show animation based on the pet state
    if([state isEqualToString:@"awake"])
    {
        [self animateAwake];
    }
    if([state isEqualToString:@"asleep"])
    {
        [self animateSleeping];
    }
    
    timingDate = [NSDate date]; // set start date
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Update health on screen to reflect current values in plist
- (void) updateHealth
{
    // Grab health from plist through app delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *gameData = [[NSMutableDictionary alloc]
                                     initWithContentsOfFile: [appDelegate gameDataPath]];    
    NSNumber *health = [gameData objectForKey:@"health"];
    
    // Update the health label text
    healthLabel.text =
    [NSString stringWithFormat:@"%@%@", health, @"%"];
    
    
    
    // Update the health image view
    NSString *imageName = [self barsImageName: [health intValue]];
    healthImageView.image = [UIImage imageNamed:imageName];

}

// Update energy on screen to reflect current values in plist
- (void) updateEnergy
{
    // Grab health from plist through app delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *gameData = [[NSMutableDictionary alloc]
                                     initWithContentsOfFile: [appDelegate gameDataPath]];
    NSNumber *energy = [gameData objectForKey:@"energy"];
    
    // Update the health label text
    energyLabel.text =
    [NSString stringWithFormat:@"%@%@", energy, @"%"];
    
    // Update the energy image view
    NSString *imageName = [self barsImageName: [energy intValue]];
    energryImageView.image = [UIImage imageNamed:imageName];
}

// Update happiness on screen to reflect current values in plist
- (void) updateHappiness
{
    // Grab health from plist through app delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *gameData = [[NSMutableDictionary alloc]
                                     initWithContentsOfFile: [appDelegate gameDataPath]];
    NSNumber *happiness = [gameData objectForKey:@"happiness"];
    
    // Update the happiness label text
    happinessLabel.text =
    [NSString stringWithFormat:@"%@%@", happiness, @"%"];
    
    // Update the happiness image view
    NSString *imageName = [self barsImageName: [happiness intValue]];
    happinessImageView.image = [UIImage imageNamed:imageName];
}

// Return appropriate bar image name for percentage
- (NSString*) barsImageName: (int) number
{
    NSString *name;
    
    if(number >= 0 && number < 11)
    {
        name = @"bars1.png";
    }
    
    if(number > 10 && number < 21)
    {
        name = @"bars2.png";
    }
    
    if(number > 20 && number < 31)
    {
        name = @"bars3.png";
    }
    
    if(number > 30 && number < 41)
    {
        name = @"bars4.png";
    }
    
    if(number > 40 && number < 51)
    {
        name = @"bars5.png";
    }
    
    if(number > 50 && number < 61)
    {
        name = @"bars6.png";
    }
    
    if(number > 60 && number < 71)
    {
        name = @"bars7.png";
    }
    
    if(number > 70 && number < 81)
    {
        name = @"bars8.png";
    }
    
    if(number > 80 && number < 91)
    {
        name = @"bars9.png";
    }
    
    if(number > 90 && number < 101)
    {
        name = @"bars10.png";
    }
    
    return name;
}

//
-(IBAction) buttonPressed:(id)sender
{    
    // Grab button title
    NSString *buttonType = [sender titleForState:UIControlStateNormal];
    
    
    // Find the state of the pet in plist through app delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *gameData = [[NSMutableDictionary alloc]
                                     initWithContentsOfFile: [appDelegate gameDataPath]];
    state = [gameData objectForKey: @"petState"];
    
    // Perform action based on button pressed
    if ([buttonType isEqualToString: @"sleep"])
    {
        // Animate sleeping after timer
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self
                                       selector:@selector(goingToSleep:)
                                       userInfo:nil repeats:NO];
        // Check to see if awake
        if([state isEqualToString:@"awake"])
        {
            // Update energy and put to sleep
            [self levelForTimeInState:@"awake" andType:@"energy"];
            [self animateGoingToSleep];
            [self changeStateTo:@"asleep"];
        }
        else
        {
            [self animateAngry]; // already asleep!
            talkLabel.text = @"I AM ASLEEP!";
            talkImageView.hidden = NO;
            talkImageView.image = [UIImage imageNamed:@"talkBubble.png"];
            
            // Show changes made to happiness if any
            [self levelForType:@"happiness"
                     direction:@"down"
                 intervalStart:10
                   intervalEnd:30];
        }
        
    }
    if ([buttonType isEqualToString: @"wake up"])
    {
        // Animate awake after timer
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self
                                       selector:@selector(wakingUp:)
                                       userInfo:nil repeats:NO];
        // Check to see if asleep
        if([state isEqualToString:@"asleep"])
        {
            // Update energy and wake up
            [self levelForTimeInState:@"asleep" andType:@"energy"];
            [self animateWakingUp];
            [self changeStateTo:@"awake"];
        }
        else
        {
            [self animateAngry]; // already awake!
            talkLabel.text = @"I AM AWAKE!";
            talkImageView.hidden = NO;
            talkImageView.image = [UIImage imageNamed:@"talkBubble.png"];
            
            // Show changes made to happiness if any
            [self levelForType:@"happiness"
                     direction:@"down"
                 intervalStart:10
                   intervalEnd:20];
        }
        
    }

}

-(IBAction)goToEatView: (id)sender
{
    EatViewController *eatViewController = [[EatViewController alloc] init];
    [self presentViewController:eatViewController animated:YES completion:NULL];
}

-(IBAction)goToPetView: (id)sender
{
    PetViewController *petViewController = [[PetViewController alloc] init];
    [self presentViewController:petViewController animated:YES completion:NULL];
}

-(IBAction)goToPlayView: (id)sender
{
    PlayViewController *playViewController = [[PlayViewController alloc] init];
    [self presentViewController:playViewController animated:YES completion:NULL];
}

-(IBAction)goToWalkView: (id)sender
{
    WalkViewController *walkViewController = [[WalkViewController alloc] init];
    [self presentViewController:walkViewController animated:YES completion:NULL];
}

// Create animation for puppy to appear to be awake
-(void) animateAwake
{
    petImageView.animationImages =  [NSArray arrayWithObjects:
                                     [UIImage imageNamed:@"blinking4A.png"],
                                     [UIImage imageNamed:@"blinking4B.png"],
                                     [UIImage imageNamed:@"blinking4C.png"],
                                     [UIImage imageNamed:@"blinking4D.png"],
                                     [UIImage imageNamed:@"blinking4E.png"],
                                     [UIImage imageNamed:@"blinking4F.png"],
                                     [UIImage imageNamed:@"blinking4G.png"],
                                     [UIImage imageNamed:@"blinking4H.png"],
                                     [UIImage imageNamed:@"blinking4I.png"],
                                     [UIImage imageNamed:@"blinking4J.png"],
                                     [UIImage imageNamed:@"blinking4J.png"],
                                     [UIImage imageNamed:@"blinking4J.png"],
                                     [UIImage imageNamed:@"blinking4J.png"],
                                     [UIImage imageNamed:@"blinking4J.png"],
                                     [UIImage imageNamed:@"blinking4J.png"],
                                     [UIImage imageNamed:@"blinking4J.png"],
                                     [UIImage imageNamed:@"blinking4J.png"],
                                     [UIImage imageNamed:@"blinking4J.png"],
                                     [UIImage imageNamed:@"blinking4J.png"],
                                     [UIImage imageNamed:@"blinking4J.png"],
                                     [UIImage imageNamed:@"blinking4J.png"],
                                     [UIImage imageNamed:@"blinking4J.png"],
                                     [UIImage imageNamed:@"blinking4J.png"],
                                     [UIImage imageNamed:@"blinking4I.png"],
                                     [UIImage imageNamed:@"blinking4J.png"],
                                     [UIImage imageNamed:@"blinking4J.png"],
                                     [UIImage imageNamed:@"blinking4J.png"],
                                     [UIImage imageNamed:@"blinking4J.png"],
                                     [UIImage imageNamed:@"blinking4J.png"],
                                     [UIImage imageNamed:@"blinking4J.png"],
                                     [UIImage imageNamed:@"blinking4J.png"],
                                     [UIImage imageNamed:@"blinking4J.png"],
                                     [UIImage imageNamed:@"blinking4E.png"],
                                     [UIImage imageNamed:@"blinking4F.png"],
                                     [UIImage imageNamed:@"blinking4G.png"],
                                     [UIImage imageNamed:@"blinking4H.png"],
                                     [UIImage imageNamed:@"blinking4J.png"],
                                     [UIImage imageNamed:@"blinking4J.png"],
                                     [UIImage imageNamed:@"blinking4J.png"],
                                     [UIImage imageNamed:@"blinking4J.png"],
                                     [UIImage imageNamed:@"blinking4J.png"],
                                     [UIImage imageNamed:@"blinking4J.png"],
                                     [UIImage imageNamed:@"blinking4J.png"],
                                     [UIImage imageNamed:@"blinking4J.png"],
                                     [UIImage imageNamed:@"blinking4J.png"],
                                     [UIImage imageNamed:@"blinking4J.png"],
                                     [UIImage imageNamed:@"blinking4J.png"],
                                     [UIImage imageNamed:@"blinking4J.png"],
                                     [UIImage imageNamed:@"blinking4J.png"],
                                     [UIImage imageNamed:@"blinking4J.png"],
                                     [UIImage imageNamed:@"blinking4J.png"],
                                     [UIImage imageNamed:@"blinking4J.png"],
                                     [UIImage imageNamed:@"blinking4J.png"],
                                     [UIImage imageNamed:@"blinking4J.png"],
                                     [UIImage imageNamed:@"blinking4J.png"],
                                     [UIImage imageNamed:@"blinking4J.png"],
                                     [UIImage imageNamed:@"blinking4E.png"],
                                     [UIImage imageNamed:@"blinking4F.png"],
                                     [UIImage imageNamed:@"blinking4G.png"],
                                     [UIImage imageNamed:@"blinking4J.png"],
                                     [UIImage imageNamed:@"blinking4J.png"],
                                     [UIImage imageNamed:@"blinking4J.png"],
                                     [UIImage imageNamed:@"blinking4J.png"],
                                     nil];
    
    
    petImageView.animationDuration = 16.0;
    petImageView.animationRepeatCount = 0;
    [petImageView startAnimating];

}

// Create animation for puppy to appear to be sleeping
-(void) animateSleeping
{
    petImageView.animationImages =  [NSArray arrayWithObjects:
                                     [UIImage imageNamed:@"sleepingA.png"],
                                     [UIImage imageNamed:@"sleepingB.png"],
                                     [UIImage imageNamed:@"sleepingC.png"],
                                     [UIImage imageNamed:@"sleepingD.png"],
                                     [UIImage imageNamed:@"sleepingE.png"],
                                     [UIImage imageNamed:@"sleepingE.png"],
                                     [UIImage imageNamed:@"sleepingE.png"],
                                     [UIImage imageNamed:@"sleepingF.png"],
                                     [UIImage imageNamed:@"sleepingG.png"],
                                     [UIImage imageNamed:@"sleepingH.png"],
                                     [UIImage imageNamed:@"sleepingI.png"],
                                     [UIImage imageNamed:@"sleepingJ.png"],
                                     [UIImage imageNamed:@"sleepingJ.png"],
                                     [UIImage imageNamed:@"sleepingJ.png"],
                                     [UIImage imageNamed:@"sleepingJ.png"],
                                     [UIImage imageNamed:@"sleepingJ.png"],
                                     [UIImage imageNamed:@"sleepingK.png"],
                                     [UIImage imageNamed:@"sleepingL.png"],
                                     [UIImage imageNamed:@"sleepingM.png"],
                                     [UIImage imageNamed:@"sleepingN.png"],
                                     [UIImage imageNamed:@"sleepingO.png"],
                                     [UIImage imageNamed:@"sleepingP.png"],
                                     [UIImage imageNamed:@"sleepingP.png"],
                                     [UIImage imageNamed:@"sleepingP.png"],
                                     [UIImage imageNamed:@"sleepingP.png"],
                                     [UIImage imageNamed:@"sleepingP.png"],
                                     [UIImage imageNamed:@"sleepingP.png"],
                                     nil];
    
    
    petImageView.animationDuration = 8.0;
    petImageView.animationRepeatCount = 0;
    [petImageView startAnimating];
    
}

// Create animation for puppy to appear to be going to sleep
-(void) animateGoingToSleep
{
    petImageView.animationImages =  [NSArray arrayWithObjects:
                                    [UIImage imageNamed:@"goingToSleep1.png"],
                                    [UIImage imageNamed:@"goingToSleep2.png"],
                                    [UIImage imageNamed:@"goingToSleep3.png"],
                                    [UIImage imageNamed:@"goingToSleep4.png"],
                                    [UIImage imageNamed:@"goingToSleep5.png"],
                                    [UIImage imageNamed:@"goingToSleep6.png"], 
                                     nil];
    
    
    petImageView.animationDuration = 3.0;
    petImageView.animationRepeatCount = 1;
    [petImageView startAnimating];
}

// Create animation for puppy to appear to be waking up
-(void) animateWakingUp
{
    petImageView.animationImages =  [NSArray arrayWithObjects:
                                     [UIImage imageNamed:@"goingToSleep6.png"],
                                     [UIImage imageNamed:@"goingToSleep5.png"],
                                     [UIImage imageNamed:@"goingToSleep4.png"],
                                     [UIImage imageNamed:@"goingToSleep3.png"],
                                     [UIImage imageNamed:@"goingToSleep2.png"],
                                     [UIImage imageNamed:@"goingToSleep1.png"],
                                     nil];
    
    
    petImageView.animationDuration = 3.0;
    petImageView.animationRepeatCount = 1;
    [petImageView startAnimating];
}

// Create animation for puppy to appear to be angry
-(void) animateAngry
{
    // Play angry barking sound
    NSString *path = [ [NSBundle mainBundle] pathForResource:@"angry_bark" ofType:@"wav"];
    SystemSoundID theSound;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &theSound);
    AudioServicesPlaySystemSound (theSound);
    
    // Create the animation
    petImageView.animationImages =  [NSArray arrayWithObjects:
                                     [UIImage imageNamed:@"angry1.png"],
                                     [UIImage imageNamed:@"angry2.png"],
                                     [UIImage imageNamed:@"angry1.png"],
                                     [UIImage imageNamed:@"angry2.png"],
                                     [UIImage imageNamed:@"angry1.png"],
                                     [UIImage imageNamed:@"angry2.png"],
                                     [UIImage imageNamed:@"angry1.png"],
                                     [UIImage imageNamed:@"angry2.png"],
                                     [UIImage imageNamed:@"angry1.png"],
                                     [UIImage imageNamed:@"angry2.png"],
                                     nil];
    
    
    petImageView.animationDuration = 1.0;
    petImageView.animationRepeatCount = 1;
    [petImageView startAnimating];
}

// Wait then animate the puppy being awake
-(void)wakingUp:(NSTimer*)inTimer
{
    [inTimer invalidate];
    inTimer = nil;
    
    // Wake up and stop being angry if angry
    [self animateAwake];
    talkLabel.text = @" ";
    talkImageView.hidden = YES;
    
}

// Wait then animate the puppy being asleep
-(void)goingToSleep:(NSTimer*)inTimer
{
    [inTimer invalidate];
    inTimer = nil;
    
    // Sleep and stop being angry if angry
    [self animateSleeping];
    talkLabel.text = @" ";
    talkImageView.hidden = YES;
}

// Wait then clear the level type info
-(void)clearInfo:(NSTimer*)inTimer
{
    [inTimer invalidate];
    inTimer = nil;
    
    // Clear the info
    infoTypeLabel.text = @"";
    infoPercLabel.text = @"";
    infoBubbleImageView.hidden = YES;
    infoArrowImageView.hidden = YES;
}

// Update state variable and plist
-(void) changeStateTo:(NSString*) theState
{
    // Update state
    state = theState;
    
    // Create the app delegate
    AppDelegate *appDelegate =
        (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *gameData = [[NSMutableDictionary alloc]
                                     initWithContentsOfFile: [appDelegate gameDataPath]];
    // Update the plist
    [gameData setObject:state
                 forKey:@"petState"];
    [gameData writeToFile:[appDelegate gameDataPath] atomically:NO];

}

-(void) levelForType:(NSString*) type
           direction:(NSString*) direction
       intervalStart:(int) start
         intervalEnd:(int) end
{
    // Create the app delegate
    AppDelegate *appDelegate =
    (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *gameData = [[NSMutableDictionary alloc]
                                     initWithContentsOfFile: [appDelegate gameDataPath]];
    NSNumber *percentage = [gameData objectForKey:type];
    int percentageInt = [percentage intValue];
    
    Boolean showChange = YES;   // change to false if no change is not possible
    
    // Calculate random number for change on interval
    int change = (arc4random() % (end - start)) + start;
    
    NSLog(@"Type: %@ Direction: %@ Start: %i End: %i Change: %i Current Percentage: %i Plus Change: %i",
          type, direction, start, end, change, percentageInt, (percentageInt + change));
    
    // Do checks for up
    if([direction isEqualToString:@"up"])
    {
        // Percentage is already at 100
        if(percentageInt == 100)
        {
            NSLog(@"\nPercentage already 100");
            showChange = NO;
        }
        
        // Make sure percentage + change does not go over 100
        if((percentageInt + change) > 100)
        {
            NSLog(@"\nPercentage + change > 100");
            change = 100 - percentageInt;
            percentageInt = 100;
        }
        else
        {
            percentageInt += change;
        }
    }

    // Do checks for down
    if([direction isEqualToString:@"down"])
    {
        // Percentage is already 0
        if(percentageInt == 0)
        {
            NSLog(@"Percentage already 0");
            showChange = NO;
        }
        
        // Make sure percentage - change does not go below 0
        if((percentageInt - change) < 0)
        {
            NSLog(@"\nPercentage - change < 0");
            change = percentageInt;
            percentageInt = 0;
        }
        else
        {
            percentageInt -= change;
        }
    }
    
    // Show changes made and update plist
    if(showChange == YES)
    {
        // Show labels
        infoTypeLabel.text =
            [NSString stringWithFormat:@"%@", type];
        infoPercLabel.text =
            [NSString stringWithFormat:@"%i%@", change, @"%"];
    
        /*
         * Bubble for direction, green for up, red for down
         * Arrow for direction, purple for up, red for down
         */
        if([direction isEqualToString:@"up"])
        {
            infoBubbleImageView.image =
                [UIImage imageNamed:@"greenBubble.png"];
            infoArrowImageView.image =
            [UIImage imageNamed:@"purpleArrow.png"];
        }
        else if([direction isEqualToString:@"down"])
        {
            infoBubbleImageView.image =
                [UIImage imageNamed:@"redBubble.png"];
            infoArrowImageView.image =
                [UIImage imageNamed:@"redArrow.png"];
        }
    
        // Show image views
        infoBubbleImageView.hidden = NO;
        infoArrowImageView.hidden = NO;
        
        // Play sound
        [self soundForDirection:direction];
    
        // Update the plist values
        percentage = [NSNumber numberWithInt:percentageInt];
        [gameData setObject:percentage
                     forKey:type];
        [gameData writeToFile:[appDelegate gameDataPath] atomically:NO];
        
        
        // Update stat information
        if([type isEqualToString:@"health"])
        {
            [self updateHealth];
        }
        if([type isEqualToString:@"energy"])
        {
            [self updateEnergy];
        }
        if([type isEqualToString:@"happiness"])
        {
            [self updateHappiness];
        }
        
        // Clear labels and imageViews after timer
        [NSTimer scheduledTimerWithTimeInterval:3.0 target:self
                                       selector:@selector(clearInfo:)
                                       userInfo:nil repeats:NO];
    }
}

// Play sound for direction up or down
-(void) soundForDirection: (NSString *)direction
{
    NSString *path; // path for sound
    
    // Set the path for direction
    if([direction isEqualToString:@"up"])
    {
        // Path for up
        path = [ [NSBundle mainBundle] pathForResource:@"up" ofType:@"wav"];
    }
    if([direction isEqualToString:@"down"])
    {
        // Path for down
        path = [ [NSBundle mainBundle] pathForResource:@"down" ofType:@"wav"];
    }
    
    // Play sound
    SystemSoundID theSound;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &theSound);
    AudioServicesPlaySystemSound (theSound);
}

-(void) levelForTimeInState:(NSString *) theState andType:(NSString *) type
{
    // Find how much time pet was in state
    NSNumber *time = [NSNumber numberWithDouble:
        [[NSDate date] timeIntervalSinceDate:self.timingDate]];
    
    if([theState isEqualToString:@"awake"])
    {
        int end  = [time intValue] + 5; // end on interval
        
        // Show changes made to type if any
        [self levelForType:type
                 direction:@"down"
             intervalStart:0
               intervalEnd:end];
    }
    
    if([theState isEqualToString:@"asleep"])
    {
        int end  = [time intValue] + 10; // end on interval

        // Show changes made to type if any
        [self levelForType:type
                 direction:@"up"
             intervalStart:0
               intervalEnd:end];
    }
    
    timingDate = [NSDate date]; // set start date for next state
}

@end
