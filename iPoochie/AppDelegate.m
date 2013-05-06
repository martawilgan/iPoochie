//
//  AppDelegate.m
//  iPoochie
//
//  Created by marta wilgan on 4/17/13.
//  Copyright (c) 2013 NYU. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
@synthesize window;
@synthesize rootController;
@synthesize motionManager;
@synthesize itemsData;
@synthesize gameData;
@synthesize itemsDataPath;
@synthesize gameDataPath;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    
    // copy plist to documents and set their paths
    [self pathForComponent:itemsFileName];
    [self pathForComponent:gameFileName];
    
    // Load data from plists
    itemsData = [[NSDictionary alloc] initWithContentsOfFile:itemsDataPath];
    gameData = [[NSDictionary alloc] initWithContentsOfFile:gameDataPath];
    
    // Init motion manager
    self.motionManager = [[CMMotionManager alloc] init];
        
    // Add subview rootController to the TabBarController
    [[NSBundle mainBundle] loadNibNamed:@"TabBarController" owner:self options:nil];
    //[self.window addSubview:rootController.view];
    [self.window setRootViewController:rootController];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void) pathForComponent: (NSString *) fileName
{
    BOOL success;
    NSError *error;

    // See if file is present in documents folder
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    success = [fileManager fileExistsAtPath:filePath];
    
    if (success)
    {
        if([fileName isEqualToString:@"items.plist"])
        {
            itemsDataPath = filePath;
        }
        else if([fileName isEqualToString:@"game.plist"])
        {
            gameDataPath = filePath;
        }
        
        return;
    }

    // Otherwise copy the file over
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
    success = [fileManager copyItemAtPath:path toPath:filePath error:&error];
    
    if(success)
    {
        if([fileName isEqualToString:@"items.plist"])
        {
            itemsDataPath = filePath;
        }
        else if([fileName isEqualToString:@"game.plist"])
        {
            gameDataPath = filePath;
        }
    }

    if (!success)
    {
        NSAssert1(0, @"Failed to copy Plist. Error %@", [error localizedDescription]);
    }
}

@end
