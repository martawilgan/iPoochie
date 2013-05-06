//
//  PlayViewController.h
//  iPoochie
//
//  Created by marta wilgan on 4/29/13.
//  Copyright (c) 2013 NYU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface PlayViewController : UIViewController

@property (strong, nonatomic) NSNumber *points;
@property (strong, nonatomic) NSDate *timeInView;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) CMMotionManager *motionManager;
@property (weak, nonatomic) IBOutlet UIView *play;
-(IBAction)goBack: (id)sender;

@end
