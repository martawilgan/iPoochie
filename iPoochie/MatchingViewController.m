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
int card1_pressed, card2_pressed, card3_pressed, card4_pressed, card5_pressed, card6_pressed,card7_pressed, card8_pressed, card9_pressed, card10_pressed, card11_pressed, card12_pressed;

int num_clicks;
NSArray *stringArray;
NSMutableArray *numArray;
int cardArray[12];

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
    
    //Array of image names
    stringArray = [NSArray arrayWithObjects: @"card1.png", @"card2.png", @"card3.png", @"card4.png", @"card5.png", @"card6.png", @"card7.png", @"card8.png", @"card9.png",@"card10.png", @"card11.png", @"card12.png", nil];
    
    //Initializing numArray, which holds indeces of images that are left to randomly choose from to distribute among the cards
    numArray = [[NSMutableArray alloc]init];
    for(int i = 0; i < 12; i++)
        [numArray addObject: [NSNumber numberWithInt: i]];
        
    int random;
    int arrayLength = 12;
    
    for(int j = 0; j < 12; j++){
        random = arc4random() % arrayLength;
        cardArray[j] = [[numArray objectAtIndex: random]intValue];
        [numArray removeObjectAtIndex: random];
        arrayLength--;
    }
    
    num_matches_left = 12;

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)card1:(UIButton *)sender {
    num_clicks++;
    card1_pressed = 1;
    
    UIImage *buttonImage = [UIImage imageNamed: [stringArray objectAtIndex: cardArray[0]]];
    UIImage *buttonImage2 = [UIImage imageNamed: @"back_card.png"];
    [sender setImage: buttonImage forState: UIControlStateNormal];
    //[_card1 setImage: buttonImage2];
    
    if(num_clicks == 2){
        if(card2_pressed == 1){
            if(cardArray[0] == (cardArray[1] - 6) || cardArray[0] == (cardArray[1] + 6)){
                num_matches_left--;
            }
            else{
                [sender setImage: buttonImage2 forState: UIControlStateNormal];
            }
        }
        if(card3_pressed == 1){
            if(cardArray[0] == (cardArray[2] - 6) || cardArray[0] == (cardArray[2] + 6)){
                num_matches_left--;
            }
            else{
                [sender setImage: buttonImage2 forState: UIControlStateNormal];
            }
        }
        if(card4_pressed == 1){
            if(cardArray[0] == (cardArray[3] - 6) || cardArray[0] == (cardArray[3] + 6)){
                num_matches_left--;
            }
            else{
                [sender setImage: buttonImage2 forState: UIControlStateNormal];
            }
        }
        if(card5_pressed == 1){
            if(cardArray[0] == (cardArray[4] - 6) || cardArray[0] == (cardArray[4] + 6)){
                num_matches_left--;
            }
            else{
                [sender setImage: buttonImage2 forState: UIControlStateNormal];
            }
        }
        if(card6_pressed == 1){
            if(cardArray[0] == (cardArray[5] - 6) || cardArray[0] == (cardArray[5] + 6)){
                num_matches_left--;
            }
            else{
                [sender setImage: buttonImage2 forState: UIControlStateNormal];
            }
        }
        if(card7_pressed == 1){
            if(cardArray[0] == (cardArray[6] - 6) || cardArray[0] == (cardArray[6] + 6)){
                num_matches_left--;
            }
            else{
                [sender setImage: buttonImage2 forState: UIControlStateNormal];
            }
        }
        if(card8_pressed == 1){
            if(cardArray[0] == (cardArray[7] - 6) || cardArray[0] == (cardArray[7] + 6)){
                num_matches_left--;
            }
            else{
                [sender setImage: buttonImage2 forState: UIControlStateNormal];
            }
        }
        if(card9_pressed == 1){
            if(cardArray[0] == (cardArray[8] - 6) || cardArray[0] == (cardArray[8] + 6)){
                num_matches_left--;
            }
            else{
                [sender setImage: buttonImage2 forState: UIControlStateNormal];
            }
        }
        if(card10_pressed == 1){
            if(cardArray[0] == (cardArray[9] - 6) || cardArray[0] == (cardArray[9] + 6)){
                num_matches_left--;
            }
            else{
                [sender setImage: buttonImage2 forState: UIControlStateNormal];
            }
        }
        if(card11_pressed == 1){
            if(cardArray[0] == (cardArray[10] - 6) || cardArray[0] == (cardArray[10] + 6)){
                num_matches_left--;
            }
            else{
                [sender setImage: buttonImage2 forState: UIControlStateNormal];
            }
        }
        if(card12_pressed == 1){
            if(cardArray[0] == (cardArray[11] - 6) || cardArray[0] == (cardArray[11] + 6)){
                num_matches_left--;
            }
            else{
                [sender setImage: buttonImage2 forState: UIControlStateNormal];
            }
        }
            
    }
}

