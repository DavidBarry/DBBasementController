//
//  DBAppDelegate.m
//  DBBasementExample
//
//  Created by David Barry on 4/19/13.
//  Copyright (c) 2013 David Barry. All rights reserved.
//

#import "DBAppDelegate.h"
#import "DBBasementController.h"
#import "DBMenuViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DBAnimationDetailsViewController.h"
#import "DBAppearanceManager.h"

@implementation DBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [DBAppearanceManager applyAppearance];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    DBMenuViewController *menuViewController = [DBMenuViewController new];
    DBAnimationDetailsViewController *contentViewController = [DBAnimationDetailsViewController new];
    UINavigationController *navigatonController = [[UINavigationController alloc] initWithRootViewController:contentViewController];
    
    DBBasementOptions *options = [DBBasementOptions new];
    
    options.openMenuContentTransform = CGAffineTransformMakeTranslation(0.0f, 504.0f); //Vertical
    options.closedMenuTransform = CGAffineTransformMakeTranslation(0.0f, -60.0f);
    
//    options.openMenuContentTransform = CGAffineTransformMakeTranslation(280.0f, 20.0f); //Under Status Bar
//    options.closedMenuTransform = CGAffineTransformMakeTranslation(-60.0f, 0.0f);
    
    options.bounceOnOpenAndClose = NO;
    options.bounceWhenNavigating = NO;
    DBBasementController *basementController = [[DBBasementController alloc] initWithMenuViewController:menuViewController contentViewController:navigatonController options:options];
    self.window.backgroundColor = [UIColor blackColor];
    self.window.rootViewController = basementController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
