//
//  ClosetViewController.m
//  iPoochie
//
//  Created by marta wilgan on 4/17/13.
//  Copyright (c) 2013 NYU. All rights reserved.
//

#import "ClosetViewController.h"

@interface ClosetViewController ()

@end

@implementation ClosetViewController
@synthesize itemImageNames;
@synthesize itemAmounts;
@synthesize imageNames;
@synthesize itemDescriptions;
@synthesize amounts;
@synthesize closet;
@synthesize descriptions;
@synthesize points;
@synthesize pointsLabel;
@synthesize closetImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization        
    }
    return self;
}

- (void)viewDidLoad
{

    [super viewDidLoad];    
    // Do any additional setup after loading the view from its nib.    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];    
}

-(void) viewDidAppear: (BOOL) animated
{    
    [super viewDidAppear:animated];
    
    //closetImageView.hidden = NO;
    closetImageView.alpha = 100;
    
    // Play door sound
    NSString *path = [ [NSBundle mainBundle] pathForResource:@"door" ofType:@"wav"];
    SystemSoundID theSound;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &theSound);
    AudioServicesPlaySystemSound (theSound);
    
    // Hide the closet image
    [self hideCloset];
    
    // Grab points from plist through app delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *gameData = [[NSMutableDictionary alloc]
                                     initWithContentsOfFile: [appDelegate gameDataPath]];
    points = [gameData objectForKey:@"points"];
    
    // Update the points label text
    pointsLabel.text =
    [NSString stringWithFormat:@"Points: %@", points];
    
    [self currentData];
    [closet reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.itemImageNames = nil;
    self.itemAmounts = nil;
    self.itemDescriptions = nil;
    self.imageNames = nil;
    self.amounts = nil;
    self.descriptions = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 * currentData - Grabs data from items plist and 
 * keeps only items with amount > 0
 */
- (void) currentData
{
    // Create temp array
    NSArray *tempArray = [[NSArray alloc] init];
    self.itemImageNames = tempArray;
    self.itemAmounts = tempArray;
    self.itemDescriptions = tempArray;
    
    // Grab data from plist through app delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *itemsData = [[NSMutableDictionary alloc]
                                      initWithContentsOfFile: [appDelegate itemsDataPath]];
    self.itemImageNames = [itemsData objectForKey:@"imageNames"];
    self.itemAmounts = [itemsData objectForKey:@"amounts"];
    self.itemDescriptions = [itemsData objectForKey:@"descriptions"];
    
    // Create the arrays to display
    NSMutableArray *theImageNames = [[NSMutableArray alloc] init];
    NSMutableArray *theAmounts = [[NSMutableArray alloc] init];
    NSMutableArray *theDescriptions = [[NSMutableArray alloc] init];
    
    int nextIndex = 0;
    
    // If amount > 0 at index add to theImageNames and theAmounts
    for(int i = 0; i < [itemImageNames count]; i++)
    {
        if([itemAmounts[i] intValue] != 0)
        {
            NSString *name = [itemImageNames objectAtIndex:i];
            NSNumber *amount = [itemAmounts objectAtIndex:i];
            NSString *description = [itemDescriptions objectAtIndex:i];
            
            [theImageNames insertObject:name atIndex: nextIndex];
            [theAmounts insertObject:amount atIndex: nextIndex];
            [theDescriptions insertObject:description atIndex:nextIndex];
            
            nextIndex++; // update index
        }
    }
    
    self.imageNames = theImageNames;
    self.amounts = theAmounts;
    self.descriptions = theDescriptions;
    
} // End currentData

/*
 * hideCloset - Fades the closet image out
 */
-(void) hideCloset
{    
    // Fade image out
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:2.0];
    [closetImageView setAlpha:0];
    [UIView commitAnimations];
    
} // End hideCloset

#pragma mark - 
#pragma mark Table View Data Source Methods

/* 
 * numberOfSectionsInTableView - Returns number of sections in table
 */
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
} // End numberOfSectionsInTableView

/*
 * tableView: numberOfRowsInSection - Returns number of rows 
 * in each table view for the Delegate
 */
-(NSInteger) tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.imageNames count];
    
} // End tableView: numberOfRowsInSection

/*
 * tableView: cellForRowAtIndexPath: - 
 * Customizes the appearance of table view cells
 */
- (UITableViewCell *) tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    // Create the empty cell
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Create cell if no cell available
    if(cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
              reuseIdentifier:CellIdentifier];
    }
    
    // Add image to cell
    NSString *imageName = [self.imageNames objectAtIndex:indexPath.row];
    UIImage *myImage = [UIImage imageNamed:imageName];
	cell.imageView.image = myImage;
    
    // Add text to cell
	cell.textLabel.text = [NSString stringWithFormat: @"  %@ %@",
        [[self.amounts objectAtIndex:indexPath.row] stringValue],
        [self.descriptions objectAtIndex:indexPath.row]];
    
    // Update appearence of cell
    cell.textLabel.font = [UIFont fontWithName:@"Chalkboard SE" size:27];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
} // End tableView: cellForRowAtIndexPath:

// Define the height for each row
/*-(CGFloat) tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}*/


@end
