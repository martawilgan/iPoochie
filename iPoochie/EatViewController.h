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

#define kAccelerationThreshold      1.7
#define kUpdateInterval             (1.0f / 10.0f)

@interface EatViewController : UIViewController <UIAccelerometerDelegate>

@property (strong, nonatomic) NSNumber *points;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoBubbleLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIImageView *bowlImageView;
@property (weak, nonatomic) IBOutlet UIImageView *petImageView;
@property (weak, nonatomic) IBOutlet UIImageView *infoBubbleImageView;

@property (assign, nonatomic) BOOL fullBowl;
@property (strong, nonatomic) CMMotionManager *motionManager;
@property (strong, nonatomic) UIImage *empty;
@property (strong, nonatomic) UIImage *full;
@property (strong, nonatomic) NSArray *shakes;



-(IBAction)goBack: (id)sender;
-(IBAction)eat:(id)sender;

@end
