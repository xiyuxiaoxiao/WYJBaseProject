//
//  WYJNavigationController.m
//  BaseProject
//
//  Created by 潇雨 on 2021/7/1.
//  Copyright © 2021 WYJ. All rights reserved.
//

#import "WYJNavigationController.h"
#import "WYJNavigation.h"
@interface WYJNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation WYJNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setCustomGestureRecognizer];
}

- (void)setCustomGestureRecognizer {
    // 获取系统自带滑动手势的target对象
    id target = self.interactivePopGestureRecognizer.delegate;
    
    // 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:NSSelectorFromString(@"handleNavigationTransition:")];
    
    // 设置手势代理，拦截手势触发
    pan.delegate = self;
    
    // 给导航控制器的view添加全屏滑动手势
    [self.view addGestureRecognizer:pan];
    
    // 禁止使用系统自带的滑动手势
    self.interactivePopGestureRecognizer.enabled = NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 注意：只有非根控制器才有滑动返回功能，根控制器没有。
    // 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
    if (self.childViewControllers.count == 1) {
        // 表示用户在根控制器界面，就不需要触发滑动手势，
        return NO;
    }
    
    
    UIViewController *topViewController = self.childViewControllers.lastObject;
    if ([topViewController wyj_naviPopGRDisable]) {
        return NO;
    }
    
    // 与系统的一直 只在左侧的时候允许返回
    CGPoint location = [gestureRecognizer locationInView:self.view];
    CGPoint offSet = [gestureRecognizer locationInView:gestureRecognizer.view];
    BOOL ret = (0 < offSet.x && location.x <= 40);
    return ret;
    
//    return YES;
}
@end
