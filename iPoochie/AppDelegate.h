//
//  AppDelegate.h
//  iPoochie
//
//  Created by marta wilgan on 4/17/13.
//  Copyright (c) 2013 NYU. All rights reserved.
//

#import <UIKit/UIKit.h>

#define itemsFileName          @"items.plist"
#define gameFileName           @"game.plist"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UIWindow *window;
    UITabBarController *rootController;
	NSDictionary *itemsData;
    NSDictionary *gameData;
    NSString *itemsDataPath;
    NSString *gameDataPath;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) IBOutlet UITabBarController *rootController;
@property (nonatomic, retain) NSDictionary *itemsData;
@property (nonatomic, retain) NSDictionary *gameData;
@property (strong, nonatomic) NSString *itemsDataPath;
@property (strong, nonatomic) NSString *gameDataPath;

- (NSString *) pathForName : (NSString *) fileName;

@end
