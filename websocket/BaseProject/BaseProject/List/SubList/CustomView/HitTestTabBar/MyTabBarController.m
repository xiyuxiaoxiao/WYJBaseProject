//
//  MyTabBarController.m
//  BaseProject
//
//  Created by ZSXJ on 2017/5/27.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import "MyTabBarController.h"
#import "MyTabBar.h"

@interface MyTabBarController ()<MyTabBarDelegate>

@end

@implementation MyTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MyTabBar *myTabBar = [[MyTabBar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 49)];
    myTabBar.myTabBarDelegate = self;
    
    [self setValue:myTabBar forKey:@"tabBar"];
    
    UIViewController *vc1 = [[UIViewController alloc] init];
    vc1.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    vc1.view.backgroundColor = [UIColor yellowColor];
    vc1.tabBarItem.title = @"第一个";
    
    UIViewController *vc2 = [[UIViewController alloc] init];
    vc2.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    vc2.view.backgroundColor = [UIColor orangeColor];
    vc2.tabBarItem.title = @"第二个";
    
    self.viewControllers = @[vc1,vc2];
    
    self.tabBarItem.imageInsets = UIEdgeInsetsMake(0, -30, 0, -30);
}

#pragma mark MyTabBarDelegate
- (void)addButtonClick:(MyTabBar *)tabBar {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"test" message:@"Test" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"test" style:UIAlertActionStyleDefault handler:nil];
    [controller addAction:action];
    [self presentViewController:controller animated:YES completion:nil];
}

@end
