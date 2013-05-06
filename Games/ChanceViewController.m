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

int randPoints;
NSNumber *newPoints;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)viewCard:(UIButton *)sender {
    int fromPoints = -100;
    int toPoints = 150;
    
    UIImage *cardImage = [UIImage imageNamed: @"chance_card.png"];
    [chanceCard setImage: cardImage];
    
    // Create the app delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Get current data
    NSMutableDictionary *gameData = [[NSMutableDictionary alloc]
                                     initWithContentsOfFile: [appDelegate gameDataPath]];
    
    //Generating random points from range [-20,150]
    randPoints = (arc4random() % (toPoints - fromPoints)) + fromPoints;
    newPoints = [NSNumber numberWithInt: randPoints];
    
    if(randPoints < 0){
        chanceLabel.text = [NSString stringWithFormat: @"YOU JUST LOST: %d points", -1*randPoints];
        [chanceImage setImage: [UIImage imageNamed: @"lost.png"]];
        
        // Play lose sound
        NSString *path = [ [NSBundle mainBundle] pathForResource:@"lose" ofType:@"wav"];
        SystemSoundID theSound;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &theSound);
        AudioServicesPlaySystemSound (theSound);
    }
    if(randPoints > 0){
        chanceLabel.text = [NSString stringWithFormat: @"YOU JUST WON: %d points!!!", randPoints];
        [chanceImage setImage: [UIImage imageNamed: @"won.png"]];
        
        // Play win sound
        NSString *path = [ [NSBundle mainBundle] pathForResource:@"win" ofType:@"wav"];
        SystemSoundID theSound;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &theSound);
        AudioServicesPlaySystemSound (theSound);
    }
    if(randPoints == 0){
        chanceLabel.text = [NSString stringWithFormat: @"YOU DIDN'T LOSE OR WIN ANY POINTS"];
        [chanceImage setImage: [UIImage imageNamed: @"shrug.png"]];
        
        // Play whimper sound
        NSString *path = [ [NSBundle mainBundle] pathForResource:@"whimper" ofType:@"wav"];
        SystemSoundID theSound;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &theSound);
        AudioServicesPlaySystemSound (theSound);
    }
    
    
    points = [NSNumber numberWithInt: [points intValue] + [newPoints intValue]];
    [gameData setObject:points
                 forKey:@"points"];
    [gameData writeToFile:[appDelegate gameDataPath] atomically:NO];
    pointsLabel.text =
    [NSString stringWithFormat:@"Points: %@", points];
}
@end
