//
//  PlayViewController.m
//  iPoochie
//
//  Created by marta wilgan on 4/29/13.
//  Copyright (c) 2013 NYU. All rights reserved.
//

#import "PlayViewController.h"

#define kUpdateInterval     (1.0f/60.0f)

@interface PlayViewController ()

@end

@implementation PlayViewController
@synthesize motionManager;
@synthesize points;
@synthesize health;
@synthesize happiness;
@synthesize energy;
@synthesize chosenItem;
@synthesize pickerData;
@synthesize items;
@synthesize amounts;
@synthesize timeInView;
@synthesize appDelegate;
@synthesize itemsData;
@synthesize gameData;
@synthesize pickerLabel;
@synthesize pointsLabel;
@synthesize healthLabel;
@synthesize happinessLabel;
@synthesize energyLabel;
@synthesize healthImageView;
@synthesize energyImageView;
@synthesize happinessImageView;
@synthesize backgroundImageView;
@synthesize infoImageView;
@synthesize pickerView;
@synthesize playView;
@synthesize backButton;
@synthesize infoButton;


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
    
    self.playView.hidden = YES;
    
    // Create temp arrays
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    self.items = tempArray;
    self.amounts = tempArray;
    
    // Grab data from plist through app delegate
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    itemsData = [[NSMutableDictionary alloc]
        initWithContentsOfFile: [appDelegate itemsDataPath]];
    self.items = [itemsData objectForKey:@"imageNames"];
    self.amounts = [itemsData objectForKey:@"amounts"];
    
    // Create the pickerData array
    NSMutableArray *pickerDataArray = [[NSMutableArray alloc] init];
    
    // Remove items from array
    for(int i = 0; i< items.count; i++)
    {
        /*
         * Remove items that are not currently available
         * or cannot be played with
         */
        if([items[i] isEqual:@"chow.png"]
           || [amounts[i] isEqual:[NSNumber numberWithInt:0]])
        {
            [items removeObjectAtIndex:i];
            [amounts removeObjectAtIndex:i];
            i--; // update for loop
        }
    }
    
    // Create imageViews for items that remain
    for(int i = 0; i< items.count; i++)
    {
        // Create an image
        UIImage *theImage = [UIImage imageNamed:[self.items objectAtIndex :i]];
        
        // Create an imageview
        UIImageView *theImageView = [[UIImageView alloc] initWithImage:theImage];
        
        // Insert imageView into array
        [pickerDataArray insertObject:theImageView atIndex:i];
    }
    
    // Reload the picker with current data
    self.pickerData = pickerDataArray;
    [self.pickerView reloadAllComponents];

}

