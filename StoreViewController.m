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
@synthesize pickerData;


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
    NSArray *tempArray = [[NSArray alloc] init];
    self.items = tempArray;
    self.prices = tempArray;
    
    // Grab data from plist through app delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.items = [appDelegate.itemsData objectForKey:@"imageNames"];
    self.prices = [appDelegate.itemsData objectForKey:@"prices"];
    
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
        theLabel.font = [UIFont fontWithName:@"Chalkboard SE" size:16];
        theLabel.backgroundColor = [UIColor clearColor];
        
        // create a view
        UIView *theView = [[UIView alloc] init];
        
        // add imageView and label as subviews
        [theView addSubview: theImageView];
        [theView addSubview: theLabel];
        //[theView bringSubviewToFront:theLabel];
        
        [pickerDataArray insertObject:theView atIndex:i];
    }
    
    self.pickerData = pickerDataArray;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
