//
//  InteractViewController.m
//  iPoochie
//
//  Created by marta wilgan on 4/17/13.
//  Copyright (c) 2013 NYU. All rights reserved.
//

#import "InteractViewController.h"

@interface InteractViewController ()

@end

@implementation InteractViewController
@synthesize points;
@synthesize state;
@synthesize timingDate;
@synthesize energyTimer;
@synthesize appDelegate;
@synthesize itemsData;
@synthesize gameData;
@synthesize pointsLabel;
@synthesize healthLabel;
@synthesize energyLabel;
@synthesize happinessLabel;
@synthesize talkLabel;
@synthesize infoTypeLabel;
@synthesize infoPercLabel;
@synthesize healthImageView;
@synthesize energryImageView;
@synthesize happinessImageView;
@synthesize petImageView;
@synthesize talkImageView;
@synthesize infoArrowImageView;
@synthesize infoBubbleImageView;
@synthesize welcomeImageView;


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
    
    [self hideWelcome]; // Hide welcome image
    
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Set the appDelegate and data
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    gameData =[[NSMutableDictionary alloc]
               initWithContentsOfFile: [appDelegate gameDataPath]];
    
    // Grab points from plist through app delegate
    points = [gameData objectForKey:@"points"];
    
    // Update the points label text
    pointsLabel.text =
    [NSString stringWithFormat:@"Points: %@", points];
    
    [self showAlert];   // show any alerts that need to be made
    
    // Update the health, energy, and happiness levels in plist
    [self updateLevelsInPlist];
    
    // Update the health, energy, and happiness levels on screen
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
    
    // Decrease energy if awake, Increase if asleep
    energyTimer = [NSTimer scheduledTimerWithTimeInterval:60.0
                                                   target:self
                                                 selector:@selector(updateEnergyForState)
                                                 userInfo:nil
                                                  repeats:YES];
    
    timingDate = [NSDate date]; // set start date
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//====== HELPER METHODS =======

/*
 * hideWelcome - Hides the welcome image
 */
-(void) hideWelcome
{
    // Play happy bark sound
    NSString *path = [[NSBundle mainBundle] pathForResource:@"happy_bark" ofType:@"wav"];
    SystemSoundID theSound;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &theSound);
    AudioServicesPlaySystemSound (theSound);
    
    // Fade image out
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:5.0];
    [welcomeImageView setAlpha:0];
    [UIView commitAnimations];
    
} // End hideWelcome

//====== Alerts =======

/*
 * alertIfAsleep - alerts user that pet is asleep
 * and needs to be woken up to proceed
 */
-(void) alertIfAsleep
{
    if([state isEqual:@"asleep"])
    {
        // Create alert if pet is asleep
        NSString *message = @"You must wake your pet up first";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        
        // Play alert sound
        NSString *path = [ [NSBundle mainBundle] pathForResource:@"alert" ofType:@"wav"];
        SystemSoundID theSound;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &theSound);
        AudioServicesPlaySystemSound (theSound);
        
    }
    
} // End alertIfAsleep

/*
 * showAlert - Shows alert from previous
 * viewcontroller if needed
 */
-(void) showAlert
{
    // Grab showAlert from plist
    gameData = [[NSMutableDictionary alloc]
                initWithContentsOfFile: [appDelegate gameDataPath]];
    NSString *showAlert = [gameData objectForKey:@"showAlert"];
    NSString *lastViewName = [gameData objectForKey:@"lastViewName"];
    
    if([showAlert isEqual:@"yes"] && [lastViewName isEqual:@"play"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Watch Out!"
                                                        message:@"Your pet is too tired and needs some rest and something to eat.  Come back to play when in better shape."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        
        
        // Play alert sound
        NSString *path = [ [NSBundle mainBundle] pathForResource:@"alert" ofType:@"wav"];
        SystemSoundID theSound;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &theSound);
        AudioServicesPlaySystemSound (theSound);
        
        // Make changes and write back to plist
        [gameData setObject:@"no" forKey:@"showAlert"];
        [gameData setObject:@"none" forKey:@"lastViewName"];
        [gameData setObject:[NSNumber numberWithInt:0] forKey:@"lastViewTime"];
        [gameData writeToFile:[appDelegate gameDataPath] atomically:NO];
        
        // Show the alert
        [alert show];
    }
    
} // End showAlert


