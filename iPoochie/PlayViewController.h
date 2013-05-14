//
//  PlayViewController.h
//  iPoochie
//
//  Created by marta wilgan on 4/29/13.
//  Copyright (c) 2013 NYU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import "playView.h"
#import "AppDelegate.h"

@interface PlayViewController : UIViewController <UIPickerViewDelegate,
UIPickerViewDataSource>

// Variables
@property (strong, nonatomic) CMMotionManager *motionManager;
@property (strong, nonatomic) NSNumber *points;
@property (strong, nonatomic) NSNumber *happiness;
@property (strong, nonatomic) NSNumber *health;
@property (strong, nonatomic) NSNumber *energy;
@property (strong, nonatomic) NSString *chosenItem;
@property (strong, nonatomic) NSArray *pickerData;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) NSMutableArray *amounts;
@property (strong, nonatomic) NSDate *timeInView;
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSMutableDictionary *itemsData;
@property (strong, nonatomic) NSMutableDictionary *gameData;

// Labels
@property (weak, nonatomic) IBOutlet UILabel *pickerLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *healthLabel;
@property (weak, nonatomic) IBOutlet UILabel *energyLabel;
@property (weak, nonatomic) IBOutlet UILabel *happinessLabel;

// ImageViews
@property (weak, nonatomic) IBOutlet UIImageView *healthImageView;
@property (weak, nonatomic) IBOutlet UIImageView *energyImageView;
@property (weak, nonatomic) IBOutlet UIImageView *happinessImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *infoImageView;

// Other Views
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIView *playView;

// Buttons
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;

// Helper Methods
-(void) updateAllLabels;
-(void) leavingUpdatesWithAlert: (NSString*) withAlert;
- (NSString*) barsImageName: (int) number;

// Actions
-(IBAction) goBack: (id)sender;
-(IBAction) chooseItem:(id)sender;
-(IBAction) infoAlert:(id)sender;

// Picker Data Source and Delegate Methods
-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView;
-(NSInteger) pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component;
-(UIView *) pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view;
-(CGFloat) pickerView:(UIPickerView *)pickerView
    widthForComponent:(NSInteger)component;

@end
