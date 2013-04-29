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
@synthesize pointsLabel;
@synthesize healthLabel;
@synthesize energyLabel;
@synthesize happinessLabel;
@synthesize healthImageView;
@synthesize energryImageView;
@synthesize happinessImageView;

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

-(IBAction) buttonPressed:(id)sender
{    
    // grab button title
    NSString *buttonType = [sender titleForState:UIControlStateNormal];
    
    if ([buttonType isEqualToString: @"play"])
    {
        
    }
    if ([buttonType isEqualToString: @"eat"])
    {
        
    }
    if ([buttonType isEqualToString: @"sleep"])
    {
        
    }
    if ([buttonType isEqualToString: @"pet"])
    {
        
    }
    if ([buttonType isEqualToString: @"walk"])
    {
    
    }
    if ([buttonType isEqualToString: @"wake up"])
    {
        
    }

}


@end
