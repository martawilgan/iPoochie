//
//  InteractViewController.h
//  iPoochie
//
//  Created by marta wilgan on 4/17/13.
//  Copyright (c) 2013 NYU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "AppDelegate.h"
#import "EatViewController.h"
#import "PetViewController.h"
#import "PlayViewController.h"
#import "WalkViewController.h"

@interface InteractViewController : UIViewController

// Variables
@property (strong, nonatomic) NSNumber *points;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSDate *timingDate;
@property (strong, nonatomic) NSTimer *energyTimer;
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSMutableDictionary *itemsData;
@property (strong, nonatomic) NSMutableDictionary *gameData;

// Labels
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *healthLabel;
@property (weak, nonatomic) IBOutlet UILabel *energyLabel;
@property (weak, nonatomic) IBOutlet UILabel *happinessLabel;
@property (weak, nonatomic) IBOutlet UILabel *talkLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoPercLabel;

// ImageViews
@property (weak, nonatomic) IBOutlet UIImageView *healthImageView;
@property (weak, nonatomic) IBOutlet UIImageView *energryImageView;
@property (weak, nonatomic) IBOutlet UIImageView *happinessImageView;
@property (weak, nonatomic) IBOutlet UIImageView *petImageView;
@property (weak, nonatomic) IBOutlet UIImageView *talkImageView;
@property (weak, nonatomic) IBOutlet UIImageView *infoBubbleImageView;
@property (weak, nonatomic) IBOutlet UIImageView *infoArrowImageView;
@property (weak, nonatomic) IBOutlet UIImageView *welcomeImageView;

// Buttons
@property (weak, nonatomic) IBOutlet UIButton *eatButton;

//====== Helper methods =======

-(void) hideWelcome;

// Alerts
-(void) alertIfAsleep;
-(void) showAlert;

// Animations
-(void) animateAngry;
-(void) animateAwake;
-(void) animateGoingToSleep;
-(void) animateSleeping;
-(void) animateWakingUp;

// Timer methods
-(void)clearInfo:(NSTimer*)inTimer;
-(void)goingToSleep:(NSTimer*)inTimer;
-(void)wakingUp:(NSTimer*)inTimer;

// Level methods
-(void) changeStateTo:(NSString*) theState;
-(void) levelForType:(NSString*) type
        andDirection:(NSString*) direction
          withBubble:(NSString*) withBubble
     onIntervalStart:(int) start
      andIntervalEnd:(int) end;
-(void) soundForDirection: (NSString*)direction;
-(void) updateEnergy;
-(void) updateEnergyForState;
-(void) updateHappiness;
-(void) updateHealth;
-(void) updateLevelsInPlist;
-(int) changePercentForLevel:(NSString*) level
            andOldPercentage:(int)percentage
                     andTime:(int) time
                 inDirection:(NSString*) direction;
-(NSString*) barsImageName: (int)number;

// Actions
-(IBAction) buttonPressed: (id)sender;
-(IBAction) goToEatView: (id)sender;
-(IBAction) goToPetView: (id)sender;
-(IBAction) goToPlayView: (id)sender;
-(IBAction) goToWalkView: (id)sender;

@end
