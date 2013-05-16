//
//  ChanceViewController.m
//  iPoochie
//
//  Created by Ilana Mannine on 5/4/13.
//  Copyright (c) 2013 NYU. All rights reserved.
//

#import "ChanceViewController.h"
#import "AppDelegate.h"

@interface ChanceViewController ()

@end

@implementation ChanceViewController
@synthesize points;
@synthesize pointsLabel;
@synthesize chanceCard;
@synthesize chanceImage;
@synthesize chanceLabel;

// Global variables
int randPoints;         // random points won or lost
NSNumber *newPoints;    // random points as NSNumber

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
 * goBack - Goes back to the previous viewcontroller
 */
- (IBAction)goBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
} // End goBack

/*
 * viewCard - Shows the chance card and update points accordingly
 */
- (IBAction)viewCard:(UIButton *)sender {
    int fromPoints = -150;
    int toPoints = 150;
    
    // Create and set the card image
    UIImage *cardImage = [UIImage imageNamed: @"chance_card.png"];
    [chanceCard setImage: cardImage];
    
    // Create the app delegate
    AppDelegate *appDelegate =
        (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Get current data
    NSMutableDictionary *gameData = [[NSMutableDictionary alloc]
        initWithContentsOfFile: [appDelegate gameDataPath]];
    
    //Generating random points from range
    randPoints = (arc4random() % (toPoints - fromPoints)) + fromPoints;
    newPoints = [NSNumber numberWithInt: randPoints];
    
    NSString *path; // Path for sound
    
    // Points lost
    if(randPoints < 0){
        
        // Make sure points do not go below 0
        if(randPoints + [points intValue] < 0)
        {
            randPoints = [points intValue];
            newPoints = [NSNumber numberWithInt: randPoints];
        }
        
        chanceLabel.text = [NSString stringWithFormat: @"YOU JUST LOST: %d points", -1*randPoints];
        [chanceImage setImage: [UIImage imageNamed: @"lost.png"]];
        
        // Path for losing sound
        path = [[NSBundle mainBundle] pathForResource:@"whimper" ofType:@"wav"];
    }
    // Points won
    if(randPoints > 0){
        chanceLabel.text = [NSString stringWithFormat: @"YOU JUST WON: %d points!!!", randPoints];
        [chanceImage setImage: [UIImage imageNamed: @"won.png"]];
        
        // Path for winning sound
        path = [[NSBundle mainBundle] pathForResource:@"win" ofType:@"wav"];
    }
    // No change
    if(randPoints == 0){
        chanceLabel.text = [NSString stringWithFormat: @"YOU DIDN'T LOSE OR WIN ANY POINTS"];
        [chanceImage setImage: [UIImage imageNamed: @"shrug.png"]];
        
        // Path for not winning or losing sound
        path = [[NSBundle mainBundle] pathForResource:@"down" ofType:@"wav"];
    }
    
    // Play the sound
    SystemSoundID theSound;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &theSound);
    AudioServicesPlaySystemSound (theSound);
    
    // Update the points
    points = [NSNumber numberWithInt: [points intValue] + [newPoints intValue]];
    [gameData setObject:points forKey:@"points"];
    [gameData writeToFile:[appDelegate gameDataPath] atomically:NO];
    pointsLabel.text =
        [NSString stringWithFormat:@"Points: %@", points];
    
} // End viewCard
@end
