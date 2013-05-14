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

- (void) drawRect:(CGRect)rect;
- (id) initWithCoder:(NSCoder *)coder;
- (void) generateItemPoint;
- (void) update;
- (CGPoint) currentPoint;
- (void) setCurrentPoint:(CGPoint)newPoint;
- (void) success;
- (void) clearSuccess:(NSTimer*)inTimer;
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

@end
