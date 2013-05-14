//
//  playView.h
//  iPoochie
//
//  Created by marta wilgan on 5/6/13.
//  Copyright (c) 2013 NYU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreMotion/CoreMotion.h>

@interface playView : UIView

@property (strong, nonatomic) NSDate *timingDate;
@property (strong, nonatomic) UIImage *left;
@property (strong, nonatomic) UIImage *right;
@property (strong, nonatomic) UIImage *item;
@property (strong, nonatomic) NSString *chosenItem;
@property (assign, nonatomic) CMAcceleration acceleration;
@property CGPoint itemPoint;
@property CGPoint currentPoint;
@property CGPoint previousPoint;
@property CGFloat petXVelocity;
@property CGFloat petYVelocity;

-(void) update;

@end
