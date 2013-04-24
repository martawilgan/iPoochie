//
//  ClosetViewController.m
//  iPoochie
//
//  Created by marta wilgan on 4/17/13.
//  Copyright (c) 2013 NYU. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "ClosetViewController.h"
#import "AppDelegate.h"

//#define itemImagesFileName  @"items.plist"

@interface ClosetViewController ()

@end

@implementation ClosetViewController
@synthesize itemImageNames, itemAmounts, imageNames, amounts;

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
    
    // Create temp array
    NSArray *tempArray = [[NSArray alloc] init];
    self.itemImageNames = tempArray;
    self.itemAmounts = tempArray;
    
    // Grab data from plist through app delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.itemImageNames = [appDelegate.itemsData objectForKey:@"imageNames"];
    self.itemAmounts = [appDelegate.itemsData objectForKey:@"amounts"];
    
    // Create the arrays to display
    NSMutableArray *theImageNames = [[NSMutableArray alloc] init];
    NSMutableArray *theAmounts = [[NSMutableArray alloc] init];
    
    int nextIndex = 0;
    
    // If amount > 0 at index add to theImageNames and theAmounts
    for(int i = 0; i < [itemImageNames count]; i++)
    {
        if([itemAmounts[i] intValue] != 0)
        {
            NSString *name = [itemImageNames objectAtIndex:i];
            NSNumber *amount = [itemAmounts objectAtIndex:i];
            
            [theImageNames insertObject:name atIndex: nextIndex];
            [theAmounts insertObject:amount atIndex: nextIndex];
            
            nextIndex++; // update index
        }
    }
    
    self.imageNames = theImageNames;
    self.amounts = theAmounts;
    
   /* for(int i = 0; i < [imageNames count]; i++)
    {
        NSLog(@" %@", imageNames[i]);
        NSLog(@" %@", amounts[i]);
    }*/
}

-(void) viewDidAppear: (BOOL) animated
{    
    [super viewDidAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.itemImageNames = nil;
    self.itemAmounts = nil;
    self.imageNames = nil;
    self.amounts = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - 
#pragma mark Table View Data Source Methods

// Return the number of rows in each table view for the Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.imageNames count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
    NSString *amount = [[self.amounts objectAtIndex:indexPath.row] stringValue];
	cell.textLabel.text = amount;
    
    return cell;
}

// Define the height for each row
- (CGFloat) tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

@end
