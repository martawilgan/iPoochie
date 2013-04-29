//
//  InteractViewController.m
//  iPoochie
//
//  Created by marta wilgan on 4/17/13.
//  Copyright (c) 2013 NYU. All rights reserved.
//

#import "InteractViewController.h"
#import "AppDelegate.h"

@interface InteractViewController ()

@end

@implementation InteractViewController
@synthesize points;
@synthesize state;
@synthesize pointsLabel;
@synthesize healthLabel;
@synthesize energyLabel;
@synthesize happinessLabel;
@synthesize healthImageView;
@synthesize energryImageView;
@synthesize happinessImageView;
@synthesize petImageView;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) updateHealth
{
    // Grab health from plist through app delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *gameData = [[NSMutableDictionary alloc]
                                     initWithContentsOfFile: [appDelegate gameDataPath]];    
    NSNumber *health = [gameData objectForKey:@"health"];
    
    // Update the health label text
    healthLabel.text =
    [NSString stringWithFormat:@"%@ %@", health, @"%"];
    
    
    
    // Update the health image view
    NSString *imageName = [self barsImageName: [health intValue]];
    healthImageView.image = [UIImage imageNamed:imageName];

}

- (void) updateEnergy
{
    // Grab health from plist through app delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *gameData = [[NSMutableDictionary alloc]
                                     initWithContentsOfFile: [appDelegate gameDataPath]];
    NSNumber *energy = [gameData objectForKey:@"energy"];
    
    // Update the health label text
    energyLabel.text =
    [NSString stringWithFormat:@"%@ %@", energy, @"%"];
    
    // Update the energy image view
    NSString *imageName = [self barsImageName: [energy intValue]];
    energryImageView.image = [UIImage imageNamed:imageName];
}

- (void) updateHappiness
{
    // Grab health from plist through app delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *gameData = [[NSMutableDictionary alloc]
                                     initWithContentsOfFile: [appDelegate gameDataPath]];
    NSNumber *happiness = [gameData objectForKey:@"happiness"];
    
    // Update the health label text
    happinessLabel.text =
    [NSString stringWithFormat:@"%@ %@", happiness, @"%"];
    
    // Update the happiness image view
    NSString *imageName = [self barsImageName: [happiness intValue]];
    happinessImageView.image = [UIImage imageNamed:imageName];
}

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
    if ([buttonType isEqualToString: @"play"])
    {
        
    }
    if ([buttonType isEqualToString: @"eat"])
    {
        
    }
    if ([buttonType isEqualToString: @"sleep"])
    {
        // Animate sleeping after timer
        [NSTimer scheduledTimerWithTimeInterval:3.0 target:self
                                       selector:@selector(goingToSleep:)
                                       userInfo:nil repeats:NO];
        // Check to see if awake
        if([state isEqualToString:@"awake"])
        {
            [self animateGoingToSleep];
            [self changeStateTo:@"asleep"];
        }
        else
        {
            [self setAngry:[NSNumber numberWithInt:1]];
            [self animateAngry]; // already asleep!
        }
        
    }
    if ([buttonType isEqualToString: @"pet"])
    {
        
    }
    if ([buttonType isEqualToString: @"walk"])
    {
    
    }
    if ([buttonType isEqualToString: @"wake up"])
    {
        // Animate awake after timer
        [NSTimer scheduledTimerWithTimeInterval:3.0 target:self
                                       selector:@selector(wakingUp:)
                                       userInfo:nil repeats:NO];
        // Check to see if asleep
        if([state isEqualToString:@"asleep"])
        {
            [self animateWakingUp];
            [self changeStateTo:@"awake"];
        }
        else
        {
            [self setAngry:[NSNumber numberWithInt:1]];
            [self animateAngry]; // already awake! 
        }
        
    }

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
                                     [UIImage imageNamed:@"angry1.png"],
                                     [UIImage imageNamed:@"angry2.png"],
                                     [UIImage imageNamed:@"angry1.png"],
                                     [UIImage imageNamed:@"angry2.png"],
                                     [UIImage imageNamed:@"angry1.png"],
                                     [UIImage imageNamed:@"angry2.png"],
                                     [UIImage imageNamed:@"angry1.png"],
                                     [UIImage imageNamed:@"angry2.png"],
                                     nil];
    
    
    petImageView.animationDuration = 3.0;
    petImageView.animationRepeatCount = 1;
    [petImageView startAnimating];
}

// Wait then animate the puppy being awake
-(void)wakingUp:(NSTimer*)inTimer
{
    [inTimer invalidate];
    inTimer = nil;
    
    // If not angry wake up otherwise stop being angry
    if ([[self angry] isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        [self animateAwake];
    }
    else
    {
        [self setAngry:[NSNumber numberWithInt:0]];
    }
}

// Wait then animate the puppy being asleep
-(void)goingToSleep:(NSTimer*)inTimer
{
    [inTimer invalidate];
    inTimer = nil;
    
    // If not angry sleep otherwise stop being angry
    if ([[self angry] isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        [self animateSleeping];
    }
    else
    {
        [self setAngry:[NSNumber numberWithInt:0]];
    }
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

-(id) angry
{
    // Create the app delegate
    AppDelegate *appDelegate =
    (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *gameData = [[NSMutableDictionary alloc]
                                     initWithContentsOfFile: [appDelegate gameDataPath]];

    return [gameData objectForKey:@"angry"];
}


// Set angry variable in plist
-(void) setAngry : (NSNumber*) number
{
    // Create the app delegate
    AppDelegate *appDelegate =
    (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *gameData = [[NSMutableDictionary alloc]
                                     initWithContentsOfFile: [appDelegate gameDataPath]];
    // Update the plist
    [gameData setObject: number
                forKey:@"angry"];
    [gameData writeToFile:[appDelegate gameDataPath] atomically:NO];

}



@end
