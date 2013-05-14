//
//  StoreViewController.m
//  iPoochie
//
//  Created by marta wilgan on 4/17/13.
//  Copyright (c) 2013 NYU. All rights reserved.
//

#import "StoreViewController.h"
#import "AppDelegate.h"

@interface StoreViewController ()

@end

@implementation StoreViewController
@synthesize itemPicker;
@synthesize items;
@synthesize prices;
@synthesize amounts;
@synthesize pickerData;
@synthesize pointsLabel;
@synthesize points;
@synthesize shopImageView;


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
    
    // Create temp arrays
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    self.items = tempArray;
    self.prices = tempArray;
    self.amounts = tempArray;
    
    // Grab data from plist through app delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *itemsData = [[NSMutableDictionary alloc]
        initWithContentsOfFile: [appDelegate itemsDataPath]];
    self.items = [itemsData objectForKey:@"imageNames"];
    self.prices = [itemsData objectForKey:@"prices"];
    self.amounts = [itemsData objectForKey:@"amounts"];
    
    // create the pickerData array
    NSMutableArray *pickerDataArray = [[NSMutableArray alloc] init];
    
    for(int i = 0; i< items.count; i++)
    {
        // create an image
        UIImage *theImage = [UIImage imageNamed:[self.items objectAtIndex :i]];
        
        // create an imageview
        UIImageView *theImageView = [[UIImageView alloc] initWithImage:theImage];
        
        // create a label
        UILabel *theLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 300, 20)];
        theLabel.text = [NSString stringWithFormat:@" %@ points",[self.prices objectAtIndex:i]];
        theLabel.font = [UIFont fontWithName:@"Chalkboard SE" size:22];
        theLabel.backgroundColor = [UIColor clearColor];
        
        // create a view
        UIView *theView = [[UIView alloc] init];
        
        // add imageView and label as subviews
        [theView addSubview: theImageView];
        [theView addSubview: theLabel];
        
        [pickerDataArray insertObject:theView atIndex:i];
    }
    
    self.pickerData = pickerDataArray;

}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Play cash register sound
    NSString *path = [ [NSBundle mainBundle] pathForResource:@"register1" ofType:@"mp3"];
    SystemSoundID theSound;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &theSound);
    AudioServicesPlaySystemSound (theSound);
    
    shopImageView.alpha = 100;
    
    // Hide the shop image
    [self hideShop];
    
    // Grab points from plist through app delegate
    AppDelegate *appDelegate =
        (AppDelegate *)[[UIApplication sharedApplication] delegate];
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

/* 
 * hideShop - Fades the shop image out
 */
-(void) hideShop
{
    // Fade image out
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:2.0];
    [shopImageView setAlpha:0];
    [UIView commitAnimations];
    
} // End hideShope

/* 
 * buttonPressed -  Updates changes for purchase 
 * if enough points available, otherwise shows alert
 */
-(IBAction)buttonPressed
{
    // Find the row
    NSInteger theRow = [itemPicker selectedRowInComponent:0];
    
    // Create the app delegate
    AppDelegate *appDelegate =
        (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Get current data
    NSMutableDictionary *itemsData = [[NSMutableDictionary alloc]
        initWithContentsOfFile: [appDelegate itemsDataPath]];
    NSMutableDictionary *gameData = [[NSMutableDictionary alloc]
        initWithContentsOfFile: [appDelegate gameDataPath]];
    
    // Get prices and points
    self.prices = [itemsData objectForKey:@"prices"];
    self.points = [gameData objectForKey:@"points"];
    
    NSString *path; // path for sound
    
    // If enough points, grant the purchase
    if ([prices[theRow] intValue] <= [points intValue])
    {
        // Update points
        NSNumber *newPoints = [NSNumber numberWithInt:
            [points intValue] - [prices[theRow] intValue]];
        [gameData setObject:newPoints
                      forKey:@"points"];
        [gameData writeToFile:[appDelegate gameDataPath] atomically:NO];
        
        // Update the points label text
        pointsLabel.text =
            [NSString stringWithFormat:@"Points: %@", newPoints];
        
        // Get amounts
        self.amounts = [itemsData objectForKey:@"amounts"];
        
        // Update amount of item
        NSNumber *newAmount = [NSNumber numberWithInt:[amounts[theRow] intValue] + 1];
        [self.amounts replaceObjectAtIndex: theRow withObject: newAmount];
        [itemsData setObject:amounts
                     forKey:@"amounts"];
        
        // Update number of items to play with
        NSNumber *itemsToPlayWith = [itemsData objectForKey:@"itemsToPlayWith"];
        itemsToPlayWith = [NSNumber numberWithInt:([itemsToPlayWith intValue] + 1)];
        [itemsData setObject:itemsToPlayWith forKey:@"itemsToPlayWith"];
        
        [itemsData writeToFile:[appDelegate itemsDataPath] atomically:NO];
        
        // Set path for cash register sound
        path = [ [NSBundle mainBundle] pathForResource:@"register2" ofType:@"mp3"];

    }
    else
    {
        // Create alert for not enough points to purchase
        NSString *message = [NSString stringWithFormat:
            @"You need %@ but only have %@ points", prices[theRow], points];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry! No purchase "
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"Done"
                                              otherButtonTitles: nil];
        [alert show];
        
        // Set alert sound path
        path = [[NSBundle mainBundle] pathForResource:@"alert" ofType:@"wav"];
        
    }
    
    // Play sound
    SystemSoundID theSound;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &theSound);
    AudioServicesPlaySystemSound (theSound);
    
} // End buttonPressed

#pragma mark -
#pragma mark Picker Data Source Methods
/*
 * numberOfComponentsInPickerView - returns the number of
 * column components in picker
 */
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
    
} // End numberOfComponentsInPickerView

/*
 * pickerView: numberOfRowsInComponent - returns the
 * number of rows for component
 */
-(NSInteger) pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{    
    return [self.items count];
    
} // End numberOfRowsInComponent

#pragma mark Picker Delegate Methods
/*
 * pickerView: viewForRow: forComponent: reusingView
 * returns item to be displayed in row for component
 */
-(UIView *)pickerView:(UIPickerView *)pickerView
           viewForRow:(NSInteger)row
         forComponent:(NSInteger)component
          reusingView:(UIView *)view
{
    return [self.pickerData objectAtIndex:row];
    
} // End pickerView: viewForRow: forComponent: reusingView

@end