//====== Animations =======

/*
 * animateAngry - Creates animation for puppy
 * to appear to be angry
 */
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
    
} // End animateAngry

/*
 * animateAwake - Creates animation for puppy
 * to appear to be awake
 */
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
    
} // end animateAwake

/*
 * animateGoingToSleep - Creates animation for puppy
 * to appear to be going to sleep
 */
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
    
} // End animateGoingToSleep

/*
 * animateSleeping - Create animation for puppy
 * to appear to be sleeping
 */
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
    
} // End animateSleeping

/*
 * animateWakingUp - Creates animation for puppy
 * to appear to be waking up
 */
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
    
} // End animateWakingUp

//====== Timer Methods =======

/*
 * clearInfo -  Waits then clears the info bubble
 */
-(void)clearInfo:(NSTimer*)inTimer
{
    // Invalidate timer
    [inTimer invalidate];
    inTimer = nil;
    
    // Clear the info
    infoTypeLabel.text = @"";
    infoPercLabel.text = @"";
    infoBubbleImageView.hidden = YES;
    infoArrowImageView.hidden = YES;
    
} // End clearInfo

/*
 * goingToSleep - Waits then animates the puppy being asleep
 */
-(void)goingToSleep:(NSTimer*)inTimer
{
    // Invalidate timer
    [inTimer invalidate];
    inTimer = nil;
    
    // Sleep and stop being angry if angry
    [self animateSleeping];
    talkLabel.text = @" ";
    talkImageView.hidden = YES;
    
} // End goingToSleep

/*
 * wakingUp -  Waits then animates the puppy being awake
 */
-(void)wakingUp:(NSTimer*)inTimer
{
    // Invalidate the timer
    [inTimer invalidate];
    inTimer = nil;
    
    // Wake up and stop being angry if angry
    [self animateAwake];
    talkLabel.text = @" ";
    talkImageView.hidden = YES;
    
} // End wakingUp

//====== Level Methods =======

/*
 * changeStateTo - Updates state variable and plist
 */
-(void) changeStateTo:(NSString*) theState
{
    // Update state
    state = theState;
    
    // Create the app delegate
    gameData = [[NSMutableDictionary alloc]
                initWithContentsOfFile: [appDelegate gameDataPath]];
    
    // Update the plist
    [gameData setObject:state
                 forKey:@"petState"];
    [gameData writeToFile:[appDelegate gameDataPath] atomically:NO];
    
} // End changeStateTo


/*
 * levelForType: andDirection: withBubble: onIntervalStart: andIntervalEnd
 * Updates the level for type, direction, interval start and end specified
 * Shows info bubble if requested
 */
