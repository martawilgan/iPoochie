//
//  ClosetViewController.h
//  iPoochie
//
//  Created by marta wilgan on 4/17/13.
//  Copyright (c) 2013 NYU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClosetViewController : UIViewController
    <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *closet;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (strong, nonatomic) NSNumber *points;
@property (nonatomic, retain) NSArray *itemImageNames;
@property (nonatomic, retain) NSArray *itemAmounts;
@property (nonatomic, retain) NSArray *itemDescriptions;
@property (nonatomic, retain) NSArray *imageNames;
@property (nonatomic, retain) NSArray *amounts;
@property (nonatomic, retain) NSArray *descriptions;

- (void) currentData;

@end