- (IBAction)card2:(UIButton *)sender {
    num_clicks++;
    card2_pressed = 1;
    
    UIImage *buttonImage = [UIImage imageNamed: [stringArray objectAtIndex: cardArray[1]]];
    [sender setImage: buttonImage forState: UIControlStateNormal];
    
    if(num_clicks > 2){
        num_clicks = 0;
        card2_pressed = 0;
    }
}

- (IBAction)card3:(UIButton *)sender {
    num_clicks++;
    card3_pressed = 1;
    
    
    UIImage *buttonImage = [UIImage imageNamed: [stringArray objectAtIndex: cardArray[2]]];
    [sender setImage: buttonImage forState: UIControlStateNormal];
    
    if(num_clicks > 2){
        num_clicks = 0;
        card3_pressed = 0;
    }
}

- (IBAction)card4:(UIButton *)sender {
    num_clicks++;
    card4_pressed = 1;
    
    
    UIImage *buttonImage = [UIImage imageNamed: [stringArray objectAtIndex: cardArray[3]]];
    [sender setImage: buttonImage forState: UIControlStateNormal];
    
    if(num_clicks > 2){
        num_clicks = 1;
        card4_pressed = 0;
    }
}

- (IBAction)card5:(UIButton *)sender {
    num_clicks++;
    card5_pressed = 1;
    
    
    UIImage *buttonImage = [UIImage imageNamed: [stringArray objectAtIndex: cardArray[4]]];
    [sender setImage: buttonImage forState: UIControlStateNormal];
    
    if(num_clicks > 2){
        num_clicks = 0;
        card5_pressed = 0;
    }
}

- (IBAction)card6:(UIButton *)sender {
    num_clicks++;
    card6_pressed = 1;
    
    
    UIImage *buttonImage = [UIImage imageNamed: [stringArray objectAtIndex: cardArray[5]]];
    [sender setImage: buttonImage forState: UIControlStateNormal];
    
    if(num_clicks > 2){
        num_clicks = 0;
        card6_pressed = 0;
    }
}

- (IBAction)card7:(UIButton *)sender {
    num_clicks++;
    card7_pressed = 1;
    
    
    UIImage *buttonImage = [UIImage imageNamed: [stringArray objectAtIndex: cardArray[6]]];
    [sender setImage: buttonImage forState: UIControlStateNormal];
    
    if(num_clicks > 2){
        num_clicks = 0;
        card7_pressed = 0;
    }
}

- (IBAction)card8:(UIButton *)sender {
    num_clicks++;
    card8_pressed = 1;
    
    UIImage *buttonImage = [UIImage imageNamed: [stringArray objectAtIndex: cardArray[7]]];
    [sender setImage: buttonImage forState: UIControlStateNormal];
    
    if(num_clicks > 2){
        num_clicks = 0;
        card8_pressed = 0;
    }

}

- (IBAction)card9:(UIButton *)sender {
    num_clicks++;
    card9_pressed = 1;
    
    UIImage *buttonImage = [UIImage imageNamed: [stringArray objectAtIndex: cardArray[8]]];
    [sender setImage: buttonImage forState: UIControlStateNormal];
    
    if(num_clicks > 2){
        num_clicks = 0;
        card9_pressed = 0;
    }

}

- (IBAction)card10:(UIButton *)sender {
    num_clicks++;
    card10_pressed = 1;
    
    UIImage *buttonImage = [UIImage imageNamed: [stringArray objectAtIndex: cardArray[9]]];
    [sender setImage: buttonImage forState: UIControlStateNormal];
    
    if(num_clicks > 2){
        num_clicks = 0;
        card10_pressed = 0;
    }

}

- (IBAction)card11:(UIButton *)sender {
    num_clicks++;
    card11_pressed = 1;
    
    UIImage *buttonImage = [UIImage imageNamed: [stringArray objectAtIndex: cardArray[10]]];
    [sender setImage: buttonImage forState: UIControlStateNormal];
    
    if(num_clicks > 2){
        num_clicks = 0;
        card11_pressed = 0;
    }

}

- (IBAction)card12:(UIButton *)sender {
    num_clicks++;
    card12_pressed = 1;
    
    UIImage *buttonImage = [UIImage imageNamed: [stringArray objectAtIndex: cardArray[11]]];
    [sender setImage: buttonImage forState: UIControlStateNormal];
    
    if(num_clicks > 2){
        num_clicks = 0;
        card12_pressed = 0;
    }

}

- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