-(void) levelForType:(NSString*) type
        andDirection:(NSString*) direction
          withBubble:(NSString*) withBubble
     onIntervalStart:(int) start
      andIntervalEnd:(int) end
{
    // Create the app delegate
    gameData = [[NSMutableDictionary alloc]
                initWithContentsOfFile: [appDelegate gameDataPath]];
    NSNumber *percentage = [gameData objectForKey:type];
    int percentageInt = [percentage intValue];
    
    Boolean showChange = YES;   // change to false if no change is not possible
    
    // Calculate random number for change on interval
    int change = (arc4random() % (end - start)) + start;
    
    // Do checks for up
    if([direction isEqualToString:@"up"])
    {
        /*NSLog(@"Type: %@ Direction: %@ Start: %i End: %i Change: %i Current Percentage: %i with Change: %i",
         type, direction, start, end, change, percentageInt, (percentageInt + change));*/
        
        // Percentage is already at 100
        if(percentageInt == 100)
        {
            //NSLog(@"\nPercentage already 100");
            showChange = NO;
        }
        
        // Make sure percentage + change does not go over 100
        if((percentageInt + change) > 100)
        {
            //NSLog(@"\nPercentage + change > 100");
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
        /*NSLog(@"Type: %@ Direction: %@ Start: %i End: %i Change: %i Current Percentage: %i with Change: %i",
         type, direction, start, end, change, percentageInt, (percentageInt - change));*/
        
        // Percentage is already 0
        if(percentageInt == 0)
        {
            //NSLog(@"Percentage already 0");
            showChange = NO;
        }
        
        // Make sure percentage - change does not go below 0
        if((percentageInt - change) < 0)
        {
            //NSLog(@"\nPercentage - change < 0");
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
        
        // Show the bubble with info if requested
        if([withBubble isEqual:@"yes"])
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
                [UIImage imageNamed:@"magentaArrow.png"];
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
            
            // Clear labels and imageViews after timer
            [NSTimer scheduledTimerWithTimeInterval:3.0 target:self
                                           selector:@selector(clearInfo:)
                                           userInfo:nil repeats:NO];
            
        }
    }
    
} // End levelForType: andDirection: withBubble: onIntervalStart: andIntervalEnd

/*
 * soundForDirection - Plays sound for direction up or down
 */
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
    
} // End soundForDirection

/*
 * updateEnergy - Updates energy on screen
 * to reflect current values in plist
 */
- (void) updateEnergy
{
    // Grab energry from plist through app delegate
    gameData = [[NSMutableDictionary alloc]
                initWithContentsOfFile: [appDelegate gameDataPath]];
    NSNumber *energy = [gameData objectForKey:@"energy"];
    
    // Update the energy label text
    energyLabel.text =
    [NSString stringWithFormat:@"%@%@", energy, @"%"];
    
    // Update the energy image view
    NSString *imageName = [self barsImageName: [energy intValue]];
    energryImageView.image = [UIImage imageNamed:imageName];
    
} // End updateEnergy

/*
 * updateEnergyForState - Decreases energy if sleeping
 * Increases energy if awake
 */
-(void) updateEnergyForState
{
    // Grab percentage from plist through app delegate
    gameData = [[NSMutableDictionary alloc]
        initWithContentsOfFile: [appDelegate gameDataPath]];
    NSNumber *energy = [gameData objectForKey:@"energy"];
    int percentageInt = [energy intValue];
    Boolean showChange = NO;
    
    // If awake and possible decrease energy by 1
    if([state isEqual:@"awake"] && (percentageInt - 1) >= 0)
    {
        percentageInt --;
        showChange = YES;
        
    }
    
    // If asleep and possible increase energy by 1
    if([state isEqual:@"asleep"] && (percentageInt + 1) <= 100)
    {
        percentageInt ++;
        showChange = YES;
        
    }
    
    if(showChange == YES)
    {
        // Update the plist value
        energy = [NSNumber numberWithInt:percentageInt];
        [gameData setObject:energy
                     forKey:@"energy"];
        [gameData writeToFile:[appDelegate gameDataPath] atomically:NO];
        
        [self updateEnergy]; // Update energy bar
    }
    
} // End updateEnergyForState

/*
 * updateHappiness - Updates happiness on screen
 * to reflect current values in plist
 */
- (void) updateHappiness
{
    // Grab happiness from plist through app delegate
    gameData = [[NSMutableDictionary alloc]
                initWithContentsOfFile: [appDelegate gameDataPath]];
    NSNumber *happiness = [gameData objectForKey:@"happiness"];
    
    // Update the happiness label text
    happinessLabel.text =
    [NSString stringWithFormat:@"%@%@", happiness, @"%"];
    
    // Update the happiness image view
    NSString *imageName = [self barsImageName: [happiness intValue]];
    happinessImageView.image = [UIImage imageNamed:imageName];
    
} // End updateHappiness

