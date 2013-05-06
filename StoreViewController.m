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

// Update changes for purchase if enough points available
-(IBAction)buttonPressed
{
    // Find the row
    NSInteger theRow = [itemPicker selectedRowInComponent:0];
    
    // Create the app delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Get current data
    NSMutableDictionary *itemsData = [[NSMutableDictionary alloc]
        initWithContentsOfFile: [appDelegate itemsDataPath]];
    NSMutableDictionary *gameData = [[NSMutableDictionary alloc]
        initWithContentsOfFile: [appDelegate gameDataPath]];
    
    // Get prices and points
    self.prices = [itemsData objectForKey:@"prices"];
    self.points = [gameData objectForKey:@"points"];
    
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
        [itemsData writeToFile:[appDelegate itemsDataPath] atomically:NO];
        
        // Play happy bark sound
        NSString *path = [ [NSBundle mainBundle] pathForResource:@"happy_bark" ofType:@"wav"];
        SystemSoundID theSound;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &theSound);
        AudioServicesPlaySystemSound (theSound);

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
        
        // Play alert sound
        NSString *path = [ [NSBundle mainBundle] pathForResource:@"alert" ofType:@"wav"];
        SystemSoundID theSound;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &theSound);
        AudioServicesPlaySystemSound (theSound);
        
    }
    
}

#pragma mark -
#pragma mark Picker Data Source Methods
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{    
    return [self.items count];
}

#pragma mark Picker Delegate Methods
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row
         forComponent:(NSInteger)component reusingView:(UIView *)view
{
    return [self.pickerData objectAtIndex:row];
}

@end
