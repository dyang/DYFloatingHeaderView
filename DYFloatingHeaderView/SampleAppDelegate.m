//
//  SampleAppDelegate.m
//  DYFloatingHeaderView
//
//  Created by Derek Yang on 09/11/12.
//  Copyright (c) 2012 iappexperience.com. All rights reserved.
//

#import "SampleAppDelegate.h"
#import "SampleHomeViewController.h"

@implementation SampleAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[SampleHomeViewController alloc] init]];
    [self.window makeKeyAndVisible];
    return YES;
}

@end