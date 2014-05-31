//
//  AppDelegate.m
//  Basil
//
//  Created by Stephanie Szeto on 5/14/14.
//  Copyright (c) 2014 projects. All rights reserved.
//

#import "AppDelegate.h"
#import "TipViewController.h"
#import "CameraViewController.h"
#import "SettingsViewController.h"
#import "ReceiptsViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    // coloring
    application.statusBarHidden = NO;
    application.statusBarStyle = UIStatusBarStyleLightContent;
    
    UITabBarController *tbc = [[UITabBarController alloc] init];
    
    // set up view controllers
    TipViewController *tvc = [[TipViewController alloc] init];
    UINavigationController *tnc = [[UINavigationController alloc] initWithRootViewController:tvc];
    CameraViewController *cvc = [[CameraViewController alloc] init];
    UINavigationController *cnc = [[UINavigationController alloc] initWithRootViewController:cvc];
    ReceiptsViewController *rvc = [[ReceiptsViewController alloc] init];
    UINavigationController *rnc = [[UINavigationController alloc] initWithRootViewController:rvc];
    SettingsViewController *svc = [[SettingsViewController alloc] init];
    
    // set default tip percentages if they don't exist
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"tipPercentFloats"]) {
        [defaults setObject:@[@(0.15), @(0.18), @(0.2)] forKey:@"tipPercentFloats"];
        [defaults setObject:@[@(15), @(18), @(20)] forKey:@"tipPercentInts"];
        [defaults synchronize];
    }
    
    tbc.viewControllers = @[tnc, cnc, rnc, svc];
    self.window.rootViewController = tbc;
    
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

@end
