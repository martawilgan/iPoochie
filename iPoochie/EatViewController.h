//
//  EatViewController.h
//  iPoochie
//
//  Created by marta wilgan on 4/29/13.
//  Copyright (c) 2013 NYU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <AudioToolbox/AudioToolbox.h>
#import "AppDelegate.h"

#define kAccelerationThreshold      1.7
#define kUpdateInterval             (1.0f / 10.0f)

@interface EatViewController : UIViewController <UIAccelerometerDelegate>

// Variables
@property (assign, nonatomic) BOOL fullBowl;
@property (strong, nonatomic) UIImage *empty;
@property (strong, nonatomic) UIImage *full;
@property (strong, nonatomic) NSArray *shakes;
@property (strong, nonatomic) NSNumber *points;
@property (strong, nonatomic) NSDate *timeInView;
@property (strong, nonatomic) CMMotionManager *motionManager;
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSMutableDictionary *itemsData;
@property (strong, nonatomic) NSMutableDictionary *gameData;

// Labels
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *bagsLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoBubbleLabel;

// Buttons
@property (weak, nonatomic) IBOutlet UIButton *backButton;

// Image Views
@property (weak, nonatomic) IBOutlet UIImageView *bowlImageView;
@property (weak, nonatomic) IBOutlet UIImageView *petImageView;
@property (weak, nonatomic) IBOutlet UIImageView *infoBubbleImageView;

//====== Helper methods =======

// Alerts to user
-(void) hideInfoBubble;
-(void) showInfoBubble;
-(void) showInfoBubbleWith:(NSString *) message;
-(void) showNoChowAlert:(NSString *)string;

// Animations
-(void) animateEating;

// Plist Updates
-(void) updateEnergy;
-(void) useBag;

// Sounds
-(void) playAlertSound;
-(void) playHappyBarkSound;

// Timer methods
-(void)clearBowl:(NSTimer*)inTimer;

// Actions
-(IBAction) goBack: (id)sender;
-(IBAction) eat:(id)sender;

@end
