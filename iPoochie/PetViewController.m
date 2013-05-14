//
//  PetViewController.m
//  iPoochie
//
//  Created by marta wilgan on 4/29/13.
//  Copyright (c) 2013 NYU. All rights reserved.
//

#import "PetViewController.h"

@interface PetViewController ()

@end

@implementation PetViewController
@synthesize points;
@synthesize wagging1;
@synthesize wagging2;
@synthesize timingDate;
@synthesize timeInView;
@synthesize appDelegate;
@synthesize gameData;
@synthesize pointsLabel;
@synthesize talkLabel;
@synthesize numberLabel;
@synthesize happinessLabel;
@synthesize happinessStatLabel;
@synthesize talkImageView;
@synthesize petImageView;
@synthesize bubbleImageView;
@synthesize arrowImageView;
@synthesize happinessBarImageView;

// Global variables
int gCurrentIndex = 0; // Current index for wagging array
int gCurrentArray = 0; // Current wagging array
int gTwoSeconds = 0;   // Number of two seconds spent petting
double gTotalTime = 0; // Total time spent petting

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
    
    // Create wagging1
    NSArray *wagging1Array = [[NSArray alloc] initWithObjects:  @"wagging1A.png",
                                                                @"wagging1B.png",
                                                                @"wagging1C.png",
                                                                @"wagging1D.png",
                                                                @"wagging1E.png",
                                                                @"wagging1F.png",
                                                                @"wagging1G.png",
                                                                @"wagging1H.png",
                                                                @"wagging1I.png",
                                                                        nil];
    self.wagging1 = wagging1Array;
    
    
    
    // Create wagging2
    NSArray *wagging2Array = [[NSArray alloc] initWithObjects:  @"wagging2A.png",
                                                                @"wagging2B.png",
                                                                @"wagging2C.png",
                                                                @"wagging2D.png",
                                                                @"wagging2E.png",
                                                                @"wagging2F.png",
                                                                @"wagging2G.png",
                                                                @"wagging2H.png",
                                                                @"wagging2I.png",
                                                                @"wagging2J.png",
                                                                        nil];
    self.wagging2 = wagging2Array;
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Grab points from plist through app delegate
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    gameData = [[NSMutableDictionary alloc]
        initWithContentsOfFile: [appDelegate gameDataPath]];
    points = [gameData objectForKey:@"points"];
    NSNumber *happiness = [gameData objectForKey:@"happiness"];

    // Update the points label text
    pointsLabel.text =
    [NSString stringWithFormat:@"Points: %@", points];
    
    // Update the happiness label text
    happinessStatLabel.text =
    [NSString stringWithFormat:@"%@%@", happiness, @"%"];
    
    // Update the happiness image view
    NSString *imageName = [self barsImageName: [happiness intValue]];
    happinessBarImageView.image = [UIImage imageNamed:imageName];
    
    // Set to defaults
    gTotalTime = 0;
    gTwoSeconds = 0;
    
    // Start the time in view
    timeInView = [NSDate date];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//====== HELPER METHODS =======

/*
 * barsImageName -  Returns appropriate
 * bar image name for percentage
 */
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
    
} // End barsImageName

/*
 * nextImageName - Returns image name for 
 * current index in current array
 */
-(NSString*) nextImageName
{
    NSString *imageName = @"";
    
    if(gCurrentArray == 1)
    {
        imageName = wagging1[gCurrentIndex];
    }
    else if(gCurrentArray == 2)
    {
        imageName = wagging2[gCurrentIndex];
    }
    
    return imageName;
    
} // End nextImageName

/* 
 * updateIndex -  Increments index, and
 * switches to other array if last index in array
 */
-(void) updateIndex
{
    // if not last index in wagging1
    if(gCurrentArray == 1 && gCurrentIndex < ([wagging1 count]-1))
    {
        gCurrentIndex++;
    }
    // else if last index in wagging1
    else if(gCurrentArray == 1 && gCurrentIndex == ([wagging1 count]-1))
    {
        gCurrentIndex = 0;
        gCurrentArray = 2;
    }
    // else if not last index in wagging2
    else if(gCurrentArray == 2 && gCurrentIndex < ([wagging2 count]-1))
    {
        gCurrentIndex++;
    }
    // else if last index in wagging2
    else if(gCurrentArray == 2 && gCurrentIndex == ([wagging2 count]-1))
    {
        gCurrentIndex = 0;
        gCurrentArray = 1;
    }
    
} // End updateIndex

/* 
 * updateHappinessForTime: - Increases happiness 
 * if not already 100, and alerts user
 */
