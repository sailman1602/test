//
//  AppDelegate.m
//  VideoTest
//
//  Created by YNZMK on 2019/4/13.
//  Copyright © 2019 YNZMK. All rights reserved.
//

#import "AppDelegate.h"
#import "switchVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    switchVC *v = [switchVC newWithSelectedIndex:0];
//    RTRootNavigationController *nav = [[RTRootNavigationController alloc] initWithRootViewController:v];
    self.window.rootViewController = v;
    [self.window makeKeyAndVisible];
    [self setStatusbarAndNavigationBarAppearance];
    return YES;
}

- (void)setStatusbarAndNavigationBarAppearance{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage newWithColor:UIColorFromRGB(0xffffff)] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x000000), NSFontAttributeName:HXBoldFont(18)}];
    [[UINavigationBar appearance] setTintColor:UIColorFromRGB(0x000000)];
    [UINavigationBar appearance].translucent = NO;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
