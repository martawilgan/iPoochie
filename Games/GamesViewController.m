//
//  GamesViewController.m
//  iPoochie
//
//  Created by marta wilgan on 4/17/13.
//  Copyright (c) 2013 NYU. All rights reserved.
//

#import "GamesViewController.h"
#import "AppDelegate.h"
#import "MatchingViewController.h"
#import "ChanceViewController.h"

@interface GamesViewController ()

@end

@implementation GamesViewController
@synthesize points;
@synthesize pointsLabel;

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
 * matchingGame - Makes the MatchingViewController the presentViewController
 */
- (IBAction)matchingGame:(UIButton *)sender {
    
    MatchingViewController *matchingViewController =
        [[MatchingViewController alloc] init];
    [self presentViewController:matchingViewController animated:YES completion:NULL];
    
} // End matchingGame

/*
 * chanceGame - Makes the ChanceViewController the presentViewController
 */
- (IBAction)chanceGame:(UIButton *)sender {
    
    ChanceViewController *chanceViewController = [[ChanceViewController alloc] init];
    [self presentViewController:chanceViewController animated:YES completion:NULL];
    
} // End chanceGame
@end
