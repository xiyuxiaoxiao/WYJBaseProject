//
//  AppDelegate.m
//  BaseProject
//
//  Created by ZSXJ on 2017/4/10.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound + UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
    }];
    
    //设置启动页隐藏状态栏
    [application setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationFade)];
    
    Class class = NSClassFromString(@"EnterListController");
    UIViewController *vc = [[class alloc] init];
    UINavigationController *nc = [[NSClassFromString(@"WYJNavigationController") alloc] initWithRootViewController: vc];
    nc.navigationBar.translucent = NO;
    self.window.rootViewController = nc;
    
    return YES;
}

- (UIViewController *)getNewVC: (UIViewController *)vc {
    UINavigationController *nc = [[UINavigationController alloc] init];
    nc.viewControllers = @[vc];
    
    UIViewController *viewController = [[UIViewController alloc] init];
    [viewController.view addSubview:nc.view];
    [viewController addChildViewController:nc];
    
    return viewController;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
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
