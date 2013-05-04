//
//  PetViewController.m
//  iPoochie
//
//  Created by marta wilgan on 4/29/13.
//  Copyright (c) 2013 NYU. All rights reserved.
//

#import "PetViewController.h"
#import "AppDelegate.h"

@interface PetViewController ()

@end

@implementation PetViewController
@synthesize points;
@synthesize pointsLabel;
@synthesize talkLabel;
@synthesize petImageView;
@synthesize talkImageView;
@synthesize wagging1;
@synthesize wagging2;

int gCurrentIndex = 0; // current index for wagging array
int gCurrentArray = 0; // current wagging array

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
    
    // Create wagging1
    NSArray *wagging1Array = [[NSArray alloc] initWithObjects:  @"wagging1A.png",
                                                                @"wagging1B.png",
                                                                @"wagging1C.png",
                                                                @"wagging1D.png",
                                                                @"wagging1E.png",
                                                                @"wagging1F.png",
                                                                @"wagging1G.png",
                                                                @"wagging1H.png",
                                                                @"wagging1I.png",
                                                                        nil];
    self.wagging1 = wagging1Array;
    
    
    
    // Create wagging2
    NSArray *wagging2Array = [[NSArray alloc] initWithObjects:  @"wagging2A.png",
                                                                @"wagging2B.png",
                                                                @"wagging2C.png",
                                                                @"wagging2D.png",
                                                                @"wagging2E.png",
                                                                @"wagging2F.png",
                                                                @"wagging2G.png",
                                                                @"wagging2H.png",
                                                                @"wagging2I.png",
                                                                @"wagging2J.png",
                                                                        nil];
    self.wagging2 = wagging2Array;
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

// Go back to interactViewController
-(IBAction)goBack: (id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Return image name for current index in current array
-(NSString*) nextImageName
{
    NSString *imageName = @"";
    
    if(gCurrentArray == 1)
    {
        imageName = wagging1[gCurrentIndex];
    }
    else if(gCurrentArray == 2)
    {
        imageName = wagging2[gCurrentIndex];
    }
    
    return imageName;
}

// Increment index, switch to other array if last index in array
-(void) updateIndex
{
    // if not last index in wagging1
    if(gCurrentArray == 1 && gCurrentIndex < ([wagging1 count]-1))
    {
        gCurrentIndex++;
    }
    // else if last index in wagging1
    else if(gCurrentArray == 1 && gCurrentIndex == ([wagging1 count]-1))
    {
        gCurrentIndex = 0;
        gCurrentArray = 2;
    }
    // else if not last index in wagging2
    else if(gCurrentArray == 2 && gCurrentIndex < ([wagging2 count]-1))
    {
        gCurrentIndex++;
    }
    // else if last index in wagging2
    else if(gCurrentArray == 2 && gCurrentIndex == ([wagging2 count]-1))
    {
        gCurrentIndex = 0;
        gCurrentArray = 1;
    }
}

// Wait then change image in petImageView
-(void)petting:(NSTimer*)inTimer
{
    [inTimer invalidate];
    inTimer = nil;
    
    // change image
    NSString *imageName = [self nextImageName];
    petImageView.image = [UIImage imageNamed:imageName];
    [self updateIndex]; // update the array index
}

// Wait then complete animation
-(void)stopped:(NSTimer*)inTimer
{
    [inTimer invalidate];
    inTimer = nil;
    
    // Wake up and stop being angry if angry
    petImageView.image = [UIImage imageNamed:@"blinking4A.png"];
}

#pragma mark -

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    
    // touch for petImageView
	if ([touch view] == petImageView)
    {
        NSLog(@"\nTouches began");
        gCurrentIndex = 0;  // index starts at 0
        gCurrentArray = 1;
        talkLabel.text = @" ";
        talkImageView.hidden = YES;
    }
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"\nTouches cancelled");
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    
    // touch for petImageView
	if ([touch view] == petImageView)
    {
        NSLog(@"\nTouches ended");
        
        // Wait then change image for petImageView twice
        [NSTimer scheduledTimerWithTimeInterval:.3 target:self
                                       selector:@selector(stopped:)
                                       userInfo:nil repeats:NO];
        petImageView.image = [UIImage imageNamed:@"blinking4C.png"];
    }
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    
    // Touch Action for petImageView
	if ([touch view] == petImageView)
    {
        NSLog(@"\nTouches moved");
        
        // Wait then change image for petImageView
        [NSTimer scheduledTimerWithTimeInterval:.1 target:self
                                       selector:@selector(petting:)
                                       userInfo:nil repeats:NO];
    }
}


@end
