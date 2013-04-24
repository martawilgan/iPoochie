//
//  AppDelegate.h
//  iPoochie
//
//  Created by marta wilgan on 4/17/13.
//  Copyright (c) 2013 NYU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UIWindow *window;
    UITabBarController *rootController;
	NSDictionary *itemsData;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) IBOutlet UITabBarController *rootController;
@property (nonatomic, retain) NSDictionary *itemsData;

@end