/*
 * updateHealth - Updates health on screen 
 * to reflect current values in plist
 */
- (void) updateHealth
{
    // Grab health from plist through app delegate
    gameData = [[NSMutableDictionary alloc]
        initWithContentsOfFile: [appDelegate gameDataPath]];    
    NSNumber *health = [gameData objectForKey:@"health"];
    
    // Update the health label text
    healthLabel.text =
    [NSString stringWithFormat:@"%@%@", health, @"%"];
    
    // Update the health image view
    NSString *imageName = [self barsImageName: [health intValue]];
    healthImageView.image = [UIImage imageNamed:imageName];

} // End updateHealth

/*
 * updateLevelsInPlist -
 * Updates levels in plist for previous activity
 * for eat health goes up 1% for every minute
 * for pet health goes down 1% for every minute
 */
-(void) updateLevelsInPlist
{
    // Grab percentages from plist through app delegate
    gameData = [[NSMutableDictionary alloc]
                initWithContentsOfFile: [appDelegate gameDataPath]];
    //NSNumber *energy = [gameData objectForKey:@"energy"];
    NSNumber *health = [gameData objectForKey:@"health"];
    //NSNumber *happiness = [gameData objectForKey:@"happiness"];
    
    // Grab last view and time spent in it
    NSString *lastViewName = [gameData objectForKey:@"lastViewName"];
    NSNumber *lastViewTime = [gameData objectForKey:@"lastViewTime"];
    
    // Increase health and energry for eat
    if([lastViewName isEqual:@"eat"])
    {
        //NSLog(@"Health was %@", health);
        
        int percentage = [health intValue];
        int time = [lastViewTime intValue] + 1; // not zero
        
        percentage = [self changePercentForLevel:@"health"
                                andOldPercentage:percentage
                                         andTime:time
                                     inDirection:@"up"];
        
        // Update health
        health = [NSNumber numberWithInt:percentage];
        
        //NSLog(@"Health now %@", health);
        
        // Write health and energry back to plist
        [gameData setObject:health
                     forKey:@"health"];
        [gameData writeToFile:[appDelegate gameDataPath] atomically:NO];
    }
    
    // Decrease health for play and pet
    if([lastViewName isEqual:@"pet"])
    {
        //NSLog(@"Health was %@", health);
        
        int percentage = [health intValue];
        int time = [lastViewTime intValue] + 1; // not zero
        
        percentage = [self changePercentForLevel:@"health"
                                andOldPercentage:percentage
                                         andTime:time
                                     inDirection:@"down"];
        
        // Update health and write back to plist
        health = [NSNumber numberWithInt:percentage];
        
        //NSLog(@"Health now %@", health);
        
        [gameData setObject:health
                     forKey:@"health"];
        [gameData writeToFile:[appDelegate gameDataPath] atomically:NO];
    }
    
    if(![lastViewTime isEqual:@"none"])
    {
        // Change last view name and time
        lastViewName = @"none";
        lastViewTime = [NSNumber numberWithInt:0];
        
        // Write back to plist
        [gameData setObject:lastViewName
                     forKey:@"lastViewName"];
        [gameData setObject:lastViewTime forKey:@"lastViewTime"];
        [gameData writeToFile:[appDelegate gameDataPath] atomically:NO];
    }
    
} // End updateLevelsInPlist

/*
 * changePercentForLevel: andOldPercentage: andTime: inDirection: -
 * Changes percent by one for every minute in direction specified
 */
