//
//  ChanceViewController.h
//  iPoochie
//
//  Created by Ilana Mannine on 5/4/13.
//  Copyright (c) 2013 NYU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface ChanceViewController : UIViewController

@property (strong, nonatomic) NSNumber *points;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *chanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *chanceCard;
@property (weak, nonatomic) IBOutlet UIImageView *chanceImage;

- (IBAction)viewCard:(UIButton *)sender;
- (IBAction)goBack:(id)sender;


@end
