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

@property (strong, nonatomic) UIImage *left;
@property (strong, nonatomic) UIImage *right;
@property (strong, nonatomic) UIImage *toy;
@property CGPoint toyPoint;
@property CGPoint currentPoint;
@property CGPoint previousPoint;
@property (assign, nonatomic) CMAcceleration acceleration;
@property CGFloat petXVelocity;
@property CGFloat petYVelocity;

-(void) update;

@end