-(void) viewDidUnload
{
    [super viewDidUnload];
    self.points = nil;
    self.pointsLabel = nil;
    self.motionManager = nil;
    self.backButton = nil;
    self.backButton = nil;
    self.playView = nil;
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Set default values for start
    self.playView.hidden = YES;
    self.infoImageView.hidden = YES;
    self.infoImageView.image = [UIImage imageNamed:@"playInfo.png"];
    self.infoButton.enabled = NO;
    self.infoButton.hidden = YES;
    
    // Grab values from plist through app delegate
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    gameData = [[NSMutableDictionary alloc]
        initWithContentsOfFile: [appDelegate gameDataPath]];
    points = [gameData objectForKey:@"points"];
    health = [gameData objectForKey:@"health"];
    happiness = [gameData objectForKey:@"happiness"];
    energy = [gameData objectForKey:@"energy"];
    
    // Update the labels
    pointsLabel.text =
        [NSString stringWithFormat:@"Points: %@", points];
    healthLabel.text =
        [NSString stringWithFormat:@"%@ %@", health, @"%"];
    happinessLabel.text =
        [NSString stringWithFormat:@"%@ %@", happiness, @"%"];
    energyLabel.text =
        [NSString stringWithFormat:@"%@ %@", energy, @"%"];
    
    // Update the level image views
    NSString *imageName = [self barsImageName: [health intValue]];
    healthImageView.image = [UIImage imageNamed:imageName];
    imageName = [self barsImageName: [happiness intValue]];
    happinessImageView.image = [UIImage imageNamed:imageName];
    imageName = [self barsImageName: [energy intValue]];
    energyImageView.image = [UIImage imageNamed:imageName];
    
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
 * updateAllLabels - updates the labels based
 * on current values in plist
 */
-(void) updateAllLabels
{
    // Keep track of old values shown 
    NSNumber *oldPoints = points;
    NSNumber *oldHealth = health;
    NSNumber *oldEnergy = energy;
    NSNumber *oldHappiness = happiness;
    
    // Grab points from plist through app delegate
    gameData = [[NSMutableDictionary alloc]
        initWithContentsOfFile: [appDelegate gameDataPath]];
    points = [gameData objectForKey:@"points"];
    health = [gameData objectForKey:@"health"];
    energy = [gameData objectForKey:@"energy"];
    happiness = [gameData objectForKey:@"happiness"];
    
    // Update the points label text if necessary
    if([oldPoints intValue] < [points intValue])
    {
        pointsLabel.text =
            [NSString stringWithFormat:@"Points: %@", points];
    }
    
    // Update the health label and image view if necessary
    if([oldHealth intValue] != [health intValue])
    {
        healthLabel.text =
            [NSString stringWithFormat:@"%@ %@", health, @"%"];
        NSString *imageName = [self barsImageName: [health intValue]];
        healthImageView.image = [UIImage imageNamed:imageName];
    }
    
    // Update the energy label and image view if necessary
    if([oldEnergy intValue] != [energy intValue])
    {
        energyLabel.text =
            [NSString stringWithFormat:@"%@ %@", energy, @"%"];
        NSString *imageName = [self barsImageName: [energy intValue]];
        energyImageView.image = [UIImage imageNamed:imageName];
    }
    
    // Update the happiness label and image view if necessary
    if([oldHappiness intValue] != [happiness intValue])
    {
        happinessLabel.text =
            [NSString stringWithFormat:@"%@ %@", happiness, @"%"];
        NSString *imageName = [self barsImageName: [happiness intValue]];
        happinessImageView.image = [UIImage imageNamed:imageName];
    }
    
    // If pet has no energy and/or health kick user out of play
    if([energy intValue] == 0 || [health intValue] == 0 ||
       ([energy intValue] == 0 && [health intValue] == 0))
    {
        // Make any leaving updates
        [self leavingUpdatesWithAlert:@"yes"];
        [self dismissViewControllerAnimated:YES completion:NULL];
        
    }

} // End updateAllLabels

/*
 * leavingUpdatesWithAlert - Completes final leaving updates
 * and sets showAlert in plist if specified
 * (InteractViewController will display alert if requested)
 */
-(void) leavingUpdatesWithAlert: (NSString*) withAlert
{
    // Find how much time was spent in view
    NSNumber *time = [NSNumber numberWithDouble:
                      [[NSDate date] timeIntervalSinceDate:self.timeInView]];
    
    // Update lastViewName to play and save time spent in view
    gameData = [[NSMutableDictionary alloc]initWithContentsOfFile:
        [appDelegate gameDataPath]];
    itemsData = [[NSMutableDictionary alloc]initWithContentsOfFile:
        [appDelegate itemsDataPath]];
    
    // Grab current items and amounts from plist
    self.items = [itemsData objectForKey:@"imageNames"];
    self.amounts = [itemsData objectForKey:@"amounts"];
    
    // Remove item that was played with from closet
    for(int i = 0; i < [items count]; i++)
    {
        if([items[i] isEqual:chosenItem])
        {
            NSNumber *newAmount = [NSNumber numberWithInt:[amounts[i] intValue] - 1];
            [self.amounts replaceObjectAtIndex:i withObject: newAmount];
        }
    }
    
    // Update itemsToPlayWith
    NSNumber *itemsToPlayWith = [itemsData objectForKey:@"itemsToPlayWith"];
    itemsToPlayWith = [NSNumber numberWithInt:([itemsToPlayWith intValue] - 1)];
    
    // Write back to items plist
    [itemsData setObject:itemsToPlayWith forKey:@"itemsToPlayWith"];
    [itemsData setObject:amounts forKey:@"amounts"];
    [itemsData writeToFile:[appDelegate itemsDataPath] atomically:NO];
    
    // Set showAlert to yes if alert requested
    if([withAlert isEqual:@"yes"])
    {
        [gameData setObject:@"yes" forKey:@"showAlert"];
    }
    
    // Write back to game plist
    [gameData setObject:@"play" forKey:@"lastViewName"];
    [gameData setObject:time forKey:@"lastViewTime"];
    [gameData setObject:@"none" forKey:@"chosenItem"];
    [gameData writeToFile:[appDelegate gameDataPath] atomically:NO];
    
} // End leavingUpdatesWithAlert

/*
 * barsImageName -  Returns appropriate bar
 * image name for number
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

//====== Actions =======

/*
 * goBack - Goes back to InteractViewController
 */
-(IBAction)goBack: (id)sender
{
    // Make any final updates and go back
    [self leavingUpdatesWithAlert:@"no"];
    [self dismissViewControllerAnimated:YES completion:NULL];
    
} // End goBack

/*
 * chooseItem - Sets the chosen item 
 * selected in picker and shows the play view
 */
-(IBAction)chooseItem:(id)sender
{
    UIButton *button = sender;
    
    // Hide choose item outlets
    pickerView.hidden = YES;
    pickerLabel.hidden = YES;
    button.enabled = NO;
    button.hidden = YES;
    
    // Set the background image to a park
    backgroundImageView.image = [UIImage imageNamed:@"park.png"];
    
    // Update the item chosen from picker in the plist
    NSInteger row = [pickerView selectedRowInComponent:0];
    int index = row;
    chosenItem = items[index];
    
    //NSLog(@"the item is %@", chosenItem);
    
    // Set chosenItem in plist to item selected
    gameData = [[NSMutableDictionary alloc]
        initWithContentsOfFile: [appDelegate gameDataPath]];
    [gameData setObject:chosenItem forKey:@"chosenItem"];
    [gameData writeToFile:[appDelegate gameDataPath] atomically:NO];
    
    // Check if chosenItem is updated in plist
    NSString *chosenItemInPlist = [gameData objectForKey:@"chosenItem"];
    
    // Make sure item is saved in plist before play
    if(![chosenItemInPlist isEqual:@"none"])
    {        
        self.playView.hidden = NO; // Show the play view
        
        // Show and enable the info button
        self.infoButton.enabled = YES;
        self.infoButton.hidden = NO;
        
        // Start playing
        self.motionManager = [appDelegate motionManager];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        motionManager.accelerometerUpdateInterval = kUpdateInterval;
        [motionManager startAccelerometerUpdatesToQueue:queue withHandler:
         ^(CMAccelerometerData *accerlerometerData, NSError *error)
         {
             [(playView*)self.playView setAcceleration:accerlerometerData.acceleration];
             [self.playView performSelectorOnMainThread:@selector(update) withObject:nil waitUntilDone:NO];
             [self performSelectorOnMainThread:@selector(updateAllLabels) withObject:nil waitUntilDone:YES];
         
         }];
    }

} // End chooseItem

/*
 * infoAlert - shows the user an alert message 
 * with info on how to play game
 */
-(IBAction)infoAlert:(id)sender
{
    // Create and show the alert
    NSString *message = @"Tilt the screen to make your pet move. Keep moving until the item appears, then move your pet directly on top of the item and tap the screen where the item is.  Good Luck!";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"How To Play"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
    
    // Play alert sound
    NSString *path = [[NSBundle mainBundle] pathForResource:@"alert" ofType:@"wav"];    
    SystemSoundID theSound;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &theSound);
    AudioServicesPlaySystemSound (theSound);

} // End infoAlert

//====== Picker Methods =======

#pragma mark -
#pragma mark Picker Data Source Methods

/*
 * numberOfComponentsInPickerView - returns 1 
 * as the number of components in picker
 */
-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
    
} // End numberOfComponentsInPickerView

/*
 * pickerView: numberOfRowsInComponent - Returns number
 * of rows in the component
 */
-(NSInteger) pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return [self.pickerData count];
    
} // End pickerView: numberOfRowsInComponent

#pragma mark Picker Delegate Methods
/*
 * pickerView: viewForRow: forComponent: reusingView: - 
 * Returns the object to be displayed in row for component
 */
-(UIView*) pickerView:(UIPickerView *)pickerView
           viewForRow:(NSInteger)row
         forComponent:(NSInteger)component
          reusingView:(UIView *)view
{
    return [self.pickerData objectAtIndex:row];
    
} // End pickerView: viewForRow: forComponent: reusingView: - 

/*
 * pickerView: widthForComponent: - Returns
 * 60 as the width for the component
 */
-(CGFloat) pickerView:(UIPickerView *)pickerView
    widthForComponent:(NSInteger)component
{
    return 60.0;
    
} // End pickerView: widthForComponent

@end
