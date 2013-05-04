//
//  MatchingViewController.h
//  iPoochie
//
//  Created by Ilana Mannine on 5/3/13.
//  Copyright (c) 2013 NYU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatchingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (strong, nonatomic) NSNumber *points;

- (IBAction)card1:(UIButton *)sender;
- (IBAction)card2:(UIButton *)sender;
- (IBAction)card3:(UIButton *)sender;
- (IBAction)card4:(UIButton *)sender;
- (IBAction)card5:(UIButton *)sender;
- (IBAction)card6:(UIButton *)sender;
- (IBAction)card7:(UIButton *)sender;
- (IBAction)card8:(UIButton *)sender;
- (IBAction)card9:(UIButton *)sender;
- (IBAction)card10:(UIButton *)sender;
- (IBAction)card11:(UIButton *)sender;
- (IBAction)card12:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *card2;

- (IBAction)goBack:(id)sender;

@end
