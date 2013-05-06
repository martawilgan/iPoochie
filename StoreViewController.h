//
//  StoreViewController.h
//  iPoochie
//
//  Created by marta wilgan on 4/17/13.
//  Copyright (c) 2013 NYU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import<AudioToolbox/AudioToolbox.h>

@interface StoreViewController : UIViewController <UIPickerViewDelegate,
    UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UIPickerView *itemPicker;
@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) NSArray *prices;
@property (strong, nonatomic) NSMutableArray *amounts;
@property (strong, nonatomic) NSArray *pickerData;
@property (strong, nonatomic) NSNumber *points;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;

-(IBAction)buttonPressed;

@end
