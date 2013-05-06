//
//  MatchingViewController.m
//  iPoochie
//
//  Created by Ilana Mannine on 5/3/13.
//  Copyright (c) 2013 NYU. All rights reserved.
//

#import "MatchingViewController.h"
#import "AppDelegate.h"

@interface MatchingViewController ()

@end

@implementation MatchingViewController
@synthesize points;
@synthesize pointsLabel;

int num_matches_left;
/*int card1_pressed, card2_pressed, card3_pressed, card4_pressed, card5_pressed, card6_pressed,card7_pressed, card8_pressed, card9_pressed, card10_pressed, card11_pressed, card12_pressed;*/

int num_clicks, previous_button, current_button;
NSArray *stringArray;
NSMutableArray *numArray;
NSMutableArray *matched;

int cardArray[12];
BOOL match;

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
    
    // set to defaults
    num_clicks = 0;
    previous_button = -1;
    current_button = -1;
    match = NO;

    // Grab points from plist through app delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *gameData = [[NSMutableDictionary alloc]
                                     initWithContentsOfFile: [appDelegate gameDataPath]];
    points = [gameData objectForKey:@"points"];
    
    // Update the points label text
    pointsLabel.text =
    [NSString stringWithFormat:@"Points: %@", points];
    
    //Setting tags of buttons
    [_card1 setTag:0];
    [_card2 setTag:1];
    [_card3 setTag:2];
    [_card4 setTag:3];
    [_card5 setTag:4];
    [_card6 setTag:5];
    [_card7 setTag:6];
    [_card8 setTag:7];
    [_card9 setTag:8];
    [_card10 setTag:9];
    [_card11 setTag:10];
    [_card12 setTag:11];
    
    //Array of image names
    stringArray = [NSArray arrayWithObjects: @"card1.png", @"card2.png", @"card3.png", @"card4.png", @"card5.png", @"card6.png", @"card7.png", @"card8.png", @"card9.png",@"card10.png", @"card11.png", @"card12.png", nil];
    
    //Initializing numArray, which holds indeces of images that are left to randomly choose from to distribute among the cards
    numArray = [[NSMutableArray alloc]init];
    matched = [[NSMutableArray alloc]init];
    
    for(int i = 0; i < 12; i++)
    {
        [numArray addObject: [NSNumber numberWithInt: i]];
        [matched addObject:[NSNumber numberWithInt:0]];
    }
         
    int random;
    int arrayLength = 12;
    
    for(int j = 0; j < 12; j++){
        random = arc4random() % arrayLength;
        cardArray[j] = [[numArray objectAtIndex: random]intValue];
        [numArray removeObjectAtIndex: random];
        arrayLength--;
    }
    
    num_matches_left = 6;

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cardPressed:(UIButton *)sender {
    
    // Set default image
    UIImage *defaultButtonImage = [UIImage imageNamed: @"back_card.png"];
    
    // Clear buttons from previous two clicks if no match
    if(num_clicks == 2)
    {
        if(match == NO)
        {
            UIButton *firstClick = (UIButton *)[self.view viewWithTag:previous_button];
            [firstClick setImage: defaultButtonImage forState:UIControlStateNormal];
            
            UIButton *secondClick = (UIButton *)[self.view viewWithTag:current_button];
            [secondClick setImage: defaultButtonImage forState:UIControlStateNormal];
            
        }
        
        // update for this click
        num_clicks = 0;
    }
    
    num_clicks++; // update for this click
    int tag = [sender tag]; // find button's tag
    
    if(num_clicks == 1)
        previous_button = tag;
    if(num_clicks == 2)
        current_button = tag;
    
    NSString *cardName =[NSString stringWithFormat:@"%@",[stringArray objectAtIndex: cardArray[tag]]];
    
    NSLog(@"Image Name: %@ Tag: %i", cardName, tag);
    
    UIImage *buttonImage = [UIImage imageNamed:cardName];
    [sender setImage: buttonImage forState: UIControlStateNormal];
    
    // Create the app delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Get current data
    NSMutableDictionary *gameData = [[NSMutableDictionary alloc]
                                     initWithContentsOfFile: [appDelegate gameDataPath]];
    
    NSLog(@"Number of clicks: %i", num_clicks);
    int previousMatched = [[matched objectAtIndex:cardArray[previous_button]] intValue];
    int currentMatched = [[matched objectAtIndex:cardArray[current_button]]intValue];
    
    NSLog(@"Previous matched: %i Current matched %i", previousMatched, currentMatched);
    
    // On second click make sure not already matched
    if(num_clicks == 2 && previousMatched == 0 && currentMatched == 0)
    {
        if((cardArray[current_button] == (cardArray[previous_button] - 6)) || (cardArray[current_button] == (cardArray[previous_button] + 6)))
        {
            
            NSLog(@"match");
            match = YES;
            
            // Set both to matched
            [matched replaceObjectAtIndex:cardArray[previous_button]
                               withObject:[NSNumber numberWithInt:1]];
            [matched replaceObjectAtIndex:cardArray[current_button]
                               withObject:[NSNumber numberWithInt:1]];
            
            if(num_matches_left > 0)
                num_matches_left--;
        }
        else if((cardArray[current_button] != (cardArray[previous_button] - 6)) && (cardArray[current_button] != (cardArray[previous_button] + 6)))
        {
            NSLog(@"no match");
            match = NO;
            
        }
        
        if(num_matches_left == 0){
            NSString *message = @"CONGRATULATIONS!";
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"YOU WON 100 POINTS!!!"
                                                            message: message
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles: nil];
            [alert show];
            
            //Set points
            points = [NSNumber numberWithInt: [points intValue] + 100];
            [gameData setObject:points
                         forKey:@"points"];
            [gameData writeToFile:[appDelegate gameDataPath] atomically:NO];
            pointsLabel.text =
            [NSString stringWithFormat:@"Points: %@", points];

            
        }
    }
}

- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
