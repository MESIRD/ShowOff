//
//  AppDelegate.m
//  ShowOff
//
//  Created by mesird on 6/16/15.
//  Copyright (c) 2015 mesird. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "MeViewController.h"
#import "FlatUIKit.h"
#import <AVOSCloud/AVOSCloud.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

void uncaughtExceptionHandler(NSException *exception) {
    
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    // Internal error reporting
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);

    if ( [[NSUserDefaults standardUserDefaults] objectForKey:@"LocationPermission"] == nil) {
        NSLog(@"location permission is nil");
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"LocationPermission"];
    }
    
    [AVOSCloud setApplicationId:@"ul4sv1ch418fqxfvp7l4et3hskty7lawywxpiioch0fcgxok"
                      clientKey:@"6cg0di76vel7yyzxpkor09fgoc69pmtiitkga9oum926n4c8"];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
//    [UIBarButtonItem configureFlatButtonsWithColor:[UIColor turquoiseColor] highlightedColor:[UIColor belizeHoleColor] cornerRadius:3];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
