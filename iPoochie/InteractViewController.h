//
//  InteractViewController.h
//  iPoochie
//
//  Created by marta wilgan on 4/17/13.
//  Copyright (c) 2013 NYU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InteractViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (strong, nonatomic) NSNumber *points;
@property (weak, nonatomic) IBOutlet UILabel *healthLabel;
@property (weak, nonatomic) IBOutlet UILabel *energyLabel;
@property (weak, nonatomic) IBOutlet UILabel *happinessLabel;

@property (weak, nonatomic) IBOutlet UIImageView *healthImageView;
@property (weak, nonatomic) IBOutlet UIImageView *energryImageView;
@property (weak, nonatomic) IBOutlet UIImageView *happinessImageView;
@property (weak, nonatomic) IBOutlet UIImageView *petImageView;





- (void) updateHealth;
- (void) updateEnergy;
- (void) updateHappiness;
- (NSString*) barsImageName: (int)number;
-(IBAction)buttonPressed: (id)sender;

@end
