//
//  MatchingViewController.h
//  iPoochie
//
//  Created by Ilana Mannine on 5/3/13.
//  Copyright (c) 2013 NYU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface MatchingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (strong, nonatomic) NSNumber *points;

@property (weak, nonatomic) IBOutlet UIButton *card1;
@property (weak, nonatomic) IBOutlet UIButton *card2;
@property (weak, nonatomic) IBOutlet UIButton *card3;
@property (weak, nonatomic) IBOutlet UIButton *card4;
@property (weak, nonatomic) IBOutlet UIButton *card5;
@property (weak, nonatomic) IBOutlet UIButton *card6;
@property (weak, nonatomic) IBOutlet UIButton *card7;
@property (weak, nonatomic) IBOutlet UIButton *card8;
@property (weak, nonatomic) IBOutlet UIButton *card9;
@property (weak, nonatomic) IBOutlet UIButton *card10;
@property (weak, nonatomic) IBOutlet UIButton *card11;
@property (weak, nonatomic) IBOutlet UIButton *card12;

- (IBAction)cardPressed:(UIButton *)sender;

- (IBAction)goBack:(id)sender;

@end
