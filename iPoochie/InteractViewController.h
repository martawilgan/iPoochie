//
//  InteractViewController.h
//  iPoochie
//
//  Created by marta wilgan on 4/17/13.
//  Copyright (c) 2013 NYU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InteractViewController : UIViewController

@property (strong, nonatomic) NSNumber *points;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSDate *timingDate;

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

- (void) updateHealth;
- (void) updateEnergy;
- (void) updateHappiness;

- (NSString*) barsImageName: (int)number;

// Actions
-(IBAction)buttonPressed: (id)sender;
-(IBAction)goToEatView: (id)sender;
-(IBAction)goToPetView: (id)sender;
-(IBAction)goToPlayView: (id)sender;
-(IBAction)goToWalkView: (id)sender;

@end
