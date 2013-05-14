//
//  PetViewController.h
//  iPoochie
//
//  Created by marta wilgan on 4/29/13.
//  Copyright (c) 2013 NYU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "AppDelegate.h"

@interface PetViewController : UIViewController

// Variables
@property (strong, nonatomic) NSNumber *points;
@property (strong, nonatomic) NSArray *wagging1;
@property (strong, nonatomic) NSArray *wagging2;
@property (strong, nonatomic) NSDate *timingDate;
@property (strong, nonatomic) NSDate *timeInView;
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSMutableDictionary *gameData;

// Labels
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *talkLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *happinessLabel;
@property (weak, nonatomic) IBOutlet UILabel *happinessStatLabel;

// Buttons
@property (weak, nonatomic) IBOutlet UIButton *backButton;

// ImageViews
@property (weak, nonatomic) IBOutlet UIImageView *talkImageView;
@property (weak, nonatomic) IBOutlet UIImageView *petImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bubbleImageView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UIImageView *happinessBarImageView;

// Helper Methods
-(NSString*) barsImageName: (int) number;
-(NSString*) nextImageName;
-(void) updateIndex;
-(void) updateHappinessForTime:(int)time;
-(void) hideBubble:(NSTimer*)inTimer;
-(void) petting:(NSTimer*)inTimer;
-(void) stopped:(NSTimer*)inTimer;

// Actions
-(IBAction)goBack: (id)sender;

// Touch Methods
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;


@end
