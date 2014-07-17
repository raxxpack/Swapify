//
//  AppDelegate.m
//  raxxFaceSwap
//
//  Created by Rahim Mitha on 1/29/2014.
//  Copyright (c) 2014 Rahim Mitha. All rights reserved.
//

#import "AppDelegate.h"
#import "MenuViewController.h"
#import "MaskViewController.h"
#import "TWTSideMenuViewController.h"
#import "raxxWindow.h"

@interface AppDelegate ()

@property (nonatomic, strong) TWTSideMenuViewController *sideMenuViewController;
@property (nonatomic, strong) MenuViewController *menuViewController;
@property (nonatomic, strong) MaskViewController *mainViewController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[raxxWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
	self.menuViewController = [[MenuViewController alloc] initWithNibName:nil bundle:nil];
    self.mainViewController = [[MaskViewController alloc] initWithNibName:nil bundle:nil];
    
    self.sideMenuViewController = [[TWTSideMenuViewController alloc] initWithMenuViewController:self.menuViewController mainViewController:[[UINavigationController alloc] initWithRootViewController:self.mainViewController]];
    self.sideMenuViewController.shadowColor = [UIColor blackColor];
    self.sideMenuViewController.edgeOffset = (UIOffset) { .horizontal = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 18.0f : 0.0f };
    self.sideMenuViewController.zoomScale = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 0.5634f : 0.85f;
    self.sideMenuViewController.delegate = self;
    self.window.rootViewController = self.sideMenuViewController;

    
    self.window.backgroundColor = [UIColor grayColor];
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

@end
