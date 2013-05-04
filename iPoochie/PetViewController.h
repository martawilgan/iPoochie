//
//  PetViewController.h
//  iPoochie
//
//  Created by marta wilgan on 4/29/13.
//  Copyright (c) 2013 NYU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PetViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *talkLabel;
@property (strong, nonatomic) NSNumber *points;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIImageView *talkImageView;
@property (weak, nonatomic) IBOutlet UIImageView *petImageView;

@property (strong, nonatomic) NSArray *wagging1;
@property (strong, nonatomic) NSArray *wagging2;

-(IBAction)goBack: (id)sender;
-(NSString*) nextImageName;
-(void) updateIndex;
-(void)petting:(NSTimer*)inTimer;
-(void)stopped:(NSTimer*)inTimer;

@end
