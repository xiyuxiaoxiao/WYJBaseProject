//
//  YJSlideMenu.m
//  BaseProject
//
//  Created by ZSXJ on 2018/10/16.
//  Copyright © 2018年 WYJ. All rights reserved.
//

#import "YJSlideMenu.h"
#import "XLSlideMenu.h"
#import "SlideLeftVC.h"
#import "SlideRightVC.h"
#import "SlideRootVC.h"

@interface YJSlideMenu ()

@end

@implementation YJSlideMenu

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self creat];
}
- (void)creat {
    
    UIViewController *rootVC = [[SlideRootVC alloc] init];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:rootVC];
    
    XLSlideMenu *slideMenu = [[XLSlideMenu alloc] initWithRootViewController:nc];
    
    UIViewController *leftVC = [[SlideLeftVC alloc] init];
    UIViewController *rightVC = [[SlideRightVC alloc] init];
    slideMenu.leftViewController = leftVC;
    slideMenu.rightViewController = rightVC;
    
    [self presentViewController:slideMenu animated:YES completion:nil];
}

@end