-(void) updateHappinessForTime:(int)time
{
    // Grab health from plist through app delegate
    gameData = [[NSMutableDictionary alloc]
        initWithContentsOfFile: [appDelegate gameDataPath]];
    NSNumber *happiness = [gameData objectForKey:@"happiness"];
    int happinessInt = [happiness intValue];
    
    Boolean showChange = NO;   // change to true if change is possible
    
    // Calculate random number for change on interval
    int change = (arc4random() % ((time + 5) - 2)) + 3;
    
    
    // Make sure percentage does not go over 100
    if(happinessInt < 100 && (happinessInt + change) > 100)
    {
        showChange = YES;
        change = 100 - happinessInt;
        happinessInt = 100;
    }
    else if(happinessInt < 100 && (happinessInt + change) <= 100)
    {
        showChange = YES;
        happinessInt += change;
    }

    
    // If change possible increase happiness by change%
    if(showChange == YES)
    {
        
        // Alert user happiness is increasing
        numberLabel.text = [NSString stringWithFormat:@"%i%@",change,@"%"];
        happinessLabel.text = @"Happiness Up";
        bubbleImageView.hidden = NO;
        bubbleImageView.image = [UIImage imageNamed:@"greenBubble.png"];
        arrowImageView.hidden = NO;
        arrowImageView.image = [UIImage imageNamed:@"magentaArrow.png"];
        
        // Play sound
        NSString *path = [ [NSBundle mainBundle] pathForResource:@"up" ofType:@"wav"];
        SystemSoundID theSound;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &theSound);
        AudioServicesPlaySystemSound (theSound);
        
        // Update happiness and write back to plist
        happiness = [NSNumber numberWithInt:happinessInt];
        [gameData setObject:happiness forKey:@"happiness"];
        [gameData writeToFile:[appDelegate gameDataPath] atomically:NO];
        
        // Update the happiness label text
        happinessStatLabel.text =
        [NSString stringWithFormat:@"%@%@", happiness, @"%"];
        
        // Update the happiness image view
        NSString *imageName = [self barsImageName: [happiness intValue]];
        happinessBarImageView.image = [UIImage imageNamed:imageName];
        
        // After time interval to hide alert to user
        [NSTimer scheduledTimerWithTimeInterval:2.0 target:self
                                       selector:@selector(hideBubble:)
                                       userInfo:nil repeats:NO];
    }

} // End updateHappinessForTime

/*
 * hideBubble - Waits then hides happiness message
 */
-(void)hideBubble:(NSTimer*)inTimer
{
    [inTimer invalidate];
    inTimer = nil;
    
    // Clear happiness message
    numberLabel.text = @"";
    happinessLabel.text = @"";
    bubbleImageView.hidden = YES;
    arrowImageView.hidden = YES;
    
} // End hideBubble

/*
 * petting - Waits then change image 
 * in petImageView
 */
-(void)petting:(NSTimer*)inTimer
{
    [inTimer invalidate];
    inTimer = nil;
    
    // change image
    NSString *imageName = [self nextImageName];
    petImageView.image = [UIImage imageNamed:imageName];
    [self updateIndex]; // update the array index
    
} // End petting

/*
 * stopped - Waits then changes image 
 * in petImageView
 */
-(void)stopped:(NSTimer*)inTimer
{
    [inTimer invalidate];
    inTimer = nil;
    
    // Wake up and stop being angry if angry
    petImageView.image = [UIImage imageNamed:@"blinking4A.png"];
    
} // End stopped

//====== Actions =======

/*
 * goBack - Makes any final changes and
 * returns to InteractViewController
 */
-(IBAction)goBack: (id)sender
{
    // Find how much time was spent in view
    NSNumber *time = [NSNumber numberWithDouble:
                      [[NSDate date] timeIntervalSinceDate:self.timeInView]];
    
    // Update lastViewName to play and save time spent in view
    gameData = [[NSMutableDictionary alloc]
                initWithContentsOfFile: [appDelegate gameDataPath]];
    [gameData setObject:@"pet" forKey:@"lastViewName"];
    [gameData setObject:time
                 forKey:@"lastViewTime"];
    [gameData writeToFile:[appDelegate gameDataPath] atomically:NO];
    
    // go back
    [self dismissViewControllerAnimated:YES completion:NULL];
    
} // End goBack

#pragma mark -

//====== Touch Methods =======

/*
 * touchesBegan: withEvent: - Starts the petting process
 * when user touches the petImageView
 */
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    
    // touch for petImageView
	if ([touch view] == petImageView)
    {
        //NSLog(@"\nTouches began");
        
        timingDate = [NSDate date]; // set start date
        gCurrentIndex = 0;          // Index starts at 0
        gCurrentArray = 1;          // Current array wagging1
        talkLabel.text = @" ";      // Clear talk label
        talkImageView.hidden = YES; // Make talk bubble hidden
    }
    
} // End touchesBegan: withEvent:

/*
 * touchesEnded: withEvent: - Ends the petting process
 * when user stops touching petImageView
 */
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    
    // touch for petImageView
	if ([touch view] == petImageView)
    {
        //NSLog(@"\nTouches ended");
        
        // Find how much time petting lasted
        NSNumber *time = [NSNumber numberWithDouble:
            [[NSDate date] timeIntervalSinceDate:self.timingDate]];
        gTotalTime += [time doubleValue]; // Update total time
        
        // Wait then change image for petImageView twice
        [NSTimer scheduledTimerWithTimeInterval:.3 target:self
                                       selector:@selector(stopped:)
                                       userInfo:nil repeats:NO];
        petImageView.image = [UIImage imageNamed:@"blinking4C.png"];
        
    }
    
} // End touchesEnded: withEvent:

/*
 * touchesMoved: withEvent: - Shows animation for petting
 * simulation and updates happiness 
 */
-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    
    // Touch Action for petImageView
	if ([touch view] == petImageView)
    {
        //NSLog(@"\nTouches moved");
        
        // Find how much time petting
        NSNumber *time = [NSNumber numberWithDouble:
            [[NSDate date] timeIntervalSinceDate:self.timingDate]];        
        int totalTimeInt = (int)gTotalTime + [time intValue];
        
        // For every 2 seconds, happiness goes up unless already 100%
        if( (totalTimeInt/2) > gTwoSeconds)
        {
            [self updateHappinessForTime:[time intValue]];
            gTwoSeconds++;
        }
        
        // Wait then change image for petImageView
        [NSTimer scheduledTimerWithTimeInterval:.1 target:self
                                       selector:@selector(petting:)
                                       userInfo:nil repeats:NO];
    }

} // End touchesMoved: withEvent:


@end
