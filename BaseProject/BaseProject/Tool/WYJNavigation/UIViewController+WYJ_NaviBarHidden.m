//
//  UIViewController+WYJ_NaviBarHidden.m
//  OmniChannelClient
//
//  Created by ZSXJ on 2018/7/18.
//  Copyright © 2018年 ZSXJ. All rights reserved.
//

#import <objc/runtime.h>
#import "NavigationImitateView.h"
@implementation UIViewController (WYJ_NaviBarHidden)

#pragma mark 隐藏导航栏
// 用于判断当前控制器是否需要隐藏导航栏 默认不需要隐藏 需要隐藏的控制器 只需要重写即可
- (BOOL)wyj_naviBarIsHidden {
    return NO;
}
- (BOOL)wyj_naviPopGRDisable {
    return NO;
}

#pragma mark -
+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(viewWillAppear:)),
                                   class_getInstanceMethod(self, @selector(wyjBarHidden_viewWillAppear:)));
    
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(viewWillDisappear:)),
                                   class_getInstanceMethod(self, @selector(wyjBarHidden_viewWillDisappear:)));
    
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(viewDidLoad)),
                                   class_getInstanceMethod(self, @selector(wyjBarHidden_viewDidLoad)));
    
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(setTitle:)),
                                   class_getInstanceMethod(self, @selector(wyjBarHidden_setTitle:)));
}
#pragma mark - super
- (void)wyjBarHidden_viewWillAppear:(BOOL)animated {
    [self wyjBarHidden_viewWillAppear:animated];
    
    if ([self wyj_naviBarIsHidden]) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
    
    [self.view bringSubviewToFront:self.wyj_naviView];
}

- (void)wyjBarHidden_viewWillDisappear:(BOOL)animated {
    [self wyjBarHidden_viewWillDisappear:animated];
    
    if ([self wyj_naviBarIsHidden] == NO) {
        return;
    }
    
    int pushNext = [self pushNextOrPop];
    // push下一个
    if (pushNext == 1) {
        if (NO == [self viewControllersPushIsHidden]) {
            [self.navigationController setNavigationBarHidden:NO animated:animated];
        }
        return;
    }
    // not Push
    if (NO == [self viewControllersPopIsHidden]) {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
}

// push : 1
// pop  : 0
- (int)pushNextOrPop {
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count-2] == self) {
        return 1; // push
    }
    return 0;
}

// 此处判断是否时隐藏的控制器 需要判断涉及的相关类 像扫描那个没有继承NaviHiddenController 就需要单独判断
// push下一个 是不是隐藏
- (BOOL)viewControllersPushIsHidden {
    NSArray *viewControllers = self.navigationController.viewControllers;
    UIViewController *vc = [viewControllers objectAtIndex:viewControllers.count-1];
    return [vc wyj_naviBarIsHidden];
}

// pop last上一个
- (BOOL)viewControllersPopIsHidden {
    NSArray *viewControllers = self.navigationController.viewControllers;
    UIViewController *vc = [viewControllers objectAtIndex:viewControllers.count-1];
    return [vc wyj_naviBarIsHidden];
}


// ================== 添加默认需要的自定义导航栏  ========================
#pragma mark - 添加默认需要的自定义导航栏
- (void)wyjBarHidden_viewDidLoad {
    [self wyjBarHidden_viewDidLoad];
    
    [self.view addSubview:self.wyj_naviView];
}

- (void)wyjBarHidden_setTitle:(NSString *)title {
    [self wyjBarHidden_setTitle:title];
    
    self.wyj_naviView.titleLabel.text = title;
}

#pragma mark get set wyj_naviView

- (NavigationImitateView *)wyj_naviView {
    if (objc_getAssociatedObject(self, _cmd) == nil) {
        if ([self wyj_naviBarIsHidden]) {
            [self wyj_NaviViewInit];
        }
    }
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setWyj_naviView:(NavigationImitateView *)wyj_naviView {
    objc_setAssociatedObject(self, @selector(wyj_naviView), wyj_naviView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)wyj_naviBackAction {
    if (self.wyj_naviView.popModel) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {    
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)wyj_NaviViewInit {
    NavigationImitateView *view = [NavigationImitateView initDefaule];
    view.titleLabel.text = self.title;
    [view.leftButton addTarget:self action:@selector(wyj_naviBackAction) forControlEvents:(UIControlEventTouchUpInside)];
    view.hidden = YES;
    self.wyj_naviView = view;
}


@end

