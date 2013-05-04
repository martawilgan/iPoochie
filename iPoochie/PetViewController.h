//
//  PetViewController.h
//  iPoochie
//
//  Created by marta wilgan on 4/29/13.
//  Copyright (c) 2013 NYU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PetViewController : UIViewController

@property (strong, nonatomic) NSNumber *points;
@property (strong, nonatomic) NSArray *wagging1;
@property (strong, nonatomic) NSArray *wagging2;
@property (strong, nonatomic) NSDate *timingDate;

@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *talkLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *happinessLabel;
@property (weak, nonatomic) IBOutlet UILabel *happinessStatLabel;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIImageView *talkImageView;
@property (weak, nonatomic) IBOutlet UIImageView *petImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bubbleImageView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UIImageView *happinessBarImageView;

-(IBAction)goBack: (id)sender;
-(NSString*) nextImageName;
-(void) updateIndex;
-(void)petting:(NSTimer*)inTimer;
-(void)stopped:(NSTimer*)inTimer;

@end
