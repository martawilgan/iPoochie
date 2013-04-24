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

/*{
    NSDictionary *items;
    IBOutlet UITableView *myTableView;
    NSArray *itemImageNames;
    NSArray *itemAmounts;
    NSArray *imageNames;
    NSArray *amounts;
}*/

@property (nonatomic, retain) NSArray *itemImageNames;
@property (nonatomic, retain) NSArray *itemAmounts;
@property (nonatomic, retain) NSArray *imageNames;
@property (nonatomic, retain) NSArray *amounts;

//-(NSString*) dataFilePath;

@end