-(int) changePercentForLevel:(NSString*) level
            andOldPercentage:(int)percentage
                     andTime:(int) time
                 inDirection:(NSString*) direction
{
    int change;
    
    // Set change 1 for every minute, if less than 1 min make change = 1
    if(time > 60)
    {
        change = time/60;
    }
    else
    {
        change = 1;
    }
    
    if([direction isEqual:@"down"])
    {
        // Make sure percentage does not go below 0
        if(percentage - change >= 0)
        {
            percentage -= change;
        }
        else
        {
            percentage = 0;
        }
        
    }
    
    if([direction isEqual:@"up"])
    {
        // Make sure percentage does not above 100
        if(percentage + change <= 100)
        {
            percentage += change;
        }
        else
        {
            percentage = 100;
        }
        
    }
    
    return percentage;
    
} // End changePercentForLevel: andOldPercentage: andTime: inDirection: 

/*
 * barsImageName - Returns appropriate bar 
 * image name for percentage
 */
-(NSString*) barsImageName: (int) number
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
    
} // End barsImageName

//====== Actions =======

/*
 * buttonPressed - Performs actions based on button pressed
 * and current state of pet
 */
-(IBAction) buttonPressed:(id)sender
{    
    // Grab button title
    NSString *buttonType = [sender titleForState:UIControlStateNormal];
    
    // Find the state of the pet in plist through app delegate
    gameData = [[NSMutableDictionary alloc]
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
            // Go to sleep
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
                  andDirection:@"down"
                    withBubble:@"yes"
               onIntervalStart:10
                andIntervalEnd:30];
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
            // Wake up
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
                  andDirection:@"down"
                    withBubble:@"yes"
               onIntervalStart:10
                andIntervalEnd:20];
        }
        
    }

} // End buttonPressed

/*
 * goToEatView - Makes EatViewController the 
 * presentViewController if pet is awake
 */
-(IBAction)goToEatView: (id)sender
{
    if([state isEqual:@"asleep"])
    {
        [self alertIfAsleep];
    }
    else
    {
        EatViewController *eatViewController = [[EatViewController alloc] init];
        [self presentViewController:eatViewController animated:YES completion:NULL];
    }
    
} // End goToEatView

/*
 * goToPetView - Makes PetViewController the
 * presentViewController if pet is awake
 */
-(IBAction)goToPetView: (id)sender
{
    if([state isEqual:@"asleep"])
    {
        [self alertIfAsleep];
    }
    else
    {
        PetViewController *petViewController = [[PetViewController alloc] init];
        [self presentViewController:petViewController animated:YES completion:NULL];
    }
    
} // End goToPetView

/*
 * goToPlayView - Makes PlayViewController the
 * presentViewController if pet is awake and
 * items specified for play are currently in closet
 */
-(IBAction)goToPlayView: (id)sender
{
    // See if any items to play with are available
    itemsData = [[NSMutableDictionary alloc]
        initWithContentsOfFile: [appDelegate itemsDataPath]];
    NSNumber *itemsToPlayWith = [itemsData objectForKey:@"itemsToPlayWith"];
    
    if([state isEqual:@"asleep"])
    {
        [self alertIfAsleep];
    }
    else if([itemsToPlayWith intValue] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                        message:@"Your pet needs items to play with.  You must buy some from the store first before you can play."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        
        
        // Play alert sound
        NSString *path = [ [NSBundle mainBundle] pathForResource:@"alert" ofType:@"wav"];
        SystemSoundID theSound;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &theSound);
        AudioServicesPlaySystemSound (theSound);
        
        // Show the alert
        [alert show];
    }
    else
    {
        PlayViewController *playViewController = [[PlayViewController alloc] init];
        [self presentViewController:playViewController animated:YES completion:NULL];
    }

} // End goToPlayView

/*
 * goToWalkView - Makes WalkViewController the
 * presentViewController if pet is awake
 */
-(IBAction)goToWalkView: (id)sender
{
    if([state isEqual:@"asleep"])
    {
        [self alertIfAsleep];
    }
    else
    {
        WalkViewController *walkViewController = [[WalkViewController alloc] init];
        [self presentViewController:walkViewController animated:YES completion:NULL];
    }

} // End goToWalkView

@end
